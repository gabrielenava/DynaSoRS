% RUNGRAVITYCOMPENSATION runs the gravity compensation simulation.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% load the reduced model
KinDynModel = idyn_loadReducedModel(Config.initModel.jointList,Config.initModel.baseLinkName,Config.initModel.modelPath,Config.initModel.modelName,Config.initModel.debugMode);

% run the script containing the initial conditions for the gravity
% compensation demo
run(strcat(['app/',Config.initFolderName,'/initGravityCompensation.m'])); 

% set the initial robot state 
idyn_setRobotState(KinDynModel,Config.initConditions.jointPos_init,Config.initConditions.jointVel_init,Config.gravityAcc)
 
% create the initial state. For gravity compensation, chi = [jointVel;jointPos]
chi_init = [Config.initConditions.jointVel_init;Config.initConditions.jointPos_init];

% forward dynamics integration
if Config.integration.showWaitbar
    
    Config.integration.wait = waitbar(0,'Forward dynamics integration...');
else
    Config.integration.wait = [];
end

forwardDynFunc   = @(t,chi) forwardDynamicsGravityComp(t,chi,KinDynModel,Config);
[t_vec,chi_matr] = ode15s(forwardDynFunc,Config.integration.tStart:Config.integration.tStep:Config.integration.tEnd,chi_init,Config.integration.options);

disp('[runGravityCompensation]: integration ended.')

if Config.integration.showWaitbar
    
    delete(Config.integration.wait);
end

% start the visualizer
if Config.initModel.showVisualizer
    
    disp('[runGravityCompensation]: press any button to start the visualizer')
    pause();
    runVisualizerFixedBase(chi_matr,KinDynModel,Config);
end