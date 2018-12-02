% RUNWRAPPERSTEST runs the iDyntree-wrappers test. WARNING: this script
%                 just tests if the wrappers are not exiting with errors. 
%                 Run the wrappers in DEBUG mode to test their soundness.
%
%                 REQUIRED:
%
%                 - Config: [struct] with fields:
%
%                           - Simulator: [struct];
%                           - Model: [struct];
%                           - iDyntreeVisualizer: [struct];
%                           - initWrappersTest: [struct];
%
%                 For more information on the required fields inside
%                 each structure, refer to the documentation inside
%                 the "core" functions.
% 
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% run the script containing the initial conditions for testing
run(strcat(['app/',Config.Simulator.modelFolderName,'/initWrappersTest.m'])); 
clc 

% test 1
disp('1/31: testing idyn_loadReducedModel...')
KinDynModel = idyn_loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Model.modelPath,Config.Model.modelName,Config.Simulator.wrappersDebugMode);
disp('done!')
pause(2)
clc

% test 2
disp('2/31: testing idyn_setRobotState...')
idyn_setRobotState(KinDynModel,Config.initWrappersTest.jointPos_init,Config.initWrappersTest.jointVel_init,Config.initWrappersTest.gravityAcc)
disp('done!')
pause(2)
clc

% test 3
disp('3/31: testing idyn_setJointPos...')
idyn_setJointPos(KinDynModel,Config.initWrappersTest.jointPos_init) 
disp('done!')
pause(2)
clc

% test 4
disp('4/31: testing idyn_setFrameVelocityRepresentation...')
idyn_setFrameVelocityRepresentation(KinDynModel,Config.initWrappersTest.frameVelRepr)
disp('done!')
pause(2)
clc

% test 5
disp('5/31: testing idyn_setFloatingBase...')
idyn_setFloatingBase(KinDynModel,Config.Model.baseLinkName)
disp('done!')
pause(2)
clc
 
% test 6
disp('6/31: testing idyn_getJointPos...')
jointPos = idyn_getJointPos(KinDynModel);
disp('done!')
pause(2)
clc

% test 7
disp('7/31: testing idyn_getJointVel...')
jointVel = idyn_getJointVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 8
disp('8/31: testing idyn_getCentroidalTotalMomentum...')
L = idyn_getCentroidalTotalMomentum(KinDynModel);
disp('done!')
pause(2)
clc

% test 9
disp('9/31: testing idyn_getNrOfDegreesOfFreedom...')
ndof = idyn_getNrOfDegreesOfFreedom(KinDynModel);
disp('done!')
pause(2)
clc

% test 10
disp('10/31: testing idyn_getCenterOfMassPosition...')
posCoM = idyn_getCenterOfMassPosition(KinDynModel);
disp('done!')
pause(2)
clc

% test 11
disp('11/31: testing idyn_getBaseTwist...')
baseVel = idyn_getBaseTwist(KinDynModel);
disp('done!')
pause(2)
clc

% test 12
disp('12/31: testing idyn_generalizedBiasForces...')
h = idyn_generalizedBiasForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 13
disp('13/31: testing idyn_generalizedGravityForces...')
g = idyn_generalizedGravityForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 14
disp('14/31: testing idyn_getWorldBaseTransform...')
basePose = idyn_getWorldBaseTransform(KinDynModel);
disp('done!')
pause(2)
clc

% test 15
disp('15/31: testing idyn_getModelVel...')
stateVel = idyn_getModelVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 16
disp('16/31: testing idyn_getFrameVelocityRepresentation...')
frameVelRepr = idyn_getFrameVelocityRepresentation(KinDynModel);
disp('done!')
pause(2)
clc

% test 17
disp('17/31: testing idyn_getFloatingBase...')
baseLinkName = idyn_getFloatingBase(KinDynModel);
disp('done!')
pause(2)
clc

% test 18
disp('18/31: testing idyn_getFrameIndex...')
frameID = idyn_getFrameIndex(KinDynModel,Config.initWrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 19
disp('19/31: testing idyn_getFrameName...')
frameName = idyn_getFrameName(KinDynModel,Config.initWrappersTest.frameID);
disp('done!')
pause(2)
clc

% test 20
disp('20/31: testing idyn_getWorldTransform...')
w_H_frame = idyn_getWorldTransform(KinDynModel,Config.initWrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 21
disp('21/31: testing idyn_getRelativeTransform...')
frame1_H_frame2 = idyn_getRelativeTransform(KinDynModel,Config.initWrappersTest.frameName,Config.initWrappersTest.frame2Name);
disp('done!')
pause(2)
clc

% test 22
disp('22/31: testing idyn_getRelativeJacobian...')
J_frameVel = idyn_getRelativeJacobian(KinDynModel,Config.initWrappersTest.frameID,Config.initWrappersTest.frame2ID);
disp('done!')
pause(2)
clc

% test 23
disp('23/31: testing idyn_getFreeFloatingMassMatrix...')
M = idyn_getFreeFloatingMassMatrix(KinDynModel);
disp('done!')
pause(2)
clc

% test 24
disp('24/31: testing idyn_getRobotState...')
[basePose2,jointPos2,baseVel2,jointVel2] = idyn_getRobotState(KinDynModel);
disp('done!')
pause(2)
clc

% test 25
disp('25/31: testing idyn_getFrameBiasAcc...')
JDot_nu_frame = idyn_getFrameBiasAcc(KinDynModel,Config.initWrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 26
disp('26/31: testing idyn_getCenterOfMassJacobian...')
J_CoM = idyn_getCenterOfMassJacobian(KinDynModel);
disp('done!')
pause(2)
clc

% test 27
disp('27/31: testing idyn_getCenterOfMassVelocity...')
velCoM = idyn_getCenterOfMassVelocity(KinDynModel);
disp('done!')
pause(2)
clc

% test 28
disp('28/31: testing idyn_getFrameFreeFloatingJacobian...')
J_frame = idyn_getFrameFreeFloatingJacobian(KinDynModel,Config.initWrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 29
disp('29/31: testing idyn_initializeVisualizer...')
Visualizer = idyn_initializeVisualizer(KinDynModel,Config.iDyntreeVisualizer.debug);
disp('done!')
pause(2)
clc

% test 30
disp('30/31: testing idyn_visualizerSetup...')
idyn_visualizerSetup(Visualizer,Config.iDyntreeVisualizer.disableViewInertialFrame,Config.iDyntreeVisualizer.lightDir,Config.iDyntreeVisualizer.cameraPos,Config.iDyntreeVisualizer.cameraTarget);
disp('done!')
pause(2)
clc

% test 31
disp('31/31: testing idyn_updateVisualizer...')
idyn_updateVisualizer(Visualizer,KinDynModel,Config.initWrappersTest.jointPos_init,Config.iDyntreeVisualizer.w_H_b_fixed);
disp('done!')
pause(2)
clc

Visualizer.viz.close();
disp('All tests passed.')