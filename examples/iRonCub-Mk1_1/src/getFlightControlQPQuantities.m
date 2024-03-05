function [Hessian, gradient, lowerBound, upperBound] = getFlightControlQPQuantities(KinDynModel, w_R_b, posCoM, M, L, ...
        pos_vel_acc_jerk_com_des, rot_vel_acc_jerk_base_des, KP_momentum, KD_momentum, Config)

    % compute useful parameters and references
    m      = M(1,1);

    %% MOMENTUM-RELATED QUANTITIES

    % matrix that maps jets intensities in centroidal momentum derivative
    Aj     = Config.kinDynJetsWrapper.getJetsMappingMomentum(KinDynModel, posCoM, Config);
    Aj_lin = Aj(1:3, :);
    Aj_ang = Aj(4:6, :);

    % momentum and integral
    int_l  = m*posCoM;
    l      = L(1:3);
    w      = L(4:6);

    %% HOVERING CONTROLLER DESIGN

    % ----------------------------------------------------------------------- %
    % Desired tasks Dynamics:
    %
    % 1) desired linear momentum derivative:
    %
    %    linMomDot_star = lDot_star -KD*(l-l_star) -KP*(int_l - int_l_star)
    %
    % 2) desired angular momentum derivative:
    %
    %    angMomDot_star = wDot_star -KD*(w-w_star) -KP*baseRotError
    % ----------------------------------------------------------------------- %

    % compute references
    int_l_star = m*pos_vel_acc_jerk_com_des(:,1);
    l_star     = m*pos_vel_acc_jerk_com_des(:,2);
    lDot_star  = m*pos_vel_acc_jerk_com_des(:,3);

    w_star     = rot_vel_acc_jerk_base_des(:,4);
    wDot_star  = rot_vel_acc_jerk_base_des(:,5);

    % reference linear momentum dynamics
    linMomDot_star = lDot_star -KD_momentum(1:3,1:3)*(l-l_star) -KP_momentum(1:3,1:3)*(int_l - int_l_star);

    % reference angular momentum dynamics
    baseRotError   = wbc.skewVee(w_R_b*transpose(rot_vel_acc_jerk_base_des(1:3,1:3)));
    angMomDot_star = wDot_star -KD_momentum(4:6,4:6)*(w-w_star) -KP_momentum(4:6,4:6)*baseRotError;

    %% QP TASKS

    % ----------------------------------------------------------------------- %
    % Tasks to be added to the QP cost function

    % LINEAR MOMENTUM TASK (XY)
    H_linMom_xy =  transpose(Aj_lin(1:2,:))*Aj_lin(1:2,:);
    g_linMom_xy = -transpose(Aj_lin(1:2,:))*linMomDot_star(1:2);

    % add weights
    H_linMom_xy = Config.weightsQP.linMom_xy * H_linMom_xy;
    g_linMom_xy = Config.weightsQP.linMom_xy * g_linMom_xy;

    % LINEAR MOMENTUM TASK (Z)
    H_linMom_z =  transpose(Aj_lin(3,:))*Aj_lin(3,:);
    g_linMom_z = -transpose(Aj_lin(3,:))*(linMomDot_star(3)-M(1,1)*Config.gravityAcc(3));

    % add weights
    H_linMom_z = Config.weightsQP.linMom_z * H_linMom_z;
    g_linMom_z = Config.weightsQP.linMom_z * g_linMom_z;

    % ----------------------------------------------------------------------- %

    % ANGULAR MOMENTUM TASK (PITCH-ROLL)
    H_angMom_rp =  transpose(Aj_ang(1:2,:))*Aj_ang(1:2,:);
    g_angMom_rp = -transpose(Aj_ang(1:2,:))*angMomDot_star(1:2);

    % add weights
    H_angMom_rp = Config.weightsQP.angMom_rp * H_angMom_rp;
    g_angMom_rp = Config.weightsQP.angMom_rp * g_angMom_rp;

    % ANGULAR MOMENTUM TASK (YAW)
    H_angMom_y =  transpose(Aj_ang(3,:))*Aj_ang(3,:);
    g_angMom_y = -transpose(Aj_ang(3,:))*angMomDot_star(3);

    % add weights
    H_angMom_y = Config.weightsQP.angMom_y * H_angMom_y;
    g_angMom_y = Config.weightsQP.angMom_y * g_angMom_y;

    % ----------------------------------------------------------------------- %
    % Build the QP cost function (Hessian matrix and gradient)
    Hessian  = H_linMom_xy + H_linMom_z + H_angMom_rp + H_angMom_y;

    % regularization of the Hessian. Enforce symmetry and positive definiteness
    Hessian  = 0.5 * (Hessian + transpose(Hessian)) + eye(size(Hessian,1)) * Config.tasksQP.reg_HessianQP;

    % compute the gradient
    gradient = g_linMom_xy + g_linMom_z + g_angMom_rp + g_angMom_y;

    %% QP BOUNDARIES

    % ----------------------------------------------------------------------- %
    % QP input boundaries. They are of the form:
    %
    % lb <= u <= ub
    %
    upperBound = Config.inequalitiesQP.maxJetsInt;
    lowerBound = Config.inequalitiesQP.idleJetsInt;
end
