function chiDot = forwardDynamicsHovering(t,chi,KinDynModel,Config)

    % FORWARDDYNAMICSHOVERING computes the forward dynamics of a floating
    %                          base system while hovering.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Jan 2022

    %% ------------Initialization----------------
        
    % update the waitbar
    if ~isempty(Config.integration.wait)
       waitbar(t/Config.integration.tEnd,Config.integration.wait);
    end
    
    % demux the system state
    [basePosQuat, jointPos, baseVel, jointVel, T, jointPosStar] = wbc.vectorDemux(chi,[7, KinDynModel.NDOF, 6, KinDynModel.NDOF, Config.jets.njets, KinDynModel.NDOF]);
    w_H_b = wbc.fromPosQuatToTransfMatr(basePosQuat);
    w_R_b = w_H_b(1:3,1:3);

    % update the current system state
    iDynTreeWrappers.setRobotState(KinDynModel, w_H_b, jointPos, baseVel, jointVel, Config.Model.gravityAcc);
    
    % evaluate system's dynamics quantities
    biasForces = iDynTreeWrappers.generalizedBiasForces(KinDynModel);
    B          = [zeros(6,KinDynModel.NDOF); eye(KinDynModel.NDOF)];
    
    % controller setup
    posCoM       = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);
    J_CoM        = iDynTreeWrappers.getCenterOfMassJacobian(KinDynModel);
    J_CoM        = J_CoM(1:3,:);
    M            = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    CMM_iDyntree = iDynTree.MatrixDynSize(6,KinDynModel.NDOF+6);
    KinDynModel.kinDynComp.getCentroidalTotalMomentumJacobian(CMM_iDyntree);
    CMM          = CMM_iDyntree.toMatlab;
              
    % jet forces in the equations of motion
    J_j    = [];
    J_jets = [];
    
    for k = 1:length(Config.jets.jetFrames)
        
        J_jet_i = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.jets.jetFrames{k});
        J_j     = [J_j; J_jet_i(1:3,:)]; %#ok<AGROW>
        J_jets  = [J_jets; J_jet_i]; %#ok<AGROW>
    end
    
    w_H_J1 = iDynTreeWrappers.getWorldTransform(KinDynModel, Config.jets.jetFrames{1});
    w_H_J2 = iDynTreeWrappers.getWorldTransform(KinDynModel, Config.jets.jetFrames{2});
    w_H_J3 = iDynTreeWrappers.getWorldTransform(KinDynModel, Config.jets.jetFrames{3});
    w_H_J4 = iDynTreeWrappers.getWorldTransform(KinDynModel, Config.jets.jetFrames{4});
    
    [matrixOfJetsAxes, matrixOfJetsArms] = iRonCubLib.computeJetsAxesAndArms(w_H_J1, w_H_J2, w_H_J3, w_H_J4, posCoM, Config);
    f_j                                  = iRonCubLib.fromJetsIntensitiesToForces(matrixOfJetsAxes, T);
    
    % high-level momentum control
    [jointVelStar, TDotStar] = momentumQPControl(posCoM, jointPos, w_R_b, baseVel, T, J_jets, J_CoM, ...
                                                 matrixOfJetsAxes, matrixOfJetsArms, M, CMM, Config);
    
    % joint torques: low-level velocity control
    Kp         =  50;
    Kd         =  2*sqrt(Kp);
    tau        = -Kd*(jointVel - jointVelStar) -Kp*(jointPos - jointPosStar);

    % compute the state derivative
    baseOmega  = baseVel(4:6);
    qtDot      = wbc.quaternionDerivative(basePosQuat(4:end),baseOmega,1);
    nuDot      = M\(B*tau - biasForces + J_j'*f_j);
    chiDot     = [baseVel(1:3); qtDot; jointVel; nuDot; TDotStar; jointVelStar]; 
    
    %% DATA STORAGE - DO NOT EDIT BELOW
    
    % update the MAT file that contains the data to plot
    if Config.Simulator.showSimulationResults || Config.Simulator.saveSimulationResults

        Config.Visualization.dataForVisualization   = struct;
        Config.Visualization.updatedVizVariableList = {};
        cont = 1;
        
        for k = 1:length(Config.Visualization.vizVariableList)
            
            if strcmp(Config.Visualization.vizVariableList{k},'Config') || strcmp(Config.Visualization.vizVariableList{k},'KinDynModel')
                
                % unpredictable things may happen if the user tries to save
                % the "core" variables Config and KinDynModel during integration
                error('[forwardDynamicsBalancing]: "Config" and "KinDynModel" are reserved variables and cannot be saved in the MAT file.')
            end
                
            % the variables whose name is specified in the "vizVariableList" 
            % must be accessible from this fuction, or the corresponding
            % variable name in the list is removed.
            if exist(Config.Visualization.vizVariableList{k},'var')
                 
                Config.Visualization.updatedVizVariableList{cont} = Config.Visualization.vizVariableList{k};
                Config.Visualization.dataForVisualization.(Config.Visualization.vizVariableList{k}) = eval(Config.Visualization.vizVariableList{k});
                cont = cont +1;
            end
        end    
        % update the MAT file with new data
        [~] = mbs.saveSimulationData(Config.Visualization,Config.Simulator,'update');    
    end
end
