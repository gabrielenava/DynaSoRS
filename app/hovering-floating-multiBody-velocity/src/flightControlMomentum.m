function [HessianMatrix, gradient, lowerBound, upperBound] = flightControlMomentum(posCoM, jointPos, w_baseTwist, jetsIntensities, J_jets, J_CoM, w_R_b, ...
                                                                                   matrixOfJetsAxes, matrixOfJetsArms, M, CMM, pos_vel_acc_jerk_CoM_des, rot_vel_acc_jerk_base_des, ....
                                                                                   jointPos_des, KP_momentum, KD_momentum, KO_momentum, KP_postural, Config)
                               
    % compute the number of degrees of freedom, robot total mass and gravity  
    ndof    = Config.Model.nDof;
    m       = M(1,1);
    f_grav  = [m*Config.Model.gravityAcc; zeros(3,1)];
        
    % compute momentum references and demux jet axes and arms
    [LDDot_des, LDot_des, L_des, intL_des]               = iRonCubLib.computeMomentumReferences(pos_vel_acc_jerk_CoM_des, m);
    [r_J1, r_J2, r_J3, r_J4, ax_J1, ax_J2, ax_J3, ax_J4] = iRonCubLib.demuxJetAxesAndArms(matrixOfJetsAxes, matrixOfJetsArms);
    
    %% %%%%%%%%%%%%%%% COMPUTE THE MOMENTUM ACCELERATION %%%%%%%%%%%%%%% %%
    %
    % SIMPLIFIED MODEL: the momentum acceleration has the following form: 
    %
    %   LDDot = Aj*jetsIntensitiesDot + Lambda_js*sDot + Lambda_jb*w_baseTwist (1)
    %
    % it is therefore necessary to compute Aj, Lambda_js, Lambda_jb.

    % multiplier of jetsIntensitiesDot in the angular momentum equations 
    Aj_angular      = [wbc.skew(r_J1) * ax_J1, ...
                       wbc.skew(r_J2) * ax_J2, ...
                       wbc.skew(r_J3) * ax_J3, ...
                       wbc.skew(r_J4) * ax_J4];
              
    % multiplier of jetsIntensitiesDot in the linear momentum equations                 
    Aj_linear       = matrixOfJetsAxes;
    
    % compute matrix Aj
    Aj              = [Aj_linear; Aj_angular];
       
    % J_jr = J_j - J_ext is the map from the derivative of "r_Ji" and the 
    % angular velocity of the turbine frame "omega_Ji" to the state velocities.
    J_ext           = [J_CoM; zeros(3,ndof+6); J_CoM; zeros(3,ndof+6); J_CoM; zeros(3,ndof+6); J_CoM; zeros(3,ndof+6)];
    J_jr            = J_jets - J_ext;
    
    % multipliers of the state velocities in the momentum acceleration equations
    
    % terms related to the thrust forces
    Lambda_j        = -[jetsIntensities(1) * iRonCubLib.skewZeroBar(ax_J1),...
                        jetsIntensities(1) * iRonCubLib.skewBar(r_J1) * wbc.skew(ax_J1),...
                        jetsIntensities(2) * iRonCubLib.skewZeroBar(ax_J2),...
                        jetsIntensities(2) * iRonCubLib.skewBar(r_J2) * wbc.skew(ax_J2),...
                        jetsIntensities(3) * iRonCubLib.skewZeroBar(ax_J3),...
                        jetsIntensities(3) * iRonCubLib.skewBar(r_J3) * wbc.skew(ax_J3),...
                        jetsIntensities(4) * iRonCubLib.skewZeroBar(ax_J4),...
                        jetsIntensities(4) * iRonCubLib.skewBar(r_J4) * wbc.skew(ax_J4)] * J_jr;
   
    % isolate Lambda_jb and Lambda_js
    Lambda_jb       = Lambda_j(:,1:6);
    Lambda_js       = Lambda_j(:,7:end);
    
    %% %%%%%%%%%%%%%%%%%%%  CONTROLLER DEFINITION  %%%%%%%%%%%%%%%%%%%%% %%
    %
    % The control inputs of Eq. (1) are: 
    %
    %  u1 = jetsIntensitiesDot
    %  u2 = sDot
    %
    % The robot momentum converges to the desired values if the following 
    % equation is verified:
    %
    %  ATilde * u1 + BTilde * u2 + deltaTilde = 0 (2)
    %
    % where: ATilde, BTilde and deltaTilde must be properly calculated.       
   
    % split the centroidal momentum matrix into the relation between the 
    % momentum and the base and joint velocities, respectively
    JL_b             = CMM(:,1:6); 
    JL_s             = CMM(:,7:ndof+6); 
    
    % compute the momentum error derivative/integral
    LDot_estimated   = Aj * jetsIntensities + f_grav;
    LDot_tilde       = LDot_estimated - LDot_des;
    intL_tilde       = [(m*posCoM - intL_des(1:3)); zeros(3,1)];
    
    % substitute the angular momentum integral with the base orientation control in SO(3)
    intL_tilde(4:6)  = wbc.skewVee(w_R_b * rot_vel_acc_jerk_base_des(1:3,1:3)');
    
    % momentum-based control with Lyapunov stability (IEEE-RAL 2018)
    KTilde           = KP_momentum + inv(KO_momentum) + KD_momentum;  
    ATilde           = Aj;
    BTilde           = Lambda_js + KTilde * JL_s;
    deltaTilde       = (Lambda_jb + KTilde * JL_b) * w_baseTwist - KTilde * L_des - LDDot_des + ...
                       (KD_momentum + eye(6)) * LDot_tilde + KP_momentum * intL_tilde; 
    
    %% Control design as a QP problem
    
    % Primary tasks to be added to the cost function: momentum control
    H_momentum       = transpose([ATilde, BTilde]) * [ATilde, BTilde];
    g_momentum       = transpose([ATilde, BTilde]) * deltaTilde;
    
    % Secondary tasks to be added to the cost function: postural task
    H_postural       = blkdiag(zeros(4), eye(ndof));
    g_postural       = [zeros(4,1); KP_postural * (jointPos - jointPos_des)];
               
    %% Build the Hessian matrix and gradient
    
    % build the QP cost function (Hessian matrix and gradient)
    HessianMatrix  = Config.weights.postural * H_postural + Config.weights.momentum * H_momentum;

    
    % regularization of the Hessian. Enforce symmetry and positive definiteness 
    HessianMatrix  = 0.5 * (HessianMatrix + transpose(HessianMatrix)) + eye(size(HessianMatrix,1)) * Config.reg.hessianQp;
   
    % compute the gradient 
    gradient       = Config.weights.postural * g_postural + Config.weights.momentum * g_momentum;
    
    %% Upper and lower bounds of the control input u
    maxJointPos      =  Config.sat.jointPositionLimits(:,2);
    minJointPos      =  Config.sat.jointPositionLimits(:,1);
    maxJetsInt       =  Config.sat.maxJetsInt; 
    maxJetsIntVar    =  Config.sat.maxJetsIntVar;
    minJetsIntVar    = -Config.sat.maxJetsIntVar;
    maxJointVelDes   =  Config.sat.maxJointVelDes;
    minJointVelDes   = -Config.sat.maxJointVelDes;
    
    % include thrusts limits in the controller
    % 
    % we parametrized the boundaries of TDot (TDotMin/TDotMax) as follows:
    %
    %    TDotMin = tanh((T - Tmin) * eps) * TDotMin;
    %    TDotMax = tanh((Tmax - T) * eps) * TDotMax.
    %
    % with eps a positive value (the sharpness of the function).
    if Config.INCLUDE_THRUST_LIMITS
        
        for jj = 1:4
            
            eps               = Config.eps_thrust_limit;
            maxJetsIntVar(jj) = tanh((maxJetsInt(jj) - jetsIntensities(jj)) * eps) * maxJetsIntVar(jj);
            minJetsIntVar(jj) = tanh(jetsIntensities(jj) * eps) * minJetsIntVar(jj);
        end
    end
    
    % include joints limits in the controller. Same as the thrust limits
    % but for the joints positions.
    if Config.INCLUDE_JOINTS_LIMITS

        for jj = 1:ndof
             
            eps                = Config.eps_joint_limit;
            maxJointVelDes(jj) = tanh((maxJointPos(jj) - jointPos(jj)) * eps) * maxJointVelDes(jj);
            minJointVelDes(jj) = tanh((jointPos(jj) - minJointPos(jj)) * eps) * minJointVelDes(jj);
        end
    end
    
    upperBound = [maxJetsIntVar; maxJointVelDes];
    lowerBound = [minJetsIntVar; minJointVelDes]; 
end
