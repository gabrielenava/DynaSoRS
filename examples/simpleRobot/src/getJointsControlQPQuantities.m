function [Hessian, gradient, lowerBound, upperBound] = getJointsControlQPQuantities(KinDynModel, jointPos, ...
        jointVel, jointPosRef, Config)

    % ----------------------------------------------------------------------- %
    % QP tasks:
    %
    % 1) desired joints dynamics:
    %
    %    jointAccStar = g -KD*jointVel -KP*(jointPos - jointPosRef)
    %
    % 2) joint torques regularization:
    %
    %    jointTorques = 0
    % ----------------------------------------------------------------------- %
    %
    g = iDynTreeWrappers.generalizedGravityForces(KinDynModel);

    % reference joints dynamics
    jointAccStar = g(7:end) -Config.gains.KD*jointVel -Config.gains.KP*(jointPos - jointPosRef);

    %% QP TASKS

    % ----------------------------------------------------------------------- %
    % Tasks to be added to the QP cost function

    % JOINTS DYNAMICS TASK
    H_joints =  eye(Config.ndof);
    g_joints = -jointAccStar;

    % add weights
    H_joints = Config.weightsQP.joints * H_joints;
    g_joints = Config.weightsQP.joints * g_joints;

    % TORQUES REGULARIZATION TASK
    H_torques = eye(Config.ndof);
    g_torques = zeros(Config.ndof, 1);

    % add weights
    H_torques = Config.weightsQP.torques * H_torques;
    g_torques = Config.weightsQP.torques * g_torques;

    % ----------------------------------------------------------------------- %
    % Build the QP cost function (Hessian matrix and gradient)
    Hessian  = H_joints + H_torques;

    % regularization of the Hessian. Enforce symmetry and positive definiteness
    Hessian  = 0.5 * (Hessian + transpose(Hessian)) + eye(size(Hessian,1)) * Config.tasksQP.reg_HessianQP;

    % compute the gradient
    gradient = g_joints + g_torques;

    %% QP BOUNDARIES

    % ----------------------------------------------------------------------- %
    % QP input boundaries. They are of the form:
    %
    % lb <= u <= ub
    %
    upperBound = Config.inequalitiesQP.maxJointTorque;
    lowerBound = Config.inequalitiesQP.minJointTorque;
end
