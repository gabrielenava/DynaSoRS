function [] = openVisualizationMenu(KinDynModel,Visualization,iDyntreeVisualizer,Simulator,SimulationOutput,enableSimulationResults,enableVisualizer)

    % OPENVISUALIZATIONMENU opens a Matlab GUI that allows to select the 
    %                       available plots and other simulation results.
    %
    % FORMAT:  [] = openVisualizationMenu(KinDynModel,Visualization,iDyntreeVisualizer,Simulator,SimulationOutput,mode)
    %
    % INPUTS:  - KinDynModel: a structure containing the loaded model and 
    %                         additional info.
    %          - Visualization: plots-specific configuration parameters;
    %
    %                           REQUIRED FIELDS: (if enableSimulationResults = true)
    %
    %                           - see also "plotSimulationData" 
    %                           - vizVariableList: [cell array of strings];        
    %                           - dataFileName: [string];
    %                           - figureSettingsList: [cell array of structs].
    %
    %          - iDyntreeVisualizer: iDyntree visualizer-specific configuration parameters;
    %
    %                                REQUIRED FIELDS: (if enableVisualizer = true)
    %
    %                                - see "runVisualizer";
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - activateVideoMenu: [bool] (if enableVisualizer = true);
    %                       - see also "runVisualizer" (if enableVisualizer = true);
    %                       - see also "plotSimulationData" (if enableSimulationResults = true);
    %
    %          - SimulationOutput: outcome of the simulation (used for the iDyntree visualizer).
    %
    %                              REQUIRED FIELDS: (if enableVisualizer = true)
    %
    %                              - jointPos: [ndof x nOfInterations] [double];
    %                              - w_H_b: [16 x nOfInterations] [double];
    %                              - time: [1 x nOfInterations] [non-neg double];
    %                              - fixedTimeStep: [non-neg double];
    %
    %          - enableSimulationResults: [bool] enables the data plotting;
    %          - enableVisualizer: [bool] enables the iDyntree visualizer.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % generate the visualization list
    visualizationList  = {};
    figureSettingsList = {};
    cont = 1;
    
    if enableSimulationResults

        % pre-process the visualization list by ignoring all the empty
        % and/or non-double or non-boolean variables
        DataForVisualization = load(['./DATA/',Visualization.dataFileName,'.mat']);
        
        for k = 1:length(Visualization.vizVariableList)
            
            if ~isempty(DataForVisualization.(Visualization.vizVariableList{k})) && isfloat(DataForVisualization.(Visualization.vizVariableList{k}))
        
                if ismatrix(DataForVisualization.(Visualization.vizVariableList{k}))
                    
                    visualizationList{cont}  = Visualization.vizVariableList{k}; %#ok<AGROW>
                    figureSettingsList{cont} = Visualization.figureSettingsList{k}; %#ok<AGROW>
                    cont = cont +1;
                else
                    disp(['[openVisualizationMenu]: ignoring variable ',Visualization.vizVariableList{k}])
                end
            else
                disp(['[openVisualizationMenu]: ignoring variable ',Visualization.vizVariableList{k}])
            end
        end
    end
    
    if enableVisualizer
        
        visualizationList{end+1} = 'iDyntree visualizer';
    end
    
    % keep the menu open until the user explicitly asks for quitting it
    stayInLoop = true;
    
    while stayInLoop
    
        [plotDataList, ~] = listdlg('PromptString', 'Simulation results:', ...
                                    'ListString', visualizationList, ...
                                    'SelectionMode', 'multiple', ...
                                    'ListSize', [250 150]);
        if isempty(plotDataList)
       
            % nothing is selected
            stayInLoop = false;
        else
        
            % close figures that remained open in a previous loop
            close all
            
            % the iDyntree visualizer is shown first (if selected).
            if strcmp(visualizationList{plotDataList(end)},'iDyntree visualizer')

                % keep the interface of the iDyntree visualizer function clear
                jointPos = SimulationOutput.jointPos;
                w_H_b    = SimulationOutput.w_H_b;
                time     = SimulationOutput.time;
                
                % create a video of the simulation
                if Simulator.activateVideoMenu
                    
                    answer = questdlg('Would you like to create a video of the simulation?', ...
	                                  'Simulation Menu', ...
	                                  'Yes','No','No and don''t ask me again','Yes');
                    % handle response
                    switch answer
                        case ''
                            createVideo = false; 
                        case 'Yes'
                            createVideo = true;                    
                        case 'No'
                            createVideo = false; 
                        case 'No and don''t ask me again'
                            createVideo = false;
                            Simulator.activateVideoMenu = false;
                    end
                else
                    createVideo = false;
                end
                mbs.runVisualizer(jointPos,w_H_b,time,createVideo,KinDynModel,iDyntreeVisualizer,Simulator)             
            end
            
            if enableSimulationResults
                  
                dataNameList = {};
                UpdatedFigureSettingsList = {};

                for k = 1:length(plotDataList)

                    if ~strcmp(visualizationList{plotDataList(k)},'iDyntree visualizer')
                    
                        dataNameList{k} = visualizationList{plotDataList(k)}; %#ok<AGROW>
                        UpdatedFigureSettingsList{k} = figureSettingsList{plotDataList(k)}; %#ok<AGROW>
                    end
                end
                
                if ~isempty(dataNameList)
                    
                    % plot the other results
                    mbs.plotSimulationData(dataNameList,UpdatedFigureSettingsList,DataForVisualization,Visualization,Simulator);
                end
            end
        end
    end
end
