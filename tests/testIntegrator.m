close all
clc
clear

addpath('../')
disp('Testing Integrator class ...')

init_state = [1; -1];
integr_fcn = @(t,x) [-2*x(1) - 10*x(2); x(1)];
integr_opt = struct;

integr_opt.t_init = 0;
integr_opt.t_step = 0.01;
integr_opt.t_end  = 5;

%% Test 1: test forward euler integration
integr_opt.solver_type = 'euler';

int_1 = dynasors.Integrator(init_state, integr_fcn, integr_opt);

tic;
[time, state] = int_1.solve();
t1 = toc;

figure(1)
subplot(2,1,1)
plot(time, state(:,1), 'b', 'linewidth', 5)
hold on
grid on
subplot(2,1,2)
plot(time, state(:,2), 'b', 'linewidth', 5)
hold on
grid on

%% Test 2: test integration with ode15s
integr_opt.solver_type = 'ode15s';
solver_opt             = odeset('RelTol',1e-4,'AbsTol',1e-4,'Stats','off');

int_2 = dynasors.Integrator(init_state, integr_fcn, integr_opt, solver_opt);

tic;
[time, state] = int_2.solve();
t2 = toc;

subplot(2,1,1)
plot(time, state(:,1), '-r', 'linewidth', 4)

subplot(2,1,2)
plot(time, state(:,2), '-r', 'linewidth', 4)

%% Test 3: test integration with ode23t
integr_opt.solver_type = 'ode23t';

int_3 = dynasors.Integrator(init_state, integr_fcn, integr_opt);

tic;
[time, state] = int_3.solve();
t3 = toc;

subplot(2,1,1)
plot(time, state(:,1), '.k', 'markersize', 12)

subplot(2,1,2)
plot(time, state(:,2), '.k', 'markersize', 12)

%% Test 4: step-by-step integration with ode45 (no control)
integr_opt.solver_type = 'ode45';
integr_opt.max_n_iter  = 100000;

int_4 = dynasors.Integrator(init_state, integr_fcn, integr_opt, solver_opt);

tic;
[time, state] = int_4.solveStepByStep();
t4 = toc;

subplot(2,1,1)
plot(time, state(:,1), '-.m', 'linewidth', 2)

subplot(2,1,2)
plot(time, state(:,2), '-.m', 'linewidth', 2)

%% Test 5: step-by-step integration with ode15s (with control)
integr_opt.solver_type = 'ode15s';

int_5 = dynasors.Integrator(init_state, [], integr_opt, solver_opt);

% update integration fcn to include input control, and create control fcn
int_5.integr_fcn = @(t,x) [-2*x(1) - 10*x(2); x(1) + int_5.input_ctrl];
ctrlFcn          = @(t,x) x(1) + x(2);

tic;
[time, state] = int_5.solveStepByStep(ctrlFcn);
t5 = toc;

subplot(2,1,1)
plot(time, state(:,1), '--g', 'linewidth', 2)
title('Velocity')
xlabel('Time [s]')
ylabel('x_1(t)')
legend({'euler','ode15s','ode23t','ode45 step (no ctrl)','ode15s step (w ctrl)'},'location','best')

subplot(2,1,2)
plot(time, state(:,2), '--g', 'linewidth', 2)
title('Position')
xlabel('Time [s]')
ylabel('x_2(t)')
legend({'euler','ode15s','ode23t','ode45 step (no ctrl)','ode15s step (w ctrl)'},'location','best')

% time comparision
disp('Integration time: [t1 t2 t3 t4 t5] (seconds)')
disp(num2str([t1 t2 t3 t4 t5]))
disp('Done!')
rmpath('../')
