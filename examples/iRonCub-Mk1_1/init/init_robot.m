% INIT_ROBOT robot-related settings and parameters.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Dec. 2022
%

% specify the list of joints that are going to be considered in the reduced model
Config.model.jointList = {'torso_pitch','torso_roll','torso_yaw', ...
                          'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow', ...
                          'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow', ...
                          'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll', ...
                          'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};

% select the link that will be used as base link
Config.model.baseLinkName = 'root_link';

% model name and path
robot_name             = 'iRonCub-Mk1_1';
component_path         = getenv('IRONCUB_SOFTWARE_SOURCE_DIR');
Config.model.modelName = 'model_stl.urdf';
Config.model.modelPath = [component_path '/models/' robot_name '/iRonCub/robots/' robot_name '/'];
Config.meshesPath      = [component_path '/models/'];
DEBUG                  = false;

% set the initial robot position and velocity [deg] and gravity vector
torso_Position     = [ 10  0  0];              
left_arm_Position  = [-10 25 15 18];           
right_arm_Position = [-10 25 15 18];
left_leg_Position  = [  5  0  0  0  0  0];
right_leg_Position = [  5  0  0  0  0  0];

Config.initCond.jointPos_init = [torso_Position';left_arm_Position';right_arm_Position';left_leg_Position';right_leg_Position']*pi/180;
Config.gravityAcc             = [0;0;-9.81];
Config.ndof                   = length(Config.initCond.jointPos_init);

% initial base pose w.r.t. the world frame
Config.initCond.w_H_b_init = eye(4);

% load the reduced model
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.model.jointList, Config.model.baseLinkName, ...
                                                Config.model.modelPath, Config.model.modelName, DEBUG);

% set the initial robot position (no w_H_b set yet)
iDynTreeWrappers.setRobotState(KinDynModel, Config.initCond.w_H_b_init, Config.initCond.jointPos_init, ...
                               zeros(6,1), zeros(Config.ndof,1), Config.gravityAcc);

% set the w_H_b transformation, assuming that the world frame is attached to the robot left foot
Config.initCond.w_H_b_init = iDynTreeWrappers.getRelativeTransform(KinDynModel,'l_sole','root_link');

% set the initial robot state (w_H_b is now correct)
iDynTreeWrappers.setRobotState(KinDynModel, Config.initCond.w_H_b_init, Config.initCond.jointPos_init, ...
                               zeros(6,1), zeros(Config.ndof,1), Config.gravityAcc);

% allocate Centroidal Momentum Matrix for iDynTree calculations
KinDynModel.dynamics.J_G_iDyntree = iDynTree.MatrixDynSize(6,Config.ndof+6);

% initial CoM position
Config.initCond.posCoM_init = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);

% turbines related data
Config.turbinesData.turbineList = {'l_arm_jet_turbine','r_arm_jet_turbine','chest_l_jet_turbine','chest_r_jet_turbine'};
Config.turbinesData.turbineAxis = [-3; -3; -3; -3];
Config.turbinesData.njets       = length(Config.turbinesData.turbineList);
