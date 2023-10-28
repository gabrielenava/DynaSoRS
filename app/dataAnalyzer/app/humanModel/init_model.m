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
Config.Model.jointList = {'jRightC7Shoulder_rotx', ...
                          'jRightShoulder_rotx', 'jRightShoulder_roty', 'jRightShoulder_rotz',...
                          'jRightElbow_roty', 'jRightElbow_rotz', ...
                          'jRightWrist_rotx', 'jRightWrist_rotz', ...
                          'jRightPalm_roty', ...
                          'jRightPinky1_rotz','jRightRing1_rotz','jRightMiddle1_rotz','jRightIndex1_rotz', ...
                          'jRightPinky1_rotx', 'jRightMiddle1_rotx', 'jRightRing1_rotx', 'jRightIndex1_rotx', ...
                          'jRightIndex2_rotx', 'jRightIndex3_rotx', ...
                          'jRightRing2_rotx', 'jRightRing3_rotx', ...
                          'jRightThumb1_rotz', 'jRightThumb1_roty', 'jRightThumb2_rotx', 'jRightThumb3_rotx', ...
                          'jRightMiddle2_rotx', 'jRightMiddle3_rotx', ...
                          'jRightPinky2_rotx' , 'jRightPinky3_rotx', ...
                          'jL5S1_rotx', 'jL5S1_roty', ...
                          'jL4L3_rotx', 'jL4L3_roty', ...
                          'jL1T12_rotx','jL1T12_roty', ...
                          'jT9T8_rotx', 'jT9T8_roty', 'jT9T8_rotz'};
     
% select the link that will be used as base link
Config.Model.baseLinkName = 'Pelvis';

% name of the urdf file.
Config.Model.modelName    = 'model.urdf';

% TRUE if the iDyntree simulator is NOT available for this model
Config.Model.deactivateVisualizer = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the initial robot position and velocity [deg] and gravity vector
Config.Model.jointPos_init = zeros(length(Config.Model.jointList),1);
Config.Model.jointVel_init = zeros(length(Config.Model.jointPos_init),1);
Config.Model.gravityAcc    = [0;0;-9.81];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Load Reduced Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the reduced model
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Simulator.pathToModel, ...
                                                Config.Model.modelName,Config.Simulator.wrappersDebugMode); 
                                            
disp('[init_model]: model loaded correctly.')
