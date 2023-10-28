% INIT_SIMULATION initializes the user-defined simulation.
%
%     REQUIRED VARIABLES:
%
%         - Config: [struct] with fields:
%
%             - Simulator: [struct];
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018; Modified Sept. 2020
    
%% ------------Initialization----------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Numerical integration setup %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the integration time step, total time, and the integration options
Config.integration.tStart      = 0;
Config.integration.tEnd        = 1;
Config.integration.tStep       = 0.01; 
Config.integration.showStats   = 'on';
Config.integration.options     = odeset('RelTol',1e-3,'AbsTol',1e-3,'Stats',Config.integration.showStats);
Config.integration.showWaitbar = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% iDyntree visualizer setup %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the view options for the iDynTree visualizer
Config.iDyntreeVisualizer.meshesPath         =  Config.Simulator.pathToModel;
Config.iDyntreeVisualizer.color              =  [0.9,0.9,0.9];
Config.iDyntreeVisualizer.material           = 'metal';
Config.iDyntreeVisualizer.transparency       =  1;
Config.iDyntreeVisualizer.debug              =  false; 
Config.iDyntreeVisualizer.view               =  [-92.9356   22.4635];
Config.iDyntreeVisualizer.groundOn           =  false; 
Config.iDyntreeVisualizer.groundColor        =  [0.5 0.5 0.5];
Config.iDyntreeVisualizer.groundTransparency =  0.5;
Config.iDyntreeVisualizer.groundFrame        = 'l_sole';

% frame rate for video recording (fps), video format, data processing method
% and figure bounds (w.r.t. the base link position)
Config.iDyntreeVisualizer.frameRate          = 30;
Config.iDyntreeVisualizer.videoFormat        = 'gif';
Config.iDyntreeVisualizer.dataProcMethod     = 'interpolate';
Config.iDyntreeVisualizer.xtol               = 0.1;
Config.iDyntreeVisualizer.ytol               = 0.1;
Config.iDyntreeVisualizer.ztol               = 0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Visualization setup (plots) %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this list contains the NAMES of all the variables that it will be
% possible to plot when the simulation is over
Config.Visualization.vizVariableList = {'t', 'L', 'L_check', 'LDot', 'LDot_check', 'L_error', 'LDot_error'};

% if "activateXAxisMenu" is TRUE, a GUI will appear asking the user to 
% specify which variable to use as x-axis in the plots between the ones 
% inside the "vizVariableList". If FALSE, the "defaultXAxisVariableName" 
% will be used instead. The selected x-axis must respect these conditions:
%
% - the variable exists;
% - the variable "defaultXAxisVariableName" is also inside the "vizVariableList";
% - the variable is a vector of the same length of the y-axis;
%
% if one of the above conditions is not true, the specified x-axis is ignored.
Config.Visualization.activateXAxisMenu        = true;
Config.Visualization.defaultXAxisVariableName = 't';

% this variable is updated later on
nFigures = 1;

% general settings
Settings = struct;
Settings.lineWidth         = 4;
Settings.fontSize_axis     = 25;
Settings.fontSize_leg      = 25;
Settings.removeLegendBox   = true;
Settings.legendOrientation = 'horizontal';
Settings.xLabel            = {'Time [s]'};
    
% time
Config.Visualization.figureSettingsList{nFigures}.Mode = 'singlePlot';
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'Time [s]'};
Config.Visualization.figureSettingsList{nFigures}.Settings.figTitle = {'Integration time'};
    
% momentum
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'L'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';
                                                     
% momentum_check
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'L check'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';

% momentumDot
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'LDot'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';

% momentumDot_check
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'LDot check'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';

% momentum_error
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'L error'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';

% momentumDot_error
nFigures = nFigures + 1;
Config.Visualization.figureSettingsList{nFigures}.Mode = 'multiplePlot';
Config.Visualization.figureSettingsList{nFigures}.numOfFigures = 1;
Config.Visualization.figureSettingsList{nFigures}.numOfSubFigures = 6;
Config.Visualization.figureSettingsList{nFigures}.totalSubFiguresSinglePlot = [3,2];
Config.Visualization.figureSettingsList{nFigures}.Settings = Settings;
Config.Visualization.figureSettingsList{nFigures}.Settings.yLabel = {'LDot error'};
Config.Visualization.figureSettingsList{nFigures}.modeMultiplePlot = 'newplot';  
Config.Visualization.figureSettingsList{nFigures}.legendList = '';
