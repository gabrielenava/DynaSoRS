% INIT_CONTROL control-related settings and parameters.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Dec. 2022
%

%% Controller gains

% linear momentum
KP_linMom = diag([15; 15; 15]);
KD_linMom = 2*sqrt(KP_linMom);

% angular momentum
KP_angmom = 2*diag([1;1;1]);
KD_angmom = 1*diag([1;1;1]);

% combine momenutm gains
Config.gains.KP_momentum = blkdiag(KP_linMom, KP_angmom);
Config.gains.KD_momentum = blkdiag(KD_linMom, KD_angmom);

%% Weights QP tasks

% cost function
Config.weightsQP.linMom_xy = 0.0001;
Config.weightsQP.linMom_z  = 10;
Config.weightsQP.angMom_rp = 10;
Config.weightsQP.angMom_y  = 0.1;

% Hessian matrix regularization
Config.tasksQP.reg_HessianQP = 1e-4;

% QP bounds
Config.inequalitiesQP.maxJetsInt  = [160; 160; 220; 220];
Config.inequalitiesQP.idleJetsInt = [0; 0; 0; 0];

%% Initialize QP problem with OSQP

% initialize problem
njets   = Config.turbinesData.njets;
var.H   = eye(njets);
var.g   = zeros(njets,1);
var.A   = eye(njets);
var.lb  = Config.inequalitiesQP.idleJetsInt;
var.ub  = Config.inequalitiesQP.maxJetsInt;

% create the solver object
Config.opti = dynasors.OptiQP('osqp');
Config.opti.setup(var);
