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
Config.Model.jointList = {'torso_pitch','torso_roll','torso_yaw',...
                          'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow', ...
                          'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow', ...
                          'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll', ...
                          'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};
        
% select the link that will be used as base link
Config.Model.baseLinkName = 'root_link';

% name of the urdf file.
Config.Model.modelName    = 'model.urdf';

% TRUE if the iDyntree simulator is NOT available for this model
Config.Model.deactivateVisualizer = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the initial robot position and velocity [deg] and gravity vector
torso_Position     = [ 10  0  0];                 
left_arm_Position  = [-10 25 40 15];           
right_arm_Position = [-10 25 40 15];                
left_leg_Position  = [ 0  0  0  0  0  0];
right_leg_Position = [ 0  0  0  0  0  0]; 

Config.Model.jointPos_init = [torso_Position'; left_arm_Position'; right_arm_Position'; left_leg_Position'; right_leg_Position'] * pi/180;
Config.Model.jointVel_init = zeros(length(Config.Model.jointPos_init),1);
Config.Model.baseVel_init  = [0; 0; 0; 0; 0; 0];
Config.Model.gravityAcc    = [0; 0; -9.81];
Config.Model.nDof          = length(Config.Model.jointPos_init);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Jets Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Config.Model.T_init   = [100; 100; 120; 120];
Config.jets.axes      = [-3; -3; -3; -3];
Config.jets.jetFrames = {'l_arm_jet_turbine','r_arm_jet_turbine','chest_l_jet_turbine','chest_r_jet_turbine'};
Config.jets.njets     = length(Config.jets.axes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Load Reduced Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the reduced model
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Simulator.pathToModel, ...
                                                Config.Model.modelName,Config.Simulator.wrappersDebugMode); 
                                            
% set initial joint positions
iDynTreeWrappers.setRobotState(KinDynModel,Config.Model.jointPos_init,Config.Model.jointVel_init,Config.Model.gravityAcc);

% world reference frame is placed in the first of the fixed frames.
% Therefore it is necessary to compute the relative transformation between
% that frame and the base link, to set the correct initial w_H_b
Config.Model.w_H_b_init = iDynTreeWrappers.getRelativeTransform(KinDynModel,'l_sole',Config.Model.baseLinkName);

% set initial robot state
iDynTreeWrappers.setRobotState(KinDynModel,Config.Model.w_H_b_init, Config.Model.jointPos_init, ...
                               Config.Model.baseVel_init, Config.Model.jointVel_init, Config.Model.gravityAcc);
                           
% get initial CMM
CMM_iDyntree = iDynTree.MatrixDynSize(6,KinDynModel.NDOF+6);
KinDynModel.kinDynComp.getCentroidalTotalMomentumJacobian(CMM_iDyntree);
Config.CMM_0 = CMM_iDyntree.toMatlab;

disp('[init_model]: model loaded correctly.')
