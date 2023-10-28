% OPENEXISTINGSIMULATION opens an existing simulation from a MAT file and 
%                        runs the visualization tools (if available). 
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
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018; Modified Jan. 2022
    
%% ------------Initialization----------------
clear variables
close('all','hidden')
clc 

% suppress visualization warning message
warning('off','MATLAB:hg:DiceyTransformMatrix')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% USER DEFINED SIMULATION SETUP %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if TRUE, also plot simulation results (if possible)
showSimulationResults = true;

% if TRUE, the simulation video and pics are saved again
saveSimulationPics    = true;
saveSimulationVideo   = true;

%% DO NOT EDIT BELOW THIS LINE %%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% SELECT AND READ THE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        disp('[openExistingSimulation]: MAT file loaded.')
        
        % set savePictures and activateVideoMenu FALSE by default
        Config.Simulator.savePictures      = false;
        Config.Simulator.activateVideoMenu = false;
        
        if saveSimulationPics
            
            Config.Simulator.savePictures = true;
        end
        if saveSimulationVideo
            
            Config.Simulator.activateVideoMenu = true; 
        end
            
        % show results (if available)
        if showSimulationResults

            % add required paths
            Config.Simulator.pathToModel = mbs.configLocalPaths(Config.Simulator,'add');

            % load the reduced model (kinDynModel is not properly saved in
            % the MAT file and needs to be reloaded)
            KinDynModel = iDynTreeWrappers.loadReducedModel(Config.Model.jointList,Config.Model.baseLinkName,Config.Simulator.pathToModel, ...
                                                            Config.Model.modelName,Config.Simulator.wrappersDebugMode); 
    
            if Config.Simulator.showSimulationResults || Config.Simulator.showVisualizer
                
                % open the visualization menu
                mbs.openVisualizationMenu(KinDynModel,Config.Visualization,Config.iDyntreeVisualizer, Config.Simulator, ...
                                          Config.SimulationOutput,Config.Simulator.showSimulationResults, ...
                                          Config.Simulator.showVisualizer);
            end
 
            % remove paths
            mbs.configLocalPaths(Config.Simulator,'remove'); 
        end
    end
end
disp('[openExistingSimulation]: closing.')
warning('on','MATLAB:hg:DiceyTransformMatrix')
