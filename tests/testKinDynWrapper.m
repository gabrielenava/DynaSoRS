close all
clc
clear

addpath('../')
disp('Testing KinDynWrapper class ...')

% load the urdf model
model.jointList = {'joint_1','joint_2'};
model.baseLinkName = 'root_link';
model.modelName = 'simpleRobot.urdf';
model.modelPath = '../models/';
DEBUG = true;

KinDynModel = iDynTreeWrappers.loadReducedModel(model.jointList, model.baseLinkName, ...
    model.modelPath, model.modelName, DEBUG);

% set the initial robot position and velocity [deg] and gravity vector
jointPos_init = [10  20];
gravityAcc = [0;0;-9.81];
w_H_b_init = eye(4);

iDynTreeWrappers.setRobotState(KinDynModel, w_H_b_init, jointPos_init, zeros(6,1), ...
    zeros(length(jointPos_init),1), gravityAcc);

% create an object of the kindynwrapper class and call the default methods
kindynwrapper = dynasors.KinDynWrapper();

J_G = kindynwrapper.getCentroidalTotalMomentumJacobian(KinDynModel);
disp('Printing Centroidal Momentum Matrix ...')
disp(J_G)
disp('Done!')
rmpath('../')
