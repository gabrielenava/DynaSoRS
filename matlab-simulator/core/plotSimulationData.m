function [] = plotSimulationData(dataNameList,figureSettingsList,DataForVisualization,Visualization,Simulator)                

    % PLOTSIMULATIONDATA plots the simulation results.
    %
    % FORMAT:  [] = plotSimulationData(dataNameList,DataForVisualization,Visualization,Simulator)
    %
    % INPUTS:  - dataNameList: [nData x 1]; cell array containing strings
    %                          representing the names of some fields inside
    %                          the "DataForVisualization" structure;
    %          - figureSettingsList: [nData x 1] array of struct. Each struct
    %                                defines the settings for the i-th data to plot;
    %          - DataForVisualization: string containing the data to plot;
    %          - Visualization: plots-specific configuration parameters;
    %
    %                           REQUIRED FIELDS: (if showSimulationResults = true)
    %
    %                           - activateXAxisMenu: [bool]; 
    %                           - defaultXAxisVariableName: [string];
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - savePictures: [bool];
    %                       - savedDataTag: [string];
    %                       - modelFolderName: [string];
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    disp('[plotSimulationData]: plotting data...')
    
    xAxisVarListIndex = [];
    xAxisDataNameList = {};
    cont              = 1;
    
    % pre-checks to process the xAxisDataNameList. 
    for k = 1:length(dataNameList)
        
        if isfield(DataForVisualization,{dataNameList{k}}) && min(size(DataForVisualization.(dataNameList{k}))) == 1
            
            % names of the variables that can be used as x-axis
            xAxisDataNameList{cont} = dataNameList{k}; %#ok<AGROW>
            cont = cont + 1;
        end
    end
    
    % open a GUI for selecting the x-axis in the plot
    if Visualization.activateXAxisMenu && ~isempty(xAxisDataNameList)
        
        [xAxisVarListIndex, ~] = listdlg('PromptString', 'Choose the x-axis variable (2D plots):', ...
                                         'ListString', xAxisDataNameList, ...
                                         'SelectionMode', 'single', ...
                                         'ListSize', [250 150]);
    else
        % locate if "defaultXAxisVariableName" is inside the xAxisDataNameList
        for k = 1:length(xAxisDataNameList)
           
            if strcmp(Visualization.defaultXAxisVariableName,xAxisDataNameList{k})
                
                xAxisVarListIndex = k;
            end
        end
    end
    
    % check if the x-axis variable is valid or not
    if isempty(xAxisVarListIndex)
        
        disp('[plotSimulationData]: x-axis not specified or not valid. Ignoring it.'); 
        
        % empty x-axis
        xAxisVariableName = {''};
        xAxisData         = [];
    else 
        % final x-axis variable name and data
        xAxisVariableName = xAxisDataNameList{xAxisVarListIndex};
        xAxisData         = DataForVisualization.(xAxisDataNameList{xAxisVarListIndex});
            
        % check it the x-axis is a vector of double
        if isfloat(xAxisData) && ismatrix(xAxisData)
                 
            disp(['[plotSimulationData]: choosing ', xAxisDataNameList{xAxisVarListIndex},' as x-axis.']);
        else
            warning('[plotSimulationData]: specified x-axis is not of type [double]. Ignoring it.');
            
            % empty x-axis
            xAxisData = [];
        end
    end   
    
    % check on the data: to use the specified x-axis, the data on the y-axis
    % can be either a vector or a matrix, with the same dimension of the
    % x-axis. Otherwise, it will be plot (if possible) without x-axis
    OldFigureData = [];
                        
    for k = 1:length(dataNameList)
        
        if ~isfield(DataForVisualization,{dataNameList{k}})
            
            disp(['[plotSimulationData]: ignoring ', dataNameList{k},' (not found).']);
        
        else         
            % current figure settings
            CurrentFigureSettings = figureSettingsList{k};
        
            if ~strcmp(xAxisVariableName,dataNameList{k})
             
                yAxisData = DataForVisualization.(dataNameList{k});

                % check if the y-axis is a matrix of double
                if isfloat(yAxisData) && ismatrix(yAxisData)
                
                    % all the y-axis data will be plot in a single figure
                    if strcmp(CurrentFigureSettings.Mode, 'singlePlot')
                        
                        % single plot mode here is used to just plot all
                        % data on one figure with one single subplot
                        currentSubFigure          = 1;
                        totalSubFiguresSinglePlot = [1,1];
                        
                        CurrentFig = generateSingle2DPlot(xAxisData,yAxisData,CurrentFigureSettings.Settings,[], ...
                                                          currentSubFigure,totalSubFiguresSinglePlot);
                        
                    % the y-axis data will be plot in multiple figures
                    % and/or subfigures, and eventually re-plotted over
                    % already existing figures
                    elseif strcmp(CurrentFigureSettings.Mode, 'multiplePlot')
                        
                        FigureData = generateMultiple2DPlots(xAxisData,yAxisData,CurrentFigureSettings.numOfFigures,CurrentFigureSettings.numOfSubFigures, ...
                                                             CurrentFigureSettings.totalSubFiguresSinglePlot,CurrentFigureSettings.legendList, ...
                                                             OldFigureData, CurrentFigureSettings.Settings,CurrentFigureSettings.modeMultiplePlot);              
                        % list of current figures 
                        CurrentFig    = FigureData.FigureStructList;
                        OldFigureData = FigureData;           
                    else
                        error('[plotSimulationData]: Mode variable can be either "singlePlot" or "multiplePlot".');
                    end
                                
                    % dock pictures option
                    dockPicture = true;
                    
                    % save pictures inside the "pics" folder
                    if Simulator.savePictures
                        
                        if ~exist('PICS','dir')
                            
                            mkdir('PICS');
                        end
                        
                        if iscell(CurrentFig)
                        
                            for jj = 1:length(CurrentFig)
                                
                                savefig(CurrentFig{jj},['./PICS/fig',num2str(CurrentFig{jj}.Number)]);
                            end
                        else
                            savefig(CurrentFig,['./PICS/fig',num2str(CurrentFig.Number)]);
                        end
                        
                        % avoid docking pictures if the 'replot' option is 
                        % activated for the k+1 set of pictures (the saved
                        % picture will be ugly)
                        if k < length(dataNameList) && strcmp(figureSettingsList{k+1}.Mode, 'multiplePlot')
                            
                            if strcmp(figureSettingsList{k+1}.modeMultiplePlot, 'replot')
                                
                                dockPicture = false;
                            end
                        end
                    end
                    
                    % dock pictures    
                    if iscell(CurrentFig)
                        
                        if dockPicture
                            for jj = 1:length(CurrentFig)
                        
                                set(CurrentFig{jj},'WindowStyle','docked')
                            end
                        end
                    else
                        set(CurrentFig,'WindowStyle','docked')
                    end               
                else
                    warning('[plotSimulationData]: specified y-axis is not of type [double]. Ignoring it.');
                end
            else
                disp('[plotSimulationData]: ignoring plots where x_axis = y_axis.')
            end
        end
    end  
    % zip the pictures and remove the ones in the 'PICS' folder
    if Simulator.savePictures
        
        zip(['./PICS/',Simulator.modelFolderName,'_',Simulator.savedDataTag],'./PICS/*.fig');
        command   = strcat('rm -Rf ./PICS/*.fig'); 
        [~, ~]    = system(command);
        disp(['[plotSimulationData]: pictures saved in ','./PICS/',Simulator.modelFolderName,'_',Simulator.savedDataTag,'.zip'])
    end
    disp('[plotSimulationData]: done.')
end