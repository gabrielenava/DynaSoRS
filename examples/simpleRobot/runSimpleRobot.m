% Example of usage of DynaSoRS library with simpleRobot.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Mar. 2024
%
clear variables
close all
clc

% add path to local functions
addpath(genpath('./src'))

% run scripts for initializing robot, simulator and control params.
run('./init/init_robot.m');
run('./init/init_simulator.m');
run('./init/init_control.m');

%-------------------------------------------------------------------------%

% set initial conditions
init_state     = [Config.initCond.jointPos_init; Config.initCond.jointVel_init];
u_init         = jointsController(Config.integr_opt.t_init, init_state, KinDynModel, Config);

% numerical integration
Config.waitbar = waitbar(0,'Integration in progress...');
int            = dynasors.Integrator(init_state, [], Config.integr_opt, Config.solver_opt);

% set initial control input and fwdyn function
control_fcn    = @(t, x) jointsController(t, x, KinDynModel, Config);
int.input_ctrl = u_init;
int.integr_fcn = @(t,x) forwardDynamicsFixedBase(t, x, int.input_ctrl, KinDynModel, Config);

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
jointPos = state(:,1:2)';
[jointPos_dec, time_dec] = dynasors.interpolateData(jointPos, time, Config.interpolation.tStep);

% setup visualizer
disp('Visualizing the robot...')
viz = dynasors.Visualizer(eye(4), jointPos_dec, time_dec, KinDynModel, Config.viz_opt);

% run visualizer
tic;
viz.run();
t_viz = toc;

disp('Visualization completed.')
disp(['Visualizer real-time factor: ', num2str(time(end)/t_viz)])

%-------------------------------------------------------------------------%
% plot data collected with the logger
Config.plot_options_jointTorques.xValue   = Config.logger.data.time;
Config.logger.plotData('jointTorques', Config.plot_options_jointTorques);

%-------------------------------------------------------------------------%
% remove local paths
rmpath(genpath('../../src'))
rmpath(genpath('./src'))
