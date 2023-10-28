% FLOATINGBASEBALANCING main script for running the balancing demo.
%
%                     REQUIRED VARIABLES:
%
%                     - Config: [struct] with fields:
%
%                               - Simulator: [struct];
%                               - Model: [struct];
%                               - integration: [struct]; (partially created here)    
%
%                               Optional fields (required if visualization is ON):
%
%                               - Visualization: [struct];
%                               - iDyntreeVisualizer: [struct];
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018; Modeifed Sept. 2020
    
%% ------------Initialization----------------

% run the script containing the initial conditions for the specific demo
run(strcat(['./app/',Config.Simulator.modelFolderName,'/init_simulation.m']));

% create the initial state vector
chi_init = [wbc.fromTransfMatrixToPosQuat(Config.Model.w_H_b_init); Config.Model.jointPos_init; ...
            Config.Model.baseVel_init; Config.Model.jointVel_init];

% create a MAT file where the data to plot/save are stored
if Config.Simulator.showSimulationResults || Config.Simulator.saveSimulationResults
    
    Config.Visualization.dataFileName = mbs.saveSimulationData(Config.Visualization,Config.Simulator,'init');
else
    Config.Visualization.dataFileName = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Forward dynamics integration %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Config.integration.showWaitbar
    
    Config.integration.wait = waitbar(0,'Forward dynamics integration...');
else
    Config.integration.wait = [];
end

% evaluate integration time
c_in = clock;

disp('[floatingBaseBalancing]: integration started...')

forwardDynFunc = @(t,chi) forwardDynamicsBalancing(t,chi,KinDynModel,Config);
[time,state]   = ode15s(forwardDynFunc,Config.integration.tStart:Config.integration.tStep:Config.integration.tEnd,chi_init,Config.integration.options);

disp('[floatingBaseBalancing]: integration ended.')

% evaluate integration time
c_out  = clock;
c_diff = mbs.getTimeDiffInSeconds(c_in,c_out); % [s]
c_diff = mbs.sec2hms(c_diff);                  % [h, m, s]

disp(['[floatingBaseBalancing]: integration time: ', ....
     num2str(c_diff(1)),' h ',num2str(c_diff(2)),' m ',num2str(c_diff(3)),' s.'])

if Config.integration.showWaitbar
    
    delete(Config.integration.wait);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Visualization and Post-Processing %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Config.Simulator.showVisualizer
    
    % define a new structure for the iDyntree visualizer containing the
    % joints position, base pose and time vector
    robotConfiguration               = state(:,1:KinDynModel.NDOF+7);
    Config.SimulationOutput.jointPos = transpose(robotConfiguration(:,8:end));
    Config.SimulationOutput.time     = time;
    Config.SimulationOutput.w_H_b    = [];
    
    for k = 1:size(robotConfiguration,1)
    
        basePosQuat                    = robotConfiguration(k,1:7)';
        w_H_b                          = wbc.fromPosQuatToTransfMatr(basePosQuat);
        Config.SimulationOutput.w_H_b  = [Config.SimulationOutput.w_H_b, w_H_b(:)];
    end 
else
    Config.SimulationOutput = [];
end

if Config.Simulator.showSimulationResults
    
    % remove bad data from ode due to negative dt
    mbs.cleanupDataFromOde(Config.Visualization);
end

if Config.Simulator.showSimulationResults || Config.Simulator.showVisualizer
    
    % open the menu for data plotting and/or for running the iDyntree visualizer
    mbs.openVisualizationMenu(KinDynModel,Config.Visualization,Config.iDyntreeVisualizer, ...
                              Config.Simulator,Config.SimulationOutput, ...
                              Config.Simulator.showSimulationResults, Config.Simulator.showVisualizer);
end

% delete the current simulation data unless 'saveSimulationResults' is TRUE
if ~Config.Simulator.saveSimulationResults
    
    if exist('DATA','dir') && (exist(['./DATA/',Config.Visualization.dataFileName,'.mat'],'file') == 2)
        
        delete(['./DATA/',Config.Visualization.dataFileName,'.mat']);
        dataDir = dir('DATA');
        disp(['[floatingBaseBalancing]: removing file ','./DATA/',Config.Visualization.dataFileName,'.mat'])
        
        if size(dataDir,1) == 2
            
            % data folder is empty. Remove it too.
            rmdir('DATA');  
        end
    end
else
    % append Config structure to the saved data (needed for playback mode)
    DataForVisualization        = matfile(['./DATA/',Config.Visualization.dataFileName,'.mat'],'Writable',true);
    DataForVisualization.Config = Config;
end
