close all
clc
clear

addpath('../')
disp('Testing Visualizer class ...')

% load the urdf model
model.jointList = {'joint_1','joint_2'};
model.baseLinkName = 'root_link';
model.modelName = 'simpleRobot.urdf';
model.modelPath = '../models/';
DEBUG = true;

KinDynModel = iDynTreeWrappers.loadReducedModel(model.jointList, model.baseLinkName, ...
    model.modelPath, model.modelName, DEBUG);

% set the initial robot position and velocity and gravity vector
jointPos_init = [45  30]/180*pi;
gravityAcc = [0;0;-9.81];
w_H_b_init = eye(4);

iDynTreeWrappers.setRobotState(KinDynModel, w_H_b_init, jointPos_init, zeros(6,1), ...
    zeros(length(jointPos_init),1), gravityAcc);

%% Test 1: static visualization with no custom options

% create an object of the visualizer class and call the default methods
viz1 = dynasors.Visualizer(w_H_b_init, jointPos_init', 0, KinDynModel);

pause(3)
viz1.close();

%% Test 2: static visualization with custom options

viz_opt.gravityVector = [0; 0; -9.81];
viz_opt.meshesPath = '';
viz_opt.color = [0.9,0.1,0.1];
viz_opt.material = 'metal';
viz_opt.transparency = 0.5;
viz_opt.debug = true;
viz_opt.view = [-50 10];
viz_opt.groundOn = false;
viz_opt.groundColor = [0.7 0.7 0.7];
viz_opt.groundTransparency = 0.7;

viz2 = dynasors.Visualizer(w_H_b_init, jointPos_init', 0, KinDynModel, viz_opt);

pause(3)
viz2.close();

%% Test 3: animation

% generate motion of joints and w_H_b
time = linspace(0, 5, 10000);

j1 = linspace(-60, 70, 10000)*pi/180;
j2 = linspace(-55, 45, 10000)*pi/180;

basePos = [linspace(-2.5,  1, 10000);
    linspace(-1, 2, 10000);
    linspace(-1.5, 2, 10000)];

baseRPY = [linspace(-40, 35, 10000);
    linspace(-25, 45, 10000);
    linspace(-15, 35, 10000)]*pi/180;

jointPos = [j1; j2];

w_H_b = zeros(4,4, 10000);

for k = 1:10000

    w_R_b = dynasors.rotationFromRollPitchYaw(baseRPY(:,k));
    w_H_b(:,:,k) = [w_R_b, basePos(:,k); 0 0 0 1];
end

% decimate data so that they can be visualized real time
tStep = 0.01;
[w_H_b_dec, jointPos_dec, time_dec] = dynasors.interpolateData(w_H_b, jointPos, time, tStep);

viz3 = dynasors.Visualizer(w_H_b_dec, jointPos_dec, time_dec, KinDynModel, viz_opt);
viz3.run();
pause(1)
viz3.close();

disp('Done!')
rmpath('../')
