% INIT_ROBOT robot-related settings and parameters.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova: Mar. 2024
%

% specify the list of joints that are going to be considered in the reduced model
Config.model.jointList = {'joint_1','joint_2'};

% select the link that will be used as base link
Config.model.baseLinkName = 'root_link';

% model name and path
Config.model.modelName = 'simpleRobot.urdf';
Config.model.modelPath = '../../../models/';
DEBUG                  = false;

% set the initial robot position and velocity [deg] and gravity vector
Config.initCond.jointPos_init = [10; 20]*pi/180;
Config.ndof                   = length(Config.initCond.jointPos_init);
Config.initCond.jointVel_init = zeros(Config.ndof,1);
Config.gravityAcc             = [0;0;-9.81];

% load the reduced model
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.model.jointList, Config.model.baseLinkName, ...
    Config.model.modelPath, Config.model.modelName, DEBUG);

% set the initial robot position
iDynTreeWrappers.setRobotState(KinDynModel, Config.initCond.jointPos_init, Config.initCond.jointVel_init, Config.gravityAcc);
