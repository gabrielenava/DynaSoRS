close all
clc
clear

addpath('../')
disp('Testing OptiNonLin class ...')

%% Call to fmincon

% problem: find the minimum of Rosenbrock's function on the unit disk
%
% see also fmincon documentation

% create problem variables
var.cost    = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
var.A       = [];
var.b       = [];
var.Aeq     = [];
var.beq     = [];
var.lb      = [];
var.ub      = [];
var.nonlcon = @unitdisk;
var.u_init  = [0, 0];
var.options = optimoptions('fmincon','Algorithm','sqp');

% setup the problem
opti = dynasors.OptiNonLin();
opti.update(var);

% solve the problem
u_star = opti.solve();

disp('u_star:')
disp(num2str(u_star))

disp('Done!')
rmpath('../')

%% functions definition

% unit disk constraint
function [c,ceq] = unitdisk(x)
    c   = x(1)^2 + x(2)^2 - 1;
    ceq = [];
end
