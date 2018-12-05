% RUNMATLABSIMULATOR matlab simulator of rigid multi body systems dynamics,
%                    kinematics and control. See the README file for details.
%
%                    REQUIRED:
%
%                    - Config: [struct] with fields:
%
%                              - Simulator: [struct]; (created here)
%                              - Model: [struct];
%
%                    For more information on the required fields inside
%                    each structure, refer to the description of the
%                    functions in the "core" folder.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------
clear variables
close('all','hidden')
clc

fprintf('\n######################################\n');
fprintf('\nMatlab rigid-multi-body simulator V1.3\n');
fprintf('\n######################################\n\n');

% TODO: in case the previous simulation exited with an error, remove the
%       paths to the local folders before starting

disp('[runMatlabSimulator]: loading simulation setup...')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% USER DEFINED SIMULATION SETUP %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% decide either to load the default model or to use the GUI to select it
Config.Simulator.useDefaultModel        = false; 

% decide either to run the default simulation or to use the GUI to select it
Config.Simulator.runDefaultSimulation   = false;
 
% show a simulation of the system and data plotting (only if available)
Config.Simulator.showVisualizer         = true;
Config.Simulator.showSimulationResults  = true;

% save data and/or activate the option for creating a video of the simulation
% and for saving pictures (only if available)
Config.Simulator.activateVideoMenu      = true;
Config.Simulator.saveSimulationResults  = true;
Config.Simulator.savePictures           = true;

% activate/deactivate the iDyntree wrappers debug mode
Config.Simulator.wrappersDebugMode      = false;

% name of the folder that contains the default model
Config.Simulator.defaultModelFolderName = 'icubGazeboSim';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('[runMatlabSimulator]: ready to start.')

% generate a tag to identify the current simulation
c = clock;
Config.Simulator.savedDataTag = [num2str(c(4)),'_',num2str(c(5))];

% add paths to the simulator core, utility functions and wrappers
addpath(genpath('./core'))
addpath(genpath('../utility-functions'))
addpath(genpath('../idyntree-high-level-wrappers'))

% create a list of all the folders containing the available models
Config.Simulator.foldersList = getFoldersList('app');

% open the GUI for selecting the model
if isempty(Config.Simulator.foldersList)
    
    error('[runMatlabSimulator]: no model folders found.');
else
    Config.Simulator.modelFolderName = openModelMenu(Config.Simulator);
end

if ~isempty(Config.Simulator.modelFolderName)

    disp(['[runMatlabSimulator]: loading the model: ',Config.Simulator.modelFolderName])
    
    % run the initModel.m, which contains the model configuration
    run(strcat(['app/',Config.Simulator.modelFolderName,'/initModel.m'])); 
    
    % in case the visualizer is not available for the loaded model
    % set the "showSimulation" variable to false
    if Config.Model.deactivateVisualizer
 
        Config.Simulator.showVisualizer = false;
    end

    % open the menu for selecting the simulation
    [Config.Simulator.demoFolderName,Config.Simulator.demoScriptName] = openSimulationMenu(Config.Model,Config.Simulator);
    
    if ~isempty(Config.Simulator.demoScriptName)
    
        disp(['[runMatlabSimulator]: running ', Config.Simulator.demoScriptName,' demo.'])
        
        % add path to the simulations folder
        addpath(['./simulations/',Config.Simulator.demoFolderName])
        run(Config.Simulator.demoScriptName); 
        rmpath(['./simulations/',Config.Simulator.demoFolderName])
    end 
end

% remove paths
rmpath(genpath('./core'))
rmpath(genpath('../utility-functions'))
rmpath(genpath('../idyntree-high-level-wrappers'))

disp('[runMatlabSimulator]: simulation ended.') 