% OPENEXISTINGSIMULATION opens an existing simulation from MAT file and runs 
%                        the visualization tools (if possible). 
%
%                        REQUIRED VARIABLES:
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
%                        each structure, refer to the description of the
%                        functions in the "core" folder.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------
clear variables
close('all','hidden')
clc 

% if TRUE, also plot simulation results (if possible)
showSimulationResults = true;

% if TRUE, the simulation video and pics are saved again
saveSimulationPics    = false;
saveSimulationVideo   = false;

% MAT files are expected to be stored in the 'DATA' folder
if ~exist('./DATA','dir')
    
    error('[openExistingSimulation]: no "DATA" folder found.')
else
    disp('[openExistingSimulation]: ready to load a MAT file.')
    experimentsList = dir('DATA/*.mat');
    expList         = cell(size(experimentsList,1),1);
    
    for k = 1:size(experimentsList,1)
        
        expList{k}  = experimentsList(k).name;
    end
    [expNumber, ~]  = listdlg('PromptString','Choose a MAT file:', ...
                              'ListString',expList, ...
                              'SelectionMode','single', ...
                              'ListSize',[250 150]);                                
    if ~isempty(expNumber)

        % open the experiment
        load(['./DATA/',expList{expNumber}]);
        
        % set savePictures and activateVideoMenu FALSE by default
        Config.Simulator.savePictures = false;
        Config.Simulator.activateVideoMenu = false;
        
        if saveSimulationPics
            
            Config.Simulator.savePictures = true; %#ok<UNRCH>
        end
        if saveSimulationVideo
            
            Config.Simulator.activateVideoMenu = true; %#ok<UNRCH>
        end
            
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
    
            % TODO: the loaded simulation may not use the visualization
            %       menu. Avoid hard-coding.
            if Config.Simulator.showSimulationResults || Config.Simulator.showVisualizer
                
                % open the visualization menu
                openVisualizationMenu(KinDynModel,Config.Visualization,Config.iDyntreeVisualizer, ...
                                      Config.Simulator,Config.SimulationOutput,Config.Simulator.showSimulationResults,Config.Simulator.showVisualizer);
            end
 
            % remove paths
            rmpath(['./simulations/',Config.Simulator.demoFolderName])
            rmpath(genpath('./core'))
            rmpath(genpath('../utility-functions'))
            rmpath(genpath('../idyntree-high-level-wrappers'))
        end
    end
end
disp('[openExistingSimulation]: closing.')