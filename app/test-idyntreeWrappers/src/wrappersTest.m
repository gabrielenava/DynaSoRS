% WRAPPERSTEST runs the iDyntree-wrappers test. NOTE that the soundness of 
%              the wrappers inputs/outputs is instead tested by setting the 
%              variable "wrappersDebugMode" to TRUE.
%
%              REQUIRED VARIABLES:
%
%              - Config: [struct] with fields:
%
%                        - Simulator: [struct];
%                        - Model: [struct];
%                        - iDyntreeVisualizer: [struct];
% 
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018; Modified Sept. 2020
    
%% ------------Initialization----------------

% run the script containing the initial conditions for testing the wrappers
run(strcat(['./app/',Config.Simulator.modelFolderName,'/init_simulation.m'])); 
pause(1)
clc 

% test 1
disp('1/31: testing iDynTreeWrappers.loadReducedModel...')
KinDynModel = iDynTreeWrappers.loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Simulator.pathToModel,Config.Model.modelName,Config.Simulator.wrappersDebugMode);
disp('done!')
pause(2)
clc

% test 2
disp('2/31: testing iDynTreeWrappers.setRobotState...')
iDynTreeWrappers.setRobotState(KinDynModel,Config.Model.jointPos_init,Config.Model.jointVel_init,Config.Model.gravityAcc)
disp('done!')
pause(2)
clc

% test 3
disp('3/31: testing iDynTreeWrappers.setJointPos...')
iDynTreeWrappers.setJointPos(KinDynModel,Config.Model.jointPos_init) 
disp('done!')
pause(2)
clc

% test 4
disp('4/31: testing iDynTreeWrappers.setFrameVelocityRepresentation...')
iDynTreeWrappers.setFrameVelocityRepresentation(KinDynModel,Config.wrappersTest.frameVelRepr)
disp('done!')
pause(2)
clc

% test 5
disp('5/31: testing iDynTreeWrappers.setFloatingBase...')
iDynTreeWrappers.setFloatingBase(KinDynModel,Config.Model.baseLinkName)
disp('done!')
pause(2)
clc
 
% test 6
disp('6/31: testing iDynTreeWrappers.getJointPos...')
jointPos = iDynTreeWrappers.getJointPos(KinDynModel);
disp('done!')
pause(2)
clc

% test 7
disp('7/31: testing iDynTreeWrappers.getJointVel...')
jointVel = iDynTreeWrappers.getJointVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 8
disp('8/31: testing iDynTreeWrappers.getCentroidalTotalMomentum...')
L = iDynTreeWrappers.getCentroidalTotalMomentum(KinDynModel);
disp('done!')
pause(2)
clc

% test 9
disp('9/31: testing iDynTreeWrappers.getNrOfDegreesOfFreedom...')
ndof = iDynTreeWrappers.getNrOfDegreesOfFreedom(KinDynModel);
disp('done!')
pause(2)
clc

% test 10
disp('10/31: testing iDynTreeWrappers.getCenterOfMassPosition...')
posCoM = iDynTreeWrappers.getCenterOfMassPosition(KinDynModel);
disp('done!')
pause(2)
clc

% test 11
disp('11/31: testing iDynTreeWrappers.getBaseTwist...')
baseVel = iDynTreeWrappers.getBaseTwist(KinDynModel);
disp('done!')
pause(2)
clc

% test 12
disp('12/31: testing iDynTreeWrappers.generalizedBiasForces...')
h = iDynTreeWrappers.generalizedBiasForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 13
disp('13/31: testing iDynTreeWrappers.generalizedGravityForces...')
g = iDynTreeWrappers.generalizedGravityForces(KinDynModel);
disp('done!')
pause(2)
clc

% test 14
disp('14/31: testing iDynTreeWrappers.getWorldBaseTransform...')
basePose = iDynTreeWrappers.getWorldBaseTransform(KinDynModel);
disp('done!')
pause(2)
clc

% test 15
disp('15/31: testing iDynTreeWrappers.getModelVel...')
stateVel = iDynTreeWrappers.getModelVel(KinDynModel);
disp('done!')
pause(2)
clc

% test 16
disp('16/31: testing iDynTreeWrappers.getFrameVelocityRepresentation...')
frameVelRepr = iDynTreeWrappers.getFrameVelocityRepresentation(KinDynModel);
disp('done!')
pause(2)
clc

% test 17
disp('17/31: testing iDynTreeWrappers.getFloatingBase...')
baseLinkName = iDynTreeWrappers.getFloatingBase(KinDynModel);
disp('done!')
pause(2)
clc

% test 18
disp('18/31: testing iDynTreeWrappers.getFrameIndex...')
frameID = iDynTreeWrappers.getFrameIndex(KinDynModel,Config.wrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 19
disp('19/31: testing iDynTreeWrappers.getFrameName...')
frameName = iDynTreeWrappers.getFrameName(KinDynModel,Config.wrappersTest.frameID);
disp('done!')
pause(2)
clc

% test 20
disp('20/31: testing iDynTreeWrappers.getWorldTransform...')
w_H_frame = iDynTreeWrappers.getWorldTransform(KinDynModel,Config.wrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 21
disp('21/31: testing iDynTreeWrappers.getRelativeTransform...')
frame1_H_frame2 = iDynTreeWrappers.getRelativeTransform(KinDynModel,Config.wrappersTest.frameName,Config.wrappersTest.frame2Name);
disp('done!')
pause(2)
clc

% test 22
disp('22/31: testing iDynTreeWrappers.getRelativeJacobian...')
J_frameVel = iDynTreeWrappers.getRelativeJacobian(KinDynModel,Config.wrappersTest.frameID,Config.wrappersTest.frame2ID);
disp('done!')
pause(2)
clc

% test 23
disp('23/31: testing iDynTreeWrappers.getFreeFloatingMassMatrix...')
M = iDynTreeWrappers.getFreeFloatingMassMatrix(KinDynModel);
disp('done!')
pause(2)
clc

% test 24
disp('24/31: testing iDynTreeWrappers.getRobotState...')
[basePose2,jointPos2,baseVel2,jointVel2] = iDynTreeWrappers.getRobotState(KinDynModel);
disp('done!')
pause(2)
clc

% test 25
disp('25/31: testing iDynTreeWrappers.getFrameBiasAcc...')
JDot_nu_frame = iDynTreeWrappers.getFrameBiasAcc(KinDynModel,Config.wrappersTest.frameName);
disp('done!')
pause(2)
clc

% test 26
disp('26/31: testing iDynTreeWrappers.getCenterOfMassJacobian...')
J_CoM = iDynTreeWrappers.getCenterOfMassJacobian(KinDynModel);
disp('done!')
pause(2)
clc

% test 27
disp('27/31: testing iDynTreeWrappers.getCenterOfMassVelocity...')
velCoM = iDynTreeWrappers.getCenterOfMassVelocity(KinDynModel);
disp('done!')
pause(2)
clc

% test 28
disp('28/31: testing iDynTreeWrappers.getFrameFreeFloatingJacobian...')
J_frame = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel,Config.wrappersTest.frameName);
disp('done!')
pause(2)
clc

if Config.Simulator.showVisualizer
    
    % test 29
    disp('29/31: testing iDynTreeWrappers.prepareVisualization...')
    meshesPath         = Config.iDyntreeVisualizer.meshesPath;      
    color              = Config.iDyntreeVisualizer.color;            
    material           = Config.iDyntreeVisualizer.material;       
    transparency       = Config.iDyntreeVisualizer.transparency;   
    debug              = Config.iDyntreeVisualizer.debug;           
    view               = Config.iDyntreeVisualizer.view;              
    groundOn           = Config.iDyntreeVisualizer.groundOn;         
    groundColor        = Config.iDyntreeVisualizer.groundColor;       
    groundTransparency = Config.iDyntreeVisualizer.groundTransparency;
    groundFrame        = Config.iDyntreeVisualizer.groundFrame; 
    [Visualizer,~]     = iDynTreeWrappers.prepareVisualization(KinDynModel, meshesPath, 'color', color, 'material', material, ...
                                                              'transparency', transparency, 'debug', debug, 'view', view, ...
                                                              'groundOn', groundOn, 'groundColor', groundColor, ...
                                                              'groundTransparency', groundTransparency, 'groundFrame', groundFrame);
    disp('done!')
    pause(2)
    clc
            
    % test 31
    disp('31/31: testing iDynTreeWrappers.updateVisualization...')
    jointPos_viz = jointPos*0.8;
    iDynTreeWrappers.setRobotState(KinDynModel,eye(4),jointPos_viz,zeros(6,1),zeros(size(jointPos_viz)),Config.Model.gravityAcc);
    iDynTreeWrappers.updateVisualization(KinDynModel,Visualizer);
    disp('done!')
    pause(2)
    clc
    close
else
    disp('Skipping visualizer wrappers...')
end

disp('All tests passed.')
