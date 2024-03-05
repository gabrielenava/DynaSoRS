close all
clc
clear

addpath('../')
disp('Testing OptiQP class ...')

%% Call to OSQP

% problem structure:
%
% x = argmin (1/2*x'*H*x + x'*g)
%
% s.t.
% lb <= A*x <= ub

% define problem data
var.H  = sparse([4, 1; 1, 2]);
var.g  = [1; 1];
var.A  = sparse([1, 1; 1, 0; 0, 1]);
var.lb = [1; 0; 0];
var.ub = [1; 0.7; 0.7];

% create the solver object
opti = dynasors.OptiQP('osqp');

% setup problem
opti.setup(var);

% change values and update problem
var.H  = sparse([5, 1.5; 1.5, 1]);
var.g  = [2; 3];
var.A  = sparse([1.2, 1.1; 1.5, 0; 0, 0.8]);
var.lb = [2; -1; -1];
var.ub = [2; 2.5; 2.5];

opti.update(var);

% solve problem
u_star = opti.solve();

disp('u_star test 1 (OSQP):')
disp(num2str(u_star))

%% Call to QUADPROG

% setup QP problem
var.H    = sparse([5, 1.5; 1.5, 1]);
var.g    = [2; 3];
var.A    = sparse([1.2, 1.1; 1.5, 0; 0, 0.8]);
var.b    = [2; 2.5; 2.5];
var.Aeq  = [];
var.beq  = [];
var.lb   = [-10; -5];
var.ub   = [10; 5];
var.x0   = [];
var.opts = optimoptions('quadprog','Display','off');

opti2 = dynasors.OptiQP('quadprog');
opti2.setup(var);

% update variables
var.g = [1; 4];

opti2.update(var);

u_star = opti2.solve();

disp('u_star test 2 (QUADPROG):')
disp(num2str(u_star))

disp('Done!')
rmpath('../')
