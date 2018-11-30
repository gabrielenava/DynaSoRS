function chiDot = forwardDynamicsGravityComp(t,chi,KinDynModel,Config)

    % FORWARDDYNAMICSGRAVITYCOMP computes the forward dynamics of a fixed
    %                            base system with no contacts with the
    %                            environment (but the base link, which is 
    %                            fixed on ground). Joints torques are the
    %                            ones that compensate for gravity.
    %
    %                            REQUIRED:
    %
    %                            - Config: [struct] with fields:
    %
    %                                      - Simulator: [struct];
    %                                      - Visualization: [struct]; (partially created here)
    %                                      - initGravComp: [struct];
    %                                      - integration: [struct];
    %
    %                            For more information on the required fields inside
    %                            each structure, refer to the documentation inside
    %                            the "core" functions.
    %
    % FORMAT: chiDot = forwardDynamicsGravityComp(t,chi,KinDynModel,Config);
    %
    % INPUTS:  - t: current integration time step;
    %          - chi: [2*ndof x 1] current robot state. Expected format:
    %                 chi = [jointVel; jointPos];
    %          - KinDynModel: a structure containing the loaded model and additional info;
    %          - Config: structure collecting all the configuration parameters;
    %
    % OUTPUTS: - chiDot: [2*ndof x 1] current state derivative.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
        
    % update the waitbar
    if ~isempty(Config.integration.wait)
       waitbar(t/Config.integration.tEnd,Config.integration.wait);
    end
    
    % demux the system state
    [jointVel,jointPos] = vectorDemux(chi,[KinDynModel.NDOF,KinDynModel.NDOF]);

    % update the current system state
    idyn_setRobotState(KinDynModel,jointPos,jointVel,Config.initGravComp.gravityAcc);
    
    % evaluate the system's dynamics
    M          = idyn_getFreeFloatingMassMatrix(KinDynModel);
    biasForces = idyn_generalizedBiasForces(KinDynModel); 
    
    % select only the rows corresponding to the joint space dynamics
    Ms         = M(7:end,7:end);
    hs         = biasForces(7:end);
    
    % select the joint torques according to the demo
    tau        = idyn_generalizedGravityForces(KinDynModel); 
    tau        = tau(7:end);
    
    % compute the joints accelerations
    jointAcc   = Ms\(tau - hs);
    
    % compute the state derivative
    chiDot     = [jointAcc;jointVel];  
    
    % update the MAT file that contains the data to plot
    if Config.Simulator.showSimulationResults || Config.Simulator.saveSimulationResults

        Config.Visualization.dataForVisualization   = struct;
        Config.Visualization.updatedVizVariableList = {};
        cont = 1;
        
        for k = 1:length(Config.Visualization.vizVariableList)
            
            if strcmp(Config.Visualization.vizVariableList{k},'Config') || strcmp(Config.Visualization.vizVariableList{k},'KinDynModel')
                
                % unpredictable things may happen if the user tries to save
                % the "core" variables Config and KinDynModel dunring integration
                error('[forwardDynamicsGravityComp]: "Config" and "KinDynModel" are reserved variables and cannot be saved in the MAT file.')
            end
                
            % the variables whose name is specified in the "vizVariableList" 
            % must be accessible from this fuction, or the corresponding
            % variable in the list will remain empty.
            if exist(Config.Visualization.vizVariableList{k},'var')
                 
                Config.Visualization.updatedVizVariableList{cont} = Config.Visualization.vizVariableList{k};
                Config.Visualization.dataForVisualization.(Config.Visualization.vizVariableList{k}) = eval(Config.Visualization.vizVariableList{k});
                cont = cont +1;
            end
        end    
        % update the MAT file with new data
        [~] = saveSimulationData(Config.Visualization,Config.Simulator,'update');    
    end
end
