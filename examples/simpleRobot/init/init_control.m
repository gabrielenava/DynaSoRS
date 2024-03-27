% INIT_CONTROL control-related settings and parameters.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Mar. 2024
%

%% Controller gains

% joint space gains
Config.gains.KP = diag([15; 15]);
Config.gains.KD = 2*sqrt(Config.gains.KP);

%% Weights QP tasks

% cost function
Config.weightsQP.joints  = 1;
Config.weightsQP.torques = 0.01;

% Hessian matrix regularization
Config.tasksQP.reg_HessianQP = 1e-4;

% QP bounds
Config.inequalitiesQP.maxJointTorque = [20; 20];
Config.inequalitiesQP.minJointTorque = [-20; -20];

%% Initialize QP problem with OSQP

% initialize problem
ndof   = Config.ndof;
var.H  = eye(ndof);
var.g  = zeros(ndof,1);
var.A  = eye(ndof);
var.lb = Config.inequalitiesQP.minJointTorque;
var.ub = Config.inequalitiesQP.maxJointTorque;

% create the solver object
Config.opti = dynasors.OptiQP('osqp');
Config.opti.setup(var);
