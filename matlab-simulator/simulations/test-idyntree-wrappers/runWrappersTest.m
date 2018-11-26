% RUNWRAPPERSTEST runs the iDyntree-wrappers test. WARNING: this script
%                 just tests if the wrappers are correctly working. It does
%                 not test if the quantities that are set to or get from
%                 the model are correct. Running the wrappers in DEBUG mode
%                 can help in testing the soundness of these quantities.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% run the script containing the initial conditions for testing
run(strcat(['app/',Config.initFolderName,'/initWrappersTest.m'])); 
clc 

% test 1
disp('testing idyn_loadReducedModel...')
KinDynModel = idyn_loadReducedModel(Config.initModel.jointList,Config.initModel.baseLinkName,Config.initModel.modelPath,Config.initModel.modelName,Config.initModel.debugMode);
disp('done!')
pause(2)
clc

% test 2
disp('testing idyn_setRobotState...')
idyn_setRobotState(KinDynModel,Config.initConditions.jointPos_init,Config.initConditions.jointVel_init,Config.gravityAcc)
disp('done!')
pause(2)
clc

% test 3
disp('testing idyn_setJointPos...')
idyn_setJointPos(KinDynModel,Config.initConditions.jointPos_init) 
disp('done!')
pause(2)
clc

% test 4
disp('testing idyn_setFrameVelocityRepresentation...')
idyn_setFrameVelocityRepresentation(KinDynModel,Config.frameVelRepr)
disp('done!')
pause(2)
clc

% test 5
disp('testing idyn_setFloatingBase...')
idyn_setFloatingBase(KinDynModel,Config.initModel.baseLinkName)
disp('done!')
pause(2)
clc
 
% test 6
disp('testing idyn_getJointPos...')
jointPos = idyn_getJointPos(KinDynModel);
disp('done!')
pause(2)
clc

% test 7
disp('testing idyn_getJointVel...')
jointVel = idyn_getJointVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 8
disp('testing idyn_getCentroidalTotalMomentum...')
L = idyn_getCentroidalTotalMomentum(KinDynModel);
disp('done!')
pause(2)
clc

% test 9
disp('testing idyn_getNrOfDegreesOfFreedom...')
ndof = idyn_getNrOfDegreesOfFreedom(KinDynModel);
disp('done!')
pause(2)
clc

% test 10
disp('testing idyn_getCenterOfMassPosition...')
posCoM = idyn_getCenterOfMassPosition(KinDynModel);
disp('done!')
pause(2)
clc

% test 11
disp('testing idyn_getBaseTwist...')
baseVel = idyn_getBaseTwist(KinDynModel);
disp('done!')
pause(2)
clc

% test 12
disp('testing idyn_generalizedBiasForces...')
h = idyn_generalizedBiasForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 13
disp('testing idyn_generalizedGravityForces...')
g = idyn_generalizedGravityForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 14
disp('testing idyn_getWorldBaseTransform...')
basePose = idyn_getWorldBaseTransform(KinDynModel);
disp('done!')
pause(2)
clc

% test 15
disp('testing idyn_getModelVel...')
stateVel = idyn_getModelVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 16
disp('testing idyn_getFrameVelocityRepresentation...')
frameVelRepr = idyn_getFrameVelocityRepresentation(KinDynModel);
disp('done!')
pause(2)
clc

% test 17
disp('testing idyn_getFloatingBase...')
baseLinkName = idyn_getFloatingBase(KinDynModel);
disp('done!')
pause(2)
clc

% test 18
disp('testing idyn_getFrameIndex...')
frameID = idyn_getFrameIndex(KinDynModel,Config.frameName);
disp('done!')
pause(2)
clc

% test 19
disp('testing idyn_getFrameName...')
frameName = idyn_getFrameName(KinDynModel,Config.frameID);
disp('done!')
pause(2)
clc

% test 20
disp('testing idyn_getWorldTransform...')
w_H_frame = idyn_getWorldTransform(KinDynModel,Config.frameName);
disp('done!')
pause(2)
clc

% test 21
disp('testing idyn_getRelativeTransform...')
frame1_H_frame2 = idyn_getRelativeTransform(KinDynModel,Config.frameName,Config.frame2Name);
disp('done!')
pause(2)
clc

% test 22
disp('testing idyn_getRelativeJacobian...')
J_frameVel = idyn_getRelativeJacobian(KinDynModel,Config.frameID,Config.frame2ID);
disp('done!')
pause(2)
clc

% test 23
disp('testing idyn_getFreeFloatingMassMatrix...')
M = idyn_getFreeFloatingMassMatrix(KinDynModel);
disp('done!')
pause(2)
clc

% test 24
disp('testing idyn_getRobotState...')
[basePose2,jointPos2,baseVel2,jointVel2] = idyn_getRobotState(KinDynModel);
disp('done!')
pause(2)
clc

% test 25
disp('testing idyn_getFrameBiasAcc...')
JDot_nu_frame = idyn_getFrameBiasAcc(KinDynModel,Config.frameName);
disp('done!')
pause(2)
clc

% test 26
disp('testing idyn_getCenterOfMassJacobian...')
J_CoM = idyn_getCenterOfMassJacobian(KinDynModel);
disp('done!')
pause(2)
clc

% test 27
disp('testing idyn_getCenterOfMassVelocity...')
velCoM = idyn_getCenterOfMassVelocity(KinDynModel);
disp('done!')
pause(2)
clc

% test 28
disp('testing idyn_getFrameFreeFloatingJacobian...')
J_frame = idyn_getFrameFreeFloatingJacobian(KinDynModel,Config.frameName);
disp('done!')
pause(2)
clc

% test 29
disp('testing idyn_initializeVisualizer...')
Visualizer = idyn_initializeVisualizer(KinDynModel,Config.visualizer.debug);
disp('done!')
pause(2)
clc

% test 30
disp('testing idyn_visualizerSetup...')
idyn_visualizerSetup(Visualizer,Config.visualizer.disableViewInertialFrame,Config.visualizer.lightDir,Config.visualizer.cameraPos,Config.visualizer.cameraTarget);
disp('done!')
pause(2)
clc

% test 31
disp('testing idyn_updateVisualizer...')
idyn_updateVisualizer(Visualizer,KinDynModel,Config.initConditions.jointPos_init,Config.visualizer.w_H_b_fixed);
disp('done!')
pause(2)
clc

disp('All tests passed.')