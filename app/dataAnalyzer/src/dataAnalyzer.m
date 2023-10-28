% DATAANALYZER main script for running the data analyzer.
%
%                     REQUIRED VARIABLES:
%
%                     - Config: [struct] with fields:
%
%                               - Simulator: [struct];
%                               - Model: [struct];
%                               - SimulationOutput: [struct];
%
%                               Optional fields:
%
%                               - iDyntreeVisualizer: [struct];
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% run the script containing the initial conditions for data analyzer
run(strcat(['./app/',Config.Simulator.modelFolderName,'/init_simulation.m']));

% get the robot data to be processed                                           
run(strcat(['./app/',Config.Simulator.modelFolderName,'/dataProcessing.m']));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Visualization and Post-Processing %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Config.Simulator.showSimulationResults || Config.Simulator.showVisualizer
    
    % open the menu for data plotting and/or for running the iDyntree visualizer
    mbs.runVisualizer(Config.SimulationOutput.jointPos,Config.SimulationOutput.w_H_b,Config.SimulationOutput.time, ...
                      Config.Simulator.createVideo,KinDynModel,Config.iDyntreeVisualizer,Config.Simulator);
end    
