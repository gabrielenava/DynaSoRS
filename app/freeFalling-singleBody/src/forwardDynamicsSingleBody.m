function chiDot = forwardDynamicsSingleBody(t,chi,KinDynModel,Config)

    % FORWARDDYNAMICSSINGLEBODY  computes the forward dynamics of a free
    %                            falling body.
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
    % FORMAT:  chiDot = forwardDynamicsSingleBody(t,chi,KinDynModel,Config);
    %
    % INPUTS:  - t: current integration time step;
    %          - chi: [7+6 x 1] current robot state. Expected format:
    %                 chi = [basePosQuat; baseVel];
    %          - KinDynModel: [struct] contains the loaded model and additional info;
    %          - Config: [struct] collects all the configuration parameters;
    %
    % OUTPUTS: - chiDot: [7+6 x 1] current state derivative.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
        
    % update the waitbar
    if ~isempty(Config.integration.wait)
       waitbar(t/Config.integration.tEnd,Config.integration.wait);
    end
    
    % demux the system state
    [basePosQuat,baseVel] = wbc.vectorDemux(chi,[7,6]);
    w_H_b = wbc.fromPosQuatToTransfMatr(basePosQuat);
    
    % update the current system state
    iDynTreeWrappers.setRobotState(KinDynModel,w_H_b,[],baseVel,[],Config.Model.gravityAcc);
    
    % evaluate the system's dynamics
    M          = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    biasForces = iDynTreeWrappers.generalizedBiasForces(KinDynModel); 
    
    % evaluate system's base acceleration
    baseAcc    = M\(Config.Model.extForce - biasForces);
    
    posCoM     = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);
    posBase    = basePosQuat(1:3);
     
%     A_base     = [eye(3), zeros(3);
%                   wbc.skew(posCoM-basePosQuat(1:3)), eye(3)];
%     baseAcc    = M\(A_base*Config.Model.extForce-biasForces);
    
    baseOmega  = baseVel(4:6);
    qtDot      = wbc.quaternionDerivative(basePosQuat(4:end),baseOmega,1);
    
    % compute centroidal momentum L
    L          = iDynTreeWrappers.getCentroidalTotalMomentum(KinDynModel); 
    
    % compute CMM
    J_c        = zeros(6);
    
    for k = 1:6
        
       e    = zeros(6);
       e(k) = 1;       
       iDynTreeWrappers.setRobotState(KinDynModel,w_H_b,[],e,[],Config.Model.gravityAcc);
       J_c(:,k) = iDynTreeWrappers.getCentroidalTotalMomentum(KinDynModel);
    end
    
    iDynTreeWrappers.setRobotState(KinDynModel,w_H_b,[],baseVel,[],Config.Model.gravityAcc);

    L_check    = J_c*baseVel; 
    
    % calculate LDot
    rc         = posBase-posCoM;
    
    A          = [eye(3), zeros(3);
                  wbc.skew(rc), eye(3)];
              
    LDot       = A*Config.Model.extForce + [M(1,1)*Config.Model.gravityAcc;0;0;0];
    LDot_check = J_c*baseAcc;
    
    L_error    = L - L_check;       %#ok<NASGU>
    LDot_error = LDot - LDot_check; %#ok<NASGU>
    
    % compute the state derivative
    chiDot     = [baseVel(1:3); qtDot; baseAcc];  
    
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
                error('[forwardDynamicsSIngleMass]: "Config" and "KinDynModel" are reserved variables and cannot be saved in the MAT file.')
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
