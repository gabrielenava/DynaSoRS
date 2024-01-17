close all
clc
clear

addpath('./../src/core/')
disp('Testing OptiQPCasadi class ...')

%% Create the object, append new variables and parameters
opti = OptiQPCasadi();

opti.addOptiVariable('x',3);
opti.addOptiVariable('y',1);

opti.addParameter('x_max',3);
opti.addParameter('x_min',3);
opti.addParameter('y_max',1);
opti.addParameter('y_min',1);
opti.addParameter('b_eq',1);

%% Setup the optimization problem

% initial conditions
opti.setInitConditions('x',[0;0;0]);
opti.setInitConditions('y',1);

A = magic(3);
b = [1;1;1];
c = [2;1;0];

% set objective function
obj_fcn = @(x,y) 10*sumsqr(A*x + b) + 5*sumsqr(c*y);
opti.setObjectiveFcn(obj_fcn(opti.variables.x, opti.variables.y));

% set boundaries
opti.setBounds('x', opti.parameters.x_min, opti.parameters.x_max);

% set user-defined constraints
B = [11 13 17];
opti.setLinearInequality('y', 1, opti.parameters.y_min, opti.parameters.y_max);
opti.setLinearEquality('x', B, opti.parameters.b_eq);

% update casadi optimizer parameters
opti.updateParameter('x_max', [10;10;10]);
opti.updateParameter('x_min', [-10;-10;-10]);
opti.updateParameter('y_max', 0.1);
opti.updateParameter('y_min',-0.1);
opti.updateParameter('b_eq', 0.01);

% compute the solution
u_star = opti.solve();
x_star = opti.getOptimalValue('x');
y_star = opti.getOptimalValue('y');

disp('u_star:')
disp(num2str(u_star))
disp('Done!')
rmpath('./../src/core/')
