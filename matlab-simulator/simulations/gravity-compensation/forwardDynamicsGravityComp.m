function chiDot = forwardDynamicsGravityComp(t,chi,KinDynModel,Config)

    % FORWARDDYNAMICSGRAVITYCOMP computes the forward dynamics of a fixed
    %                            base system with no contacts with the
    %                            environment (but the base link, which is 
    %                            fixed on ground). Joints torques are the
    %                            ones that compensate for gravity.
    %
    % FORMAT: chiDot = forwardDynamicsGravityComp(t,chi,KinDynModel,Config);
    %
    % INPUTS:  - t: current integration time step;
    %          - chi: [2*ndof x 1] current robot state. Expected format:
    %                 chi = [jointVel; jointPos];
    %          - KinDynModel: a structure containing the loaded model and additional info;
    %          - Config: simulation-specific configuration parameters;
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
    [jointVel,jointPos] = stateDemux(chi,KinDynModel.NDOF,'fixed');
    
    % update the current system state
    idyn_setRobotState(KinDynModel,jointPos,jointVel,Config.gravityAcc);
    
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
end