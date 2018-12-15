% RUNMATLABSIMULATOR matlab simulator of rigid multi body systems dynamics,
%                    kinematics and control. For further details, see the 
%                    associated README file.
%
%                    REQUIRED VARIABLES:
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
fprintf('\nMatlab rigid-multi-body simulator V1.5\n');
fprintf('\n######################################\n\n');

% TODO: in case the previous simulation exited with an error, remove the
%       paths to the local folders before re-starting.

disp('[runMatlabSimulator]: loading simulation setup...')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% USER DEFINED SIMULATION SETUP %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: create a static GUI with multiple selections instead of this manual
%       selection

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
Config.Simulator.saveSimulationResults  = false;
Config.Simulator.savePictures           = false;

% activate/deactivate the iDyntree wrappers debug mode
Config.Simulator.wrappersDebugMode      = false;

% name of the folder that contains the default model
Config.Simulator.defaultModelFolderName = 'icubGazeboSim';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('[runMatlabSimulator]: ready to start.')

% create a unique tag to identify the current simulation data, pictures and 
% video. The tag is the current hour and minute
c = clock;
Config.Simulator.savedDataTag = [num2str(c(4)),'_', num2str(c(5))];

% add paths to the 'core', 'utility functions' and 'wrappers'
addpath(genpath('./core'))
addpath(genpath('../utility-functions'))
addpath(genpath('../idyntree-high-level-wrappers'))

% create a list of all the folders containing the available models. It is
% assumed that these folders are the ones inside the 'app' folder
Config.Simulator.modelFoldersList = getFoldersList('app');

if isempty(Config.Simulator.modelFoldersList)
    
    error('[runMatlabSimulator]: no model folders found.');
else
    % open the GUI for selecting the model or select the default model
    Config.Simulator.modelFolderName = openModelMenu(Config.Simulator);
end

if ~isempty(Config.Simulator.modelFolderName)

    disp(['[runMatlabSimulator]: loading the model: ', Config.Simulator.modelFolderName])
    
    % run the initModel.m script, which contains the model configuration
    run(strcat(['app/',Config.Simulator.modelFolderName,'/init_', Config.Simulator.modelFolderName, '.m'])); 

    if Config.Model.deactivateVisualizer
 
        % in case the visualizer is not available for the loaded model,
        % overwrite the 'showSimulation' variable option
        Config.Simulator.showVisualizer = false;
    end

    % open the menu for selecting the simulation
    [Config.Simulator.demoFolderName, Config.Simulator.demoScriptName] = openSimulationMenu(Config.Model, Config.Simulator);
    
    if ~isempty(Config.Simulator.demoScriptName)
    
        disp(['[runMatlabSimulator]: running ', Config.Simulator.demoScriptName, ' demo.'])
        
        % the demo script may not have an associated folder (not recommended)
        if ~isempty(Config.Simulator.demoFolderName)          
            % add the path to the simulations folder
            addpath(['./simulations/', Config.Simulator.demoFolderName])
        end
        
        run(Config.Simulator.demoScriptName);
        
        if ~isempty(Config.Simulator.demoFolderName)          
            % remove the path to the simulations folder
            rmpath(['./simulations/', Config.Simulator.demoFolderName])
        end       
    end 
end

% remove local paths
rmpath(genpath('./core'))
rmpath(genpath('../utility-functions'))
rmpath(genpath('../idyntree-high-level-wrappers'))

disp('[runMatlabSimulator]: simulation ended.') 
