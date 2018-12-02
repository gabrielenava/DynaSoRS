% INITGRAVITYCOMPENSATION initializes the gravity compensation simulation.
%
%                         REQUIRED:
%
%                         - Config: [struct] with fields:
%
%                                   - initGravComp: [struct]; (created here)
%                                   - integration: [struct]; (partially created here)
%                                   - Visualization: [struct]; (partially created here)
%                                   - iDyntreeVisualizer: [struct]; (created here)
%
%                         For more information on the required fields inside
%                         each structure, refer to the documentation inside
%                         the "core" functions.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Gravity compensation demo setup %%%%%%%%%%%%%%%%%%%%%%

% set the initial robot position and velocity [deg] and gravity vector
torso_Position     = [0  0  0];                 
left_arm_Position  = [10 45 0  15 0];           
right_arm_Position = [10 45 0  15 0];                
left_leg_Position  = [0  0  0  0  0  0];
right_leg_Position = [0  0  0  0  0  0]; 

Config.initGravComp.jointPos_init = [torso_Position';left_arm_Position';right_arm_Position';left_leg_Position';right_leg_Position']*pi/180;
Config.initGravComp.jointVel_init = zeros(length(Config.initGravComp.jointPos_init),1);
Config.initGravComp.gravityAcc    = [0;0;-9.81];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Numerical integration setup %%%%%%%%%%%%%%%%%%%%%%%%

% set the integration time step, total time, and the integration options
Config.integration.tStart      = 0;
Config.integration.tEnd        = 10;
Config.integration.tStep       = 0.01; 
Config.integration.showStats   = 'off';
Config.integration.options     = odeset('RelTol',1e-3,'AbsTol',1e-3,'Stats',Config.integration.showStats);
Config.integration.showWaitbar = true;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Visualization and data plotting setup %%%%%%%%%%%%%%%%%%%

% this list contains the NAMES of all the variables that it will be
% possible to plot when the simulation is over
Config.Visualization.vizVariableList = {'t','jointPos','jointVel','M','tau'};

% if TRUE, a GUI will appear asking the user to specify which variable 
% to use as x-axis in the plots between the ones inside the "vizVariableList".
% If FALSE, the "defaultXAxisVariableName" will be used instead. The
% selected x-axis must respect these conditions:
%
% - the variable exists;
% - the variable "defaultXAxisVariableName" is also inside the "vizVariableList";
% - the variable is a vector of the same length of the y-axis;
%
% if one of the above conditions is not true, the specified x-axis is ignored.
Config.Visualization.activateAxisOption = true;
Config.Visualization.defaultXAxisVariableName  = 't';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% iDyntree visualizer setup %%%%%%%%%%%%%%%%%%%%%%%%%

% set the view options for the visualizer (model simulator with iDyntree)
Config.iDyntreeVisualizer.debug                    = false;
Config.iDyntreeVisualizer.cameraPos                = [1,0,0.5];    
Config.iDyntreeVisualizer.cameraTarget             = [0.4,0,0.5];
Config.iDyntreeVisualizer.lightDir                 = [-0.5 0 -0.5]/sqrt(2);
Config.iDyntreeVisualizer.disableViewInertialFrame = true;
Config.iDyntreeVisualizer.w_R_b_fixed              = [-1  0  0;
                                                       0 -1  0;
                                                       0  0  1];
Config.iDyntreeVisualizer.w_H_b_fixed              = [Config.iDyntreeVisualizer.w_R_b_fixed , [0;0;0.7];
                                                              0        0        0                 1   ];