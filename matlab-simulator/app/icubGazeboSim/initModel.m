% INITMODEL initializes the reduced model. NOTE: the reduced model is NOT 
%           jet loaded. This file just contains the model configuration.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% specify which joints are going to be considered in the reduced model
Config.initModel.jointList         = {'torso_pitch', 'torso_roll','torso_yaw',...
                                      'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow','l_wrist_prosup', ...
                                      'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow','r_wrist_prosup', ...
                                      'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll', ...
                                      'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch', 'r_ankle_roll'};
        
% select the link that will be used as floating base
Config.initModel.baseLinkName      = 'root_link';

% model name and path
Config.initModel.modelPath         = './app/icubGazeboSim/';
Config.initModel.modelName         = 'model.urdf';

% activate/deactivate debug mode
Config.initModel.debugMode         = true;

% either use the GUI or not. Default: true
Config.initModel.useStaticGui      = true;

% list of available simulations. The name specified in the simulation list
% is the name of the script that runs the corresponding demo
Config.initModel.simulationList    = {'runGravityCompensation','runWrappersTest'};

% for each element of Config.simulationList there should be a corresponding
% folder inside the 'simulations' folder where all the functions and
% scripts relative to the demo are stored
Config.initModel.demoFolderList    = {'gravity-compensation','test-idyntree-wrappers'};

% default simulation and demo folder that will be run when useStaticGui is 
% set to false
Config.initModel.defaultSimulation = 'runGravityCompensation';
Config.initModel.defaultDemoFolder = 'gravity-compensation';

% show a simulation of the system movements
Config.initModel.showVisualizer    = true;
