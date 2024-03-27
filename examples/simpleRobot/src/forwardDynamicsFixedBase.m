function xDot = forwardDynamicsFixedBase(t, x, ~, KinDynModel, Config)

    % FORWARDDYNAMICS computes the forward dynamics of a fixed-based robot.
    %
    % System state:    [jointPos, jointVel];
    % Time derivative: [jointVel, jointAcc];
    %
    % Robot dynamics:
    %
    %   M*jointAcc + h(jointPos, jointVel) = tau
    %
    % with tau = joint torques (control input).
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Mar. 2024

    %% ------------Initialization----------------

    % update the waitbar
    if ~isempty(Config.waitbar)
        waitbar(t/Config.integr_opt.t_end, Config.waitbar);
    end

    % demux the system state
    [jointPos, jointVel] = wbc.vectorDemux(x, [Config.ndof, Config.ndof]);

    % update the current system state
    iDynTreeWrappers.setRobotState(KinDynModel, jointPos, jointVel, Config.gravityAcc);

    % demux the control input
    jointTorques = jointsController(t, x, KinDynModel, Config);

    % compute the joints acceleration and state derivatives
    M        = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    h        = iDynTreeWrappers.generalizedBiasForces(KinDynModel);
    jointAcc = M(7:end, 7:end)\(jointTorques - h(7:end));
    xDot     = [jointVel; jointAcc];

    % ------------------------------------------------------------------- %

    % log data from the forward dynamics simulation
    Config.logger.logData(t, 'time');
    Config.logger.logData(jointTorques, 'jointTorques');
end
