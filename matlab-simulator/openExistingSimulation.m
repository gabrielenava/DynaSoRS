% OPENEXISTINGSIMULATION opens an existing simulation from MAT file and runs 
%                        the visualization tools. WARNING: plots and the
%                        iDyntree visualizer anyways require functionalities
%                        of the matlab-simulator. 
%
%                        REQUIRED:
%
%                        - Config: [struct] with fields:
%
%                                  - Simulator: [struct];
%                                  - Model: [struct];
%                                  - Visualization: [struct];
%                                  - iDyntreeVisualizer: [struct];
%                                  - SimulationOutput: [struct];
%
%                        For more information on the required fields inside
%                        each structure, refer to the documentation inside
%                        the "core" functions.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------
clear
close('all','hidden')
clc 

% if TRUE, plot simulation results
showSimulationResults = true;

% MAT files are expected to be stored in the 'data' folder
if ~exist('./data','dir')
    
    error('[openExistingSimulation]: no "data" folder found.')
else
    disp('[openExistingSimulation]: ready to load a MAT file.')
    experimentsList = dir('data/*.mat');
    expList         = cell(size(experimentsList,1),1);
    
    for k = 1:size(experimentsList,1)
        
        expList{k}  = experimentsList(k).name;
    end
    [expNumber, ~]  = listdlg('PromptString','CHOOSE AN EXPERIMENT:', ...
                              'ListString',expList, ...
                              'SelectionMode','single', ...
                              'ListSize',[250 150]);                                
    if ~isempty(expNumber)

        % open the experiment
        load(['./data/',expList{expNumber}]);
        
        % show results (if available)
        if showSimulationResults 

            % add required paths
            addpath(genpath('./core'))
            addpath(genpath('../utility-functions'))
            addpath(genpath('../idyntree-high-level-wrappers'))
            addpath(['./simulations/',Config.Simulator.demoFolderName])

            % load the reduced model (it cannot be properly stored in MAT files)
            KinDynModel = idyn_loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Model.modelPath, ...
                                                Config.Model.modelName,Config.Simulator.wrappersDebugMode);
    
            % open the visualization menu
            openVisualizationMenu(KinDynModel,Config.Visualization,Config.iDyntreeVisualizer, ...
                                  Config.Simulator,Config.SimulationOutput)

            % remove paths
            rmpath(['./simulations/',Config.Simulator.demoFolderName])
            rmpath(genpath('./core'))
            rmpath(genpath('../utility-functions'))
            rmpath(genpath('../idyntree-high-level-wrappers'))
        end
    end
end

disp('[openExistingSimulation]: closing.')
