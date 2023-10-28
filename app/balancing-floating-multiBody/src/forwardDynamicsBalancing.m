function chiDot = forwardDynamicsBalancing(t,chi,KinDynModel,Config)

    % FORWARDDYNAMICSBALANCING computes the forward dynamics of a floating
    %                          base system with contacts with the environment.
    %
    %                            REQUIRED VARIABLES:
    %
    %                            - Config: [struct] with fields:
    %
    %                                      - Model: [struct];
    %                                      - Simulator: [struct];
    %                                      - Visualization: [struct];
    %                                      - integration: [struct];
    %
    % FORMAT:  chiDot = forwardDynamicsBalancing(t,chi,KinDynModel,Config);
    %
    % INPUTS:  - t: current integration time step;
    %          - chi: [7+6+2*ndof x 1] current robot state;
    %          - KinDynModel: [struct] contains the loaded model and additional info;
    %          - Config: [struct] collects all the configuration parameters;
    %
    % OUTPUTS: - chiDot: [7+6+2*ndof x 1] current state derivative.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
        
    % update the waitbar
    if ~isempty(Config.integration.wait)
       waitbar(t/Config.integration.tEnd,Config.integration.wait);
    end
    
    % demux the system state
    [basePosQuat,jointPos,baseVel,jointVel] = wbc.vectorDemux(chi,[7,KinDynModel.NDOF,6,KinDynModel.NDOF]);
    w_H_b = wbc.fromPosQuatToTransfMatr(basePosQuat);
    
    % update the current system state
    iDynTreeWrappers.setRobotState(KinDynModel,w_H_b,jointPos,baseVel,jointVel,Config.Model.gravityAcc);
    
    % evaluate system's dynamics quantities
    M          = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    biasForces = iDynTreeWrappers.generalizedBiasForces(KinDynModel);
    B          = [zeros(6,KinDynModel.NDOF);
                  eye(KinDynModel.NDOF)];
    
    % contact Jacobians and derivative
    J_contacts       = [];
    JDot_nu_contacts = [];
    
    for k = 1:length(Config.Model.fixedFrames)
        
        J_contacts       = [J_contacts;
                            iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.Model.fixedFrames{k})]; %#ok<AGROW>
                  
        JDot_nu_contacts = [JDot_nu_contacts;
                            iDynTreeWrappers.getFrameBiasAcc(KinDynModel, Config.Model.fixedFrames{k})];            %#ok<AGROW>
    end

    % joint torques: simple position control
    Kp         = 500;
    tau        = -Kp*(jointPos - Config.Model.jointPos_init);

    % compute the feet forces and moments (rigid contacts, feet fixed)
    JMinv      = J_contacts/M;
    JMinvJt    = JMinv*J_contacts';
    f_contacts = JMinvJt\(JMinv*(biasForces-B*tau)-JDot_nu_contacts);
    
    % compute the state derivative
    baseOmega  = baseVel(4:6);
    qtDot      = wbc.quaternionDerivative(basePosQuat(4:end),baseOmega,1);
    nuDot      = M\(J_contacts'*f_contacts + B*tau - biasForces);
    chiDot     = [baseVel(1:3); qtDot; jointVel; nuDot]; 
    
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
