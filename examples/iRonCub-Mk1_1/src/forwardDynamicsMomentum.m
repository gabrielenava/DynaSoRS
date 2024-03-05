function xDot = forwardDynamicsMomentum(t, x, ~, KinDynModel, Config)

    % FORWARDDYNAMICSMOMENTUM computes the forward dynamics of a floating
    %                         base multi-body system as follows:
    %
    % System state:    [L, jointPos, basePose];
    % Time derivative: [LDot, jointVel, baseVel];
    %
    % Momentum dynamics:
    %
    %   LDot = A*T + mge3
    %
    % with T = u_1 jet thrusts intensities (one of the control inputs).
    %
    % Joint space: joints velocities are assumed to be the other control
    % input of the system, and can be achieved instantaneously:
    %
    %   jointVel = u_2;
    %
    % Base linear and angular velocity: linked to joints velocities via the
    % robot centroidal momentum
    %
    %   baseVel = CMM_b\(L - CMM_s*u_2)
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Jan 2022

    %% ------------Initialization----------------

    % update the waitbar
    if ~isempty(Config.waitbar)
        waitbar(t/Config.integr_opt.t_end, Config.waitbar);
    end

    % demux the system state
    [L, jointPos, basePosQuat] = wbc.vectorDemux(x, [6, Config.ndof, 7]);
    w_H_b = wbc.fromPosQuatToTransfMatr(basePosQuat);

    % update the current system state
    iDynTreeWrappers.setRobotState(KinDynModel, w_H_b, jointPos, zeros(6,1), zeros(Config.ndof,1), Config.gravityAcc);

    % demux the control input
    u               = flightController(t, x, KinDynModel, Config);
    jetsIntensities = u(1:Config.turbinesData.njets);
    jointVel        = u(Config.turbinesData.njets+1:end);

    % compute the centroidal momentum matrix and CoM position
    M      = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    CMM    = Config.kinDynJetsWrapper.getCentroidalTotalMomentumJacobian(KinDynModel);
    CMM_b  = CMM(:,1:6);
    CMM_s  = CMM(:,7:end);
    posCoM = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);
    A_jets = Config.kinDynJetsWrapper.getJetsMappingMomentum(KinDynModel, posCoM, Config);

    % ------------------------------------------------------------------- %

    % compute the state derivatives
    LDot      = A_jets*jetsIntensities + [M(1,1)*Config.gravityAcc; zeros(3,1)];
    baseVel   = CMM_b\(L - CMM_s*jointVel);
    baseOmega = baseVel(4:6);
    qtDot     = wbc.quaternionDerivative(basePosQuat(4:end), baseOmega, 1);
    xDot      = [LDot; jointVel; baseVel(1:3); qtDot];

    % ------------------------------------------------------------------- %

    % log data from the forward dynamics simulation
    Config.logger.logData(t, 'time');
    Config.logger.logData(LDot, 'LDot');
    Config.logger.logData(posCoM, 'posCoM');
    Config.logger.logData(jetsIntensities, 'T');
end
