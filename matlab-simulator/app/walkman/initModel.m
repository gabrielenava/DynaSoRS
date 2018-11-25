% INITMODEL initializes the reduced model. NOTE: the reduced model is NOT 
%           jet loaded. This file just contains the model configuration.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% specify which joints are going to be considered in the reduced model
Config.initModel.jointList         = {'WaistSag','WaistLat','WaistYaw',...
                                      'LShSag','LShLat','LShYaw','LElbj','LForearmPlate', ...
                                      'RShSag','RShLat','RShYaw','RElbj','RForearmPlate', ...
                                      'LHipSag','LHipLat','LHipYaw','LKneeSag','LAnkSag','LAnkLat', ...
                                      'RHipSag','RHipLat','RHipYaw','RKneeSag','RAnkSag','RAnkLat',};
  
% select the link that will be used as floating base
Config.initModel.baseLinkName      = 'Waist';

% model name and path
Config.initModel.modelPath         = './app/walkman/';
Config.initModel.modelName         = 'model.urdf';

% activate/deactivate debug mode
Config.initModel.debugMode         = true;

% either use the GUI or not. Default: true
Config.initModel.useStaticGui      = true;

% list of available simulations. The name specified in the simulation list
% is the name of the script that runs the corresponding demo
Config.initModel.simulationList    = {'runGravityCompensation'};

% for each element of Config.simulationList there should be a corresponding
% folder inside the 'simulations' folder where all the functions and
% scripts relative to the demo are stored
Config.initModel.demoFolderList    = {'gravity-compensation'};

% default simulation and demo folder that will be run when useStaticGui is 
% set to false
Config.initModel.defaultSimulation = 'runGravityCompensation';
Config.initModel.defaultDemoFolder = 'gravity-compensation';

% show a simulation of the system movements
Config.initModel.showVisualizer    = true;
