function [] = plotSimulationData(dataNameList,DataForVisualization,Visualization,Simulator)                

    % PLOTSIMULATIONDATA plots the simulation results.
    %
    % FORMAT:  [] = plotSimulationData(dataNameList,DataForVisualization,Visualization,Simulator)
    %
    % INPUTS:  - dataNameList: [nData x 1]; cell array containing strings
    %                          representing the names of some fields inside
    %                          the "DataForVisualization" structure;
    %          - DataForVisualization: string containing the data to plot;
    %          - Visualization: plots-specific configuration parameters;
    %
    %                           REQUIRED FIELDS: (if showSimulationResults = true)
    %
    %                           - activateAxisOption: [bool]; 
    %                           - defaultXAxisVariableName: [string];
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - savePictures: [bool];
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % clear from previous plots
    close all
    
    disp('[plotSimulationData]: plotting data...')
    
    xAxisVarListIndex = [];
    useSpecifiedXAxis = false;
    
    % open a GUI for selecting the x-axis in the plot
    if Visualization.activateAxisOption
        
        [xAxisVarListIndex, ~] = listdlg('PromptString','Choose the x-axis variable (2D plots only):', ...
                                         'ListString',dataNameList, ...
                                         'SelectionMode','single', ...
                                         'ListSize',[250 150]);
    else
        % locate if "defaultXAxisVariableName" is inside the dataNameList
        for k = 1:length(dataNameList)
           
            if strcmp(Visualization.defaultXAxisVariableName,dataNameList{k})
                
                xAxisVarListIndex = k;
            end
        end
    end
    
    % check if the x-axis variable is valid or not
    if isempty(xAxisVarListIndex)
        
        warning('[plotSimulationData]: x-axis not specified or not correct. Ignoring it.'); 
        % final x-axis variable name
        xAxisVariableName = {''};
    else 
        % check it the x-axis is actually a field of "DataForVisualization"
        if ~isfield(DataForVisualization,{dataNameList{xAxisVarListIndex}})
        
            warning('[plotSimulationData]: specified x-axis variable not found. Ignoring it.'); 
        else
            xAxisData = DataForVisualization.(dataNameList{xAxisVarListIndex});
            
            % check it the x-axis is a vector of double
            if isfloat(xAxisData) && ismatrix(xAxisData)
                
                if size(xAxisData,1) == 1 || size(xAxisData,2) == 1
                    
                    disp(['[plotSimulationData]: choosing ', dataNameList{xAxisVarListIndex},' as x-axis.']);
                    useSpecifiedXAxis = true;
                else
                    warning('[plotSimulationData]: specified x-axis is not a vector. Ignoring it.'); 
                end
            else
                warning('[plotSimulationData]: specified x-axis is not of type [double]. Ignoring it.');
            end
        end 
        % final x-axis variable name
        xAxisVariableName = dataNameList{xAxisVarListIndex};
    end   
    
    % check on the data: to use the specified x-axis, the data on the y-axis
    % can be either a vector or a matrix, with the same dimension of the
    % x-axis. Otherwise, it will be plot (if possible) without x-axis
    for k = 1:length(dataNameList)
        
        if ~isfield(DataForVisualization,{dataNameList{k}})
            
            disp(['[plotSimulationData]: ignoring ', dataNameList{k},' (not found).']);
        
        else   
            if ~strcmp(xAxisVariableName,dataNameList{k})
            
                yAxisData = DataForVisualization.(dataNameList{k});

                % check it the y-axis is a vector of double with the same size
                % of the x-axis
                if isfloat(yAxisData) && ismatrix(yAxisData)
                
                    if useSpecifiedXAxis
                    
                        if size(yAxisData,1) == max(size(xAxisData)) || size(yAxisData,2) == max(size(xAxisData))
                    
                            % TODO
                            disp('PLOTTING WITH X-AXIS!')
                            figure
                        else
                            % TODO
                            disp(['[plotSimulationData]: size mismatch. Plotting ', dataNameList{k},' without x-axis.']);
                            disp('PLOTTING WITHOUT X-AXIS!')
                            figure
                        end
                    else
                         % TODO
                         disp('PLOTTING WITHOUT X-AXIS!')
                         figure
                    end   
                
                elseif isfloat(yAxisData) && ~ismatrix(yAxisData)
                
                    % this is a 3D tensor of double. It requires a special 3D
                    % plot and the specifies x-axis is ignored
                    disp('3D PLOTTING WITHOUT X-AXIS!')
                    figure
                else
                    warning('[plotSimulationData]: specified y-axis is not of type [double]. Ignoring it.');
                end
            else
                disp('[plotSimulationData]: ignoring plots where x_axis = y_axis.')
            end
        end
    end            
    disp('[plotSimulationData]: done.')
end