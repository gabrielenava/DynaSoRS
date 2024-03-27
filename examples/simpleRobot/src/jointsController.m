function u = jointsController(~, x, KinDynModel, Config)

    % ------------------------------------------------------------------- %
    % jointsController
    %
    % simpified control design to test the MATLAB simulator.
    %
    % jointsTorques = gravityTorques + PD control
    %
    % the controller is implemented using a QP solver.
    % ------------------------------------------------------------------- %

    % demux state
    [jointPos, jointVel] = wbc.vectorDemux(x, [Config.ndof, Config.ndof]);
    jointPosRef = Config.initCond.jointPos_init;

    % get QP cost and bounds
    [Hessian, gradient, lowerBound, upperBound] = getJointsControlQPQuantities(KinDynModel, jointPos, ...
        jointVel, jointPosRef, Config);

    % solve the QP problem
    %
    % u_opt = argmin(1/2*u'*H*u + u'*g)
    %
    %   s.t. u_min <= u <= u_max

    % update problem
    var.H   = Hessian;
    var.g   = gradient;
    var.A   = eye(Config.ndof);
    var.lb  = lowerBound;
    var.ub  = upperBound;

    Config.opti.update(var);

    % solve problem
    u = Config.opti.solve();
end
