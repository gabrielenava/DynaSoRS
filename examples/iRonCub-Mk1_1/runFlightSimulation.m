% Example of usage of DynaSoRS library with iRonCub-Mk1_1. The robot model
% is available by installing the repo `ironcub-mk1-software`:
%
%  https://github.com/ami-iit/ironcub-mk1-software
%
% Integration of system dynamics is done via MATLAB ode integrators.
% Additionally, the control formulation is a QP solved with OSQP.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Dec. 2022
%
clear variables
close all
clc

% add path to local functions
addpath(genpath('./src'))
addpath('../../')

% run scripts for initializing robot, simulator and control params.
run('./init/init_robot.m');
run('./init/init_simulator.m');
run('./init/init_control.m');

%-------------------------------------------------------------------------%

% set initial conditions
poseQuat_init  = wbc.fromTransfMatrixToPosQuat(Config.initCond.w_H_b_init);
init_state     = [zeros(6,1); Config.initCond.jointPos_init; poseQuat_init];
u_init         = flightController(Config.integr_opt.t_init, init_state, KinDynModel, Config);

% numerical integration
Config.waitbar = waitbar(0,'Integration in progress...');
int            = dynasors.Integrator(init_state, [], Config.integr_opt, Config.solver_opt);

% set initial control input and fwdyn function
control_fcn    = @(t, x) flightController(t, x, KinDynModel, Config);
int.input_ctrl = u_init;
int.integr_fcn = @(t,x) forwardDynamicsMomentum(t, x, int.input_ctrl, KinDynModel, Config);

tic;
[time, state] = int.solve();
t_solver      = toc;

disp('Integration done.')
disp(['Integration time: ', num2str(t_solver), ' [s]'])

if ~isempty(Config.waitbar)
    close(Config.waitbar);
end

disp('Press any key...')
pause();

%-------------------------------------------------------------------------%
% demux and interpolate the state
[w_H_b, jointPos] = demuxState(state, Config.ndof);
[w_H_b_dec, jointPos_dec, time_dec] = dynasors.interpolateData(w_H_b, jointPos, time, Config.interpolation.tStep);

% setup visualizer
disp('Visualizing the robot...')
viz = dynasors.Visualizer(w_H_b_dec, jointPos_dec, time_dec, KinDynModel, Config.viz_opt);

% run visualizer
tic;
viz.run();
t_viz = toc;

disp('Visualization completed.')
disp(['Visualizer real-time factor: ', num2str(time(end)/t_viz)])

%-------------------------------------------------------------------------%
% plot data collected with the logger
Config.plot_options_LDot.xValue   = Config.logger.data.time;
Config.plot_options_posCoM.xValue = Config.plot_options_LDot.xValue;
Config.plot_options_T.xValue      = Config.plot_options_LDot.xValue;
Config.logger.plotData('LDot', Config.plot_options_LDot);
Config.logger.plotData('posCoM', Config.plot_options_posCoM);
Config.logger.plotData('T', Config.plot_options_T);

%-------------------------------------------------------------------------%
% remove local paths
rmpath(genpath('../../src'))
rmpath(genpath('./src'))
