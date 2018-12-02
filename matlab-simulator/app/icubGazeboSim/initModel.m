% INITMODEL initializes the reduced model. NOTE: the reduced model is NOT 
%           jet loaded. This file just contains the model configuration.
%
%           REQUIRED:
%
%           - Config: [struct] with fields:
%
%                     - Simulator: [struct];
%                     - Model: [struct]; (created here)
%
%           For more information on the required fields inside
%           each structure, refer to the documentation inside
%           the "core" functions.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% specify which joints are going to be considered in the reduced model
Config.Model.jointList = {'torso_pitch','torso_roll','torso_yaw',...
                          'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow','l_wrist_prosup', ...
                          'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow','r_wrist_prosup', ...
                          'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll', ...
                          'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};
        
% select the link that will be used as floating base
Config.Model.baseLinkName = 'root_link';

% model name and path
Config.Model.modelPath = './app/icubGazeboSim/';
Config.Model.modelName = 'model.urdf';

% list of available simulations. Each name specified in the simulation list
% is the name of the script that runs the corresponding demo
Config.Model.simulationList = {'runGravityCompensation','runWrappersTest'};

% for each element of the "simulationList" there must be a corresponding
% folder inside the "simulations" folder where all the functions and
% scripts relative to each demo are stored
Config.Model.demoFolderList = {'gravity-compensation','test-idyntree-wrappers'};

% default simulation and default demo folder
Config.Model.defaultSimulation = 'runWrappersTest';
Config.Model.defaultDemoFolder = 'test-idyntree-wrappers';

% specify if the iDyntree simulator is available for this model. It may not
% be available e.g. in case meshes are required to visualize the model links, 
% and the ones available are not of the proper format (.dae)
Config.Model.deactivateVisualizer = false;

% settings sanity checks
if isempty(Config.Model.simulationList)
    
    error('[initModel]: simulationList cannot be empty.')
end

if length(Config.Model.simulationList) ~= length(Config.Model.demoFolderList)
    
    % if a simulation does not have an associated forlder, put '' in the
    % corresponding element of the demoFolderList
    error('[initModel]: simulationList and demoFolderList are not consistent.')
end