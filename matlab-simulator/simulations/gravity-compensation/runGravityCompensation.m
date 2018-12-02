% RUNGRAVITYCOMPENSATION runs the gravity compensation simulation.
%
%                        REQUIRED:
%
%                        - Config: [struct] with fields:
%
%                                  - Simulator: [struct];
%                                  - Model: [struct];
%                                  - Visualization: [struct]; (partially created here)
%                                  - iDyntreeVisualizer: [struct];
%                                  - SimulationOutput: [struct]; (created here)
%                                  - initGravComp: [struct];
%                                  - integration: [struct]; (partially created here)       
%
%                        For more information on the required fields inside
%                        each structure, refer to the documentation inside
%                        the "core" functions.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% run the script containing the initial conditions for the gravity compensation demo
run(strcat(['app/',Config.Simulator.modelFolderName,'/initGravityCompensation.m']));

% load the reduced model
KinDynModel = idyn_loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Model.modelPath, ...
                                    Config.Model.modelName,Config.Simulator.wrappersDebugMode); 

% set the initial robot state 
idyn_setRobotState(KinDynModel,Config.initGravComp.jointPos_init,Config.initGravComp.jointVel_init,Config.initGravComp.gravityAcc)
 
% create the initial state vector. For gravity compensation, chi = [jointVel; jointPos]
chi_init = [Config.initGravComp.jointVel_init; Config.initGravComp.jointPos_init];

% create a MAT file where the data to plot are stored
if Config.Simulator.showSimulationResults || Config.Simulator.saveSimulationResults
    
    Config.Visualization.dataFileName = saveSimulationData(Config.Visualization,Config.Simulator,'init');
else
    Config.Visualization.dataFileName = [];
end

% forward dynamics integration
if Config.integration.showWaitbar
    
    Config.integration.wait = waitbar(0,'Forward dynamics integration...');
else
    Config.integration.wait = [];
end

% evaluate integration time
c_in = clock;

forwardDynFunc   = @(t,chi) forwardDynamicsGravityComp(t,chi,KinDynModel,Config);
[time,state]     = ode15s(forwardDynFunc,Config.integration.tStart:Config.integration.tStep:Config.integration.tEnd,chi_init,Config.integration.options);

disp('[runGravityCompensation]: integration ended.')

% evaluate integration time
c_out  = clock;
c_diff = getTimeDiffInSeconds(c_in,c_out); %[s]
c_diff = sec2hms(c_diff); %[h m s]

disp(['[runGravityCompensation]: integration time: ', ....
     num2str(c_diff(1)),' h ',num2str(c_diff(2)),' m ',num2str(c_diff(3)),' s.'])

if Config.integration.showWaitbar
    
    delete(Config.integration.wait);
end

if Config.Simulator.showVisualizer
    
    % define a new structure for the iDyntree visualizer containing the
    % joint position, base pose and visualization time step
    Config.SimulationOutput.jointPos      = transpose(state(:,KinDynModel.NDOF+1:end));
    Config.SimulationOutput.w_H_b         = Config.iDyntreeVisualizer.w_H_b_fixed(:);
    Config.SimulationOutput.time          = time;
    Config.SimulationOutput.fixedTimeStep = Config.integration.tStep;
else
    Config.SimulationOutput = [];
end

if Config.Simulator.showSimulationResults || Config.Simulator.showVisualizer
    
    % open the menu for data plotting and/or for running the iDyntree simulator
    openVisualizationMenu(KinDynModel,Config.Visualization,Config.iDyntreeVisualizer, ...
                          Config.Simulator,Config.SimulationOutput);
end

% delete the current simulation data unless saveSimulationData is TRUE
if ~Config.Simulator.saveSimulationResults
    
    if exist('data','dir') && (exist(['./data/',Config.Visualization.dataFileName,'.mat'],'file') == 2)
        
        delete(['./data/',Config.Visualization.dataFileName,'.mat']);
        dataDir = dir('data');
        
        if size(dataDir,1) == 2
            
            % data folder is empty. Remove it.
            rmdir('data');  
        end
    end
else
    % append Config structure to the saved data
    DataForVisualization             = matfile(['./data/',Config.Visualization.dataFileName,'.mat'],'Writable',true);
    DataForVisualization.Config      = Config;
end