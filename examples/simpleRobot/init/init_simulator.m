% INIT_SIMULATOR defines simulation options.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Mar. 2024
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
Config.viz_opt.meshesPath         = '';
Config.viz_opt.transparency       = 0.7;
Config.viz_opt.debug              = false;
Config.viz_opt.view               = [-92.9356 22.4635];
Config.viz_opt.groundOn           = true;
Config.viz_opt.groundColor        = [0.5 0.5 0.5];
Config.viz_opt.groundTransparency = 0.5;
Config.interpolation.tStep        = 1/30; % data decimation for visualizer

% initialize the Logger class
Config.logger                     = dynasors.Logger();

% plot options for jointTorques
Config.plot_options_jointTorques.yLabel   = 'jointTorques';
Config.plot_options_jointTorques.xLabel   = 'time [s]';
Config.plot_options_jointTorques.title    = 'Joint Torques';
Config.plot_options_jointTorques.lineSize =  3;
Config.plot_options_jointTorques.fontSize =  12;
Config.plot_options_jointTorques.legend   = {'t_1','t_2'};
