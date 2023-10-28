% INIT_MODEL initializes and loads the reduced robot model.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Model Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% specify the list of joints that are going to be considered in the reduced model
Config.Model.jointList    = '';
        
% select the link that will be used as base link
Config.Model.baseLinkName = 'root_link';

% name of the urdf file.
Config.Model.modelName    = 'model.urdf';

% TRUE if the iDyntree simulator is NOT available for this model
Config.Model.deactivateVisualizer = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the initial pose, velocity, ext. force and gravity vector
Config.Model.gravityAcc = [0;0;-9.81];
Config.Model.extForce   = [0;5;0;0;0;0];
Config.Model.w_H_b      = [eye(3), [0;0;0.7];
                          [0,  0,  0,  1]];
Config.Model.baseVel    = [0; 0; 2; 0; 0; 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Load Reduced Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the reduced model
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Simulator.pathToModel, ...
                                                Config.Model.modelName,Config.Simulator.wrappersDebugMode); 
                                            
% set initial conditions
iDynTreeWrappers.setRobotState(KinDynModel,Config.Model.w_H_b,'',Config.Model.baseVel ,'',Config.Model.gravityAcc)

disp('[init_model]: model loaded correctly.')
