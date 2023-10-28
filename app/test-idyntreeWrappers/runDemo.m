% RUNDEMO configures and starts the user-defined demo.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Sept 2020
    
%% ------------Initialization----------------
clc
clear variables
close('all','hidden')

% suppress visualization warning message
warning('off','MATLAB:hg:DiceyTransformMatrix')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% USER DEFINED SIMULATION SETUP %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Warning: do not delete the setup options, if they are not necessary in 
% your simulation they will be simply ignored!

% decide either to load the default model or to use model GUI to select it
Config.Simulator.useDefaultModel        = false; 
 
% show a simulation of the system and data plotting (only if available)
Config.Simulator.showVisualizer         = true;
Config.Simulator.showSimulationResults  = true;

% save data and/or activate the option to create a video of the simulation
% and for saving pictures (only if available)
Config.Simulator.activateVideoMenu      = true;
Config.Simulator.saveSimulationResults  = true;
Config.Simulator.savePictures           = true;

% activate/deactivate the iDyntreeWrappers debug mode
Config.Simulator.wrappersDebugMode      = true;

% name of the folder that contains the default model
Config.Simulator.defaultModelFolderName = 'icubGazeboSim';

% name of the user-defined script that starts the demo. NOTE: the file has 
% to be created by the user according to the desired application
Config.Simulator.mainScriptDemoName     = 'wrappersTest';

% names of folders containing external sources. They are the folder located
% into "external" in the mbs_superbuild. If your simulation do not need
% external sources, leave it empty
Config.Simulator.extSourcesFoldersList  = {'FEX-function_handle'};

% user-defined paths to be added for the current simulation
Config.Simulator.userDefPathsList       = {'./src'};

%% DO NOT EDIT BELOW THIS LINE %%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% SELECT THE MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create a list of all the folders containing the available models
Config.Simulator.modelFoldersList = mbs.getFoldersList('app');

if isempty(Config.Simulator.modelFoldersList)
    
    error('[runDemo]: no model folders found.');
else
    % open the GUI for selecting the model or select the default model
    Config.Simulator.modelFolderName = mbs.openModelMenu(Config.Simulator);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONFIGURE PATHS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% configure local paths, save the model path
Config.Simulator.pathToModel = mbs.configLocalPaths(Config.Simulator,'add'); 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
disp('[runDemo]: initialize simulation...') 

% create a unique tag to identify the current simulation data, pictures
% and video. The tag is the current hour and minute
c = clock;
Config.Simulator.savedDataTag = [num2str(c(4)),'_', num2str(c(5))];

if ~isempty(Config.Simulator.modelFolderName)

    disp(['[runDemo]: loading the model: ', Config.Simulator.modelFolderName])

    % run the model initialization script
    run(['./app/',Config.Simulator.modelFolderName,'/init_model.m']);

    if Config.Model.deactivateVisualizer
 
        % in case the visualizer is not available for the loaded model,
        % overwrite the 'showVisualizer' variable option
        Config.Simulator.showVisualizer = false;
    end
    
    % run the simulation
    disp('[runDemo]: running simulation...')
    run([Config.Simulator.mainScriptDemoName,'.m']);
end

% remove local paths
mbs.configLocalPaths(Config.Simulator,'remove'); 
disp('[runDemo]: simulation ended.')
warning('on','MATLAB:hg:DiceyTransformMatrix')
