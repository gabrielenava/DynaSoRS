function u = flightController(~, x, KinDynModel, Config)

    % ------------------------------------------------------------------- %
    % flightController
    %
    % simpified flight control design to test the MATLAB simulator.
    %
    % jointVel = 0; (robot behaves like a rigid body)
    %
    % u := jetsIntensities;
    %
    % u* = argmin_u 0.5*(|linMomDot-linMomDot*|^2 + |angMomDot-angMomDot*|^2)
    %  s.t.
    %    u_min <= u <= u_max
    % ------------------------------------------------------------------- %

    % reference trajectories and gains
    pos_vel_acc_jerk_com_des  = [Config.initCond.posCoM_init, zeros(3,3)];
    rot_vel_acc_jerk_base_des = [Config.initCond.w_H_b_init(1:3,1:3), zeros(3,3)];
    KP_momentum               = Config.gains.KP_momentum;
    KD_momentum               = Config.gains.KD_momentum;

    % demux state and compute required dynamics and kinematics quantities
    [L, ~, basePosQuat] = wbc.vectorDemux(x, [6, Config.ndof, 7]);

    w_H_b  = wbc.fromPosQuatToTransfMatr(basePosQuat);
    w_R_b  = w_H_b(1:3,1:3);
    M      = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
    posCoM = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);

    % get QP cost and bounds
    [Hessian, gradient, lowerBound, upperBound] = getFlightControlQPQuantities(KinDynModel, w_R_b, posCoM, M, L, ...
        pos_vel_acc_jerk_com_des, rot_vel_acc_jerk_base_des, KP_momentum, KD_momentum, Config);

    % solve the QP problem
    %
    % u_opt = argmin(1/2*u'*H*u + u'*g)
    %
    %   s.t. u_min <= u <= u_max

    % update problem
    var.H   = Hessian;
    var.g   = gradient;
    var.A   = eye(Config.turbinesData.njets);
    var.lb  = lowerBound;
    var.ub  = upperBound;

    Config.opti.update(var);

    % solve problem
    jetsIntensities_star = Config.opti.solve();
    jointVel_star        = zeros(Config.ndof,1);

    % final control input
    u = [jetsIntensities_star; jointVel_star];
end
