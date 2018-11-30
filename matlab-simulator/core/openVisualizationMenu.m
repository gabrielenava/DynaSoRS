function [] = openVisualizationMenu(KinDynModel,Visualization,iDyntreeVisualizer,Simulator,SimulationOutput)

    % OPENVISUALIZATIONMENU opens a Matlab GUI that shows the available
    %                       plots and other simulation results.
    %
    % FORMAT:  openVisualizationMenu(KinDynModel,Visualization,Simulator,SimulationOutput)
    %
    % INPUTS:  - KinDynModel: a structure containing the loaded model and 
    %                         additional info.
    %          - Visualization: plots-specific configuration parameters;
    %
    %                           REQUIRED FIELDS: (if showSimulationResults = true)
    %
    %                           - see also "plotSimulationData" 
    %                           - vizVariableList: [cell array of strings];        
    %                           - dataFileName: [string];
    %
    %          - iDyntreeVisualizer: iDyntree visualizer-specific configuration parameters;
    %
    %                                REQUIRED FIELDS: (if showVisualizer = true)
    %
    %                                - see "runVisualizer";
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - showSimulationResults: [bool];
    %                       - showVisualizer: [bool];
    %                       - activateVideoOption: [bool] (if showVisualizer = true);
    %                       - see also "runVisualizer" (if showVisualizer = true);
    %                       - see also "plotSimulationData" (if showSimulationResults = true);
    %
    %          - SimulationOutput: outcome of the simulation (used for the iDyntree visualizer).
    %
    %                              REQUIRED FIELDS: (if showVisualizer = true)
    %
    %                              - jointPos: [ndof x nOfInterations] [double];
    %                              - w_H_b: [16 x nOfInterations] [double];;
    %                              - time: [1 x nOfInterations] [non-neg double];;
    %                              - fixedTimeStep: [non-neg double];;
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % generate the visualization list
    visualizationList = {};
    cont = 1;
    
    if Simulator.showSimulationResults

        % pre-process the visualization list by ignoring all the empty
        % and/or non-double or non-boolean variables
        DataForVisualization = load(['./data/',Visualization.dataFileName,'.mat']);
        
        for k = 1:length(Visualization.vizVariableList)
            
            if ~isempty(DataForVisualization.(Visualization.vizVariableList{k})) && isfloat(DataForVisualization.(Visualization.vizVariableList{k}))
        
                visualizationList{cont} = Visualization.vizVariableList{k}; %#ok<AGROW>
                cont = cont +1;
            else
                disp(['[openVisualizationMenu]: ignoring variable ',Visualization.vizVariableList{k}])
            end
        end
    end
    
    if Simulator.showVisualizer
        
        visualizationList{end+1} = 'iDyntree visualizer';
    end
    
    % keep the menu open until the user explicitly asks for quitting it
    stayInLoop = true;
    
    while stayInLoop
    
        [plotDataList, ~] = listdlg('PromptString', 'SIMULATION RESULTS', ...
                                    'ListString', visualizationList, ...
                                    'SelectionMode', 'multiple', ...
                                    'ListSize', [250 150]);                                 
        if isempty(plotDataList)
       
            % nothing is selected
            stayInLoop = false;
        else
        
            % the iDyntree visualizer is shown first.
            if strcmp(visualizationList{plotDataList(end)},'iDyntree visualizer')
            
                % keep the interface of the visualization function clear
                jointPos      = SimulationOutput.jointPos;
                w_H_b         = SimulationOutput.w_H_b;
                time          = SimulationOutput.time;
                fixedTimeStep = SimulationOutput.fixedTimeStep;
                
                % create a video of the simulation
                if Simulator.activateVideoOption
                    
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
                            Simulator.activateVideoOption = false;
                    end
                else
                    createVideo = false;
                end
                runVisualizer(jointPos,w_H_b,time,fixedTimeStep,createVideo,KinDynModel,iDyntreeVisualizer,Simulator)             
            end
            
            if Simulator.showSimulationResults
                  
                dataNameList = {};
                
                for k = 1:length(plotDataList)

                    if ~strcmp(visualizationList{plotDataList(k)},'iDyntree visualizer')
                    
                        dataNameList{k} = visualizationList{plotDataList(k)}; %#ok<AGROW>
                    end
                end
                
                if ~isempty(dataNameList)
                    
                    % plot the other results
                    plotSimulationData(dataNameList,DataForVisualization,Visualization,Simulator);
                end
            end
        end
    end
end
