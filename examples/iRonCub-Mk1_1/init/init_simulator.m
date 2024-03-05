% INIT_SIMULATOR defines simulation options.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Dec. 2022
%

% integrator class options
Config.integr_opt.t_init      = 0;
Config.integr_opt.t_step      = 0.01;
Config.integr_opt.t_end       = 10;
Config.integr_opt.max_n_iter  = 1000000;
Config.integr_opt.solver_type = 'ode15s'; % 'ode23t'; % 'ode45'; % 'euler';
Config.solver_opt             = odeset('RelTol',1e-4,'AbsTol',1e-4,'Stats','off');

% visualizer class options
Config.viz_opt.color              = [0.9,0.9,0.9];
Config.viz_opt.material           = 'metal';
Config.viz_opt.meshesPath         = Config.meshesPath;
Config.viz_opt.transparency       = 0.7;
Config.viz_opt.debug              = false;
Config.viz_opt.view               = [-92.9356 22.4635];
Config.viz_opt.groundOn           = true;
Config.viz_opt.groundColor        = [0.5 0.5 0.5];
Config.viz_opt.groundTransparency = 0.5;
Config.interpolation.tStep        = 1/30; % data decimation for visualizer

% initialize the KinDynWrapper and Logger class to compute complex dynamics
% and kinematics quantities using iDynTree, and log data
Config.kinDynJetsWrapper          = KinDynJetsWrapper();
Config.logger                     = dynasors.Logger();

% plot options for LDot
Config.plot_options_LDot.yLabel   = 'LDot';
Config.plot_options_LDot.xLabel   = 'time [s]';
Config.plot_options_LDot.title    = 'Momentum Derivative';
Config.plot_options_LDot.lineSize =  3;
Config.plot_options_LDot.fontSize =  12;
Config.plot_options_LDot.legend   = {'l_x','l_y','l_z','w_x','w_y','w_z'};

% plot options for posCoM
Config.plot_options_posCoM        = Config.plot_options_LDot;
Config.plot_options_posCoM.yLabel = 'posCoM [m]';
Config.plot_options_posCoM.title  = 'Center of Mass Position';
Config.plot_options_posCoM.legend = {'x','y','z'};

% plot options for T
Config.plot_options_T             = Config.plot_options_LDot;
Config.plot_options_T.yLabel      = 'Thrust [N]';
Config.plot_options_T.title       = 'Commanded Thrusts';
Config.plot_options_T.legend      = {'T_1','T_2','T_3','T_4'};
