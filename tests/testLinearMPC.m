close all
clear
clc

addpath('./../src/core/')
disp('Testing LinearMPC class ...')

% Setup the problem
%
% consider a discrete-time double integrator model of the form:
%
%  x_1(k)  = x_1(0) + \sum_{j=1}^{k-1} x_2(j)
%  x_2(k)  = x_2(0) + \sum_{j=1}^{k-1} u(j)
%
% rewrite the problem in its state-space form:
%
%  y(k)    = [x_1(k); x_2(k)]
%  y(k+1)  = A*y + B*u = [1 1; 0 1]*y + [0; 1]*u
%
% we setup a constrained linear-quadratic MPC problem to stabilize the
% system about a set point.

% write the model. we choose dim(x) = 2 and dim(u) = 2
t   = 0;
n_x = 2;
n_u = 2;
A   = [eye(n_x) eye(n_x); zeros(n_x) eye(n_x)];
B   = [zeros(n_x, n_u); eye(n_x, n_u)];

% setup the MPC problem
var.N     = 6;
var.Ax    = A;
var.Bu    = B;
var.Q_N   = diag([20; 20; 10; 10]);
var.Q     = diag([2; 2; 1; 1]);
var.R     = 15*eye(n_u);
var.x_r   = [cos(2*pi*t); -cos(2*pi*t); -0.06*sin(2*pi*t); 0.06*sin(2*pi*t)];
var.x_0   = [0.9; -0.9;  0; 0];
var.x_min = [-2*pi; -2*pi; -100*pi/180; -100*pi/180];
var.x_max = [ 2*pi;  2*pi;  100*pi/180;  100*pi/180];
var.u_min = [-5; -5];
var.u_max = [ 5;  5];

opti = LinearMPC();
opti.setup(var);

% simulate the problem in closed loop
n_sim = 250;
y     = zeros(n_sim, 2*n_x);
y_r   = zeros(n_sim, 2*n_x);

for k = 1:n_sim

    % solve the problem
    u_star = opti.solve();

    % apply first control input and update initial conditions
    y(k, :) = var.x_0;
    u       = u_star((var.N+1)*2*n_x+1:(var.N+1)*2*n_x+n_u);
    var.x_0 = A*var.x_0 + B*u;

    % update the reference trajectory
    t         = t + 0.01;
    var.x_r   = [cos(2*pi*t); -cos(2*pi*t); -0.06*sin(2*pi*t); 0.06*sin(2*pi*t)];
    y_r(k, :) = var.x_r;

    opti.update(var);
end

% plot the results
figure(1)

for i = 1:2*n_x

    subplot(2,2,i)
    hold on
    grid on
    plot(0:n_sim-1, y(:,i), 'r', 'linewidth', 2)
    plot(0:n_sim-1, y(:,i), '.k', 'markersize', 12)
    plot(0:n_sim-1, y_r(:,i), '--b', 'linewidth', 2)
    xlabel('iters')
    ylabel(['y(' num2str(i), ')'])
    title(['State ' num2str(i)])
end

rmpath('./../src/core/')
disp('Done!')
