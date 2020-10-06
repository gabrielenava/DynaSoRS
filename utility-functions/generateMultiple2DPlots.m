function FigureData = generateMultiple2DPlots(xAxis,yAxis,numOfFigures,numOfSubFigures,subFiguresPatternSinglePlot, ...
                                              legendList,OldFigureData,SettingsMultiplePlot,mode)

    % GENERATEMULTIPLE2DPLOTS creates a multiple 2D plot according to the
    %                         user-defined settings.
    %
    % FORMAT:  FigureData = generateMultiple2DPlots(xAxis,yAxis,numOfFigures,numOfSubFigures,subFiguresPatternSinglePlot, ...
    %                                               legendList,OldFigureData,SettingsMultiplePlot,mode)
    %
    % INPUTS:  - xAxis: [1 x nIterations] or [nIterations x 1] vector of data 
    %                   to use as y-axis;
    %          - yAxis: [nData x nIterations] matrix of data to use as y-axis;
    %          - numOfFigures: total number of figures to use;
    %          - numOfSubFigures: total number of subfigures inside each figure;
    %          - subFiguresPatternSinglePlot: [n x p] matrix representing the
    %                                         sub-figures pattern for each plot.
    %          - legendList: {nData x 1} cell array of strings containing the 
    %                        legend label for each data;
    %          - OldFigureData: structure containing the configuration of a
    %                           previous run of generateMultiple2DPlots;
    %          - SettingsMultiplePlot: structure containing user-defined plots
    %                                  settings, or cell array of structures 
    %                                  each one containing the user-defined settings
    %                                  for each data. The fields are not compulsory.
    %
    %                      FIELDS OVERVIEW:
    %
    %                      -lineWidth         = [int];
    %                      -fontSize_axis     = [int];
    %                      -fontSize_leg      = [int];
    %                      -xLabel            = {string};
    %                      -yLabel            = {string};
    %                      -figTitle          = {string};
    %                      -legendList        = IGNORED;
    %                      -yLimits           = [int, int];
    %                      -xLimits           = [int, int];
    %                      -yTicksVector      = [nTicks x 1];
    %                      -xTicksVector      = [nTicks x 1];
    %                      -removeLegendBox   = [bool];
    %                      -legendOrientation = [string];
    %
    %          - mode: either "newplot" to create a new set of figures for
    %                  plotting the data, "replot" to plot the new data on
    %                  previously created pictures.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % check on the SettingsMultiplePlot structure
    if ~isstruct(SettingsMultiplePlot) && length(SettingsMultiplePlot) < (numOfFigures*numOfSubFigures)

        error('[generateMultiple2DPlots]: SettingsMultiplePlot must be either a single struct or an array of struct of length (numOfFigures*numOfSubFigures).')
    end
    
    % check on the xAxis
    if min(size(xAxis)) > 1

        error('[generateMultiple2DPlots]: xAxis is not a vector.')
    end
    
    % check on the legendList
    if ~isempty(legendList) && length(legendList) < (numOfFigures*numOfSubFigures)

        error('[generateMultiple2DPlots]: legendList must be either a empty or of length (numOfFigures*numOfSubFigures).')
    end
        
    % check on the numOfFigures, numOfSubFigures
    if (numOfFigures*numOfSubFigures) < size(yAxis,1)
        
        error('[generateMultiple2DPlots]: total number of figures and subfigures is lower than the number of data to plot.')
    end

    switch mode
        
        case 'newplot'
        
            counter = 1;
            
            for k = 1:numOfFigures
            
                if counter <= size(yAxis,1)
                
                    FigureStruct = figure('units','normalized','outerposition',[0 0 1 1]);
            
                    % decide the number of subfigures for each figure
                    iterations = 1:min(numOfSubFigures,(size(yAxis,1)-counter+1));

                    % iterate on the subfigures
                    for i = iterations
                
                        % if SettingsMultiplePlot is a structure, then use 
                        % these settings for all the plots.
                        if isstruct(SettingsMultiplePlot)
        
                            SettingsSinglePlot = SettingsMultiplePlot;
                        else
                            SettingsSinglePlot = SettingsMultiplePlot{i};
                        end
                        
                        % check on the legend settings
                        if ~isfield(SettingsSinglePlot,{'legendOrientation'})
        
                            legendOrientation = 'Vertical';
                        else
                            legendOrientation = SettingsSinglePlot.legendOrientation;
                        end
                        if ~isfield(SettingsSinglePlot,{'removeLegendBox'})
        
                            removeLegendBox = false;
                        else
                            removeLegendBox = SettingsSinglePlot.removeLegendBox;
                        end
                        
                        % deactivate the legendlist
                        SettingsSinglePlot.legendList = {};
                        
                        mbs.generateSingle2DPlot(xAxis,yAxis(counter,:),SettingsSinglePlot,FigureStruct.Number,i,subFiguresPatternSinglePlot);
                                                
                        % use the legendList here
                        if ~isempty(legendList)
                            
                            leg = legend(legendList{counter},'Location','best');
            
                            % default settings for the legend.
                            set(leg,'Interpreter','latex', ...
                                'Orientation',legendOrientation);
                
                            if removeLegendBox
                
                                legend boxoff;
                            end
                        end                 
                        counter = counter + 1;
                    end
                    
                    % add the figures numbers to the FigureData structure
                    FigureData.figureNumbersList(k) = FigureStruct.Number;
                    FigureData.FigureStructList{k}  = FigureStruct;
                end
            end

        case 'replot'
    
            % to perform a replot, OldFigureData values are used instead of
            % the normal inputs, BUT the legendList and the
            % SettingsMultiplePlot that can be different
            if isempty(OldFigureData)
                
                error('[generateMultiple2DPlots]: to perform a replot OldFigureData cannot be empty.')
            end   
            
            numOfFigures                = OldFigureData.numOfFigures;
            numOfSubFigures             = OldFigureData.numOfSubFigures;
            subFiguresPatternSinglePlot = OldFigureData.subFiguresPatternSinglePlot;
            figureNumbersList           = OldFigureData.figureNumbersList;
            oldLegendList               = OldFigureData.legendList;
            FigureData.FigureStructList = OldFigureData.FigureStructList;
            
            % update the legendlist such that each element now contains
            % also the oldLegendList
            if isempty(legendList)
                
                legendList = oldLegendList;
            else
                newLegendList = legendList;
                
                for k = 1:length(oldLegendList)
                    
                    legendList{k} = {oldLegendList{k},newLegendList{k}};
                end
            end
            
            counter = 1;
            
            for k = 1:numOfFigures
            
                if counter <= size(yAxis,1)
                
                    figure(figureNumbersList(k));
            
                    % decide the number of subfigures for each figure
                    iterations = 1:min(numOfSubFigures,(size(yAxis,1)-counter+1));

                    % iterate on the subfigures
                    for i = iterations
                
                        % if SettingsMultiplePlot is a structure, then use 
                        % these settings for all the plots.
                        if isstruct(SettingsMultiplePlot)
        
                            SettingsSinglePlot = SettingsMultiplePlot;
                        else
                            SettingsSinglePlot = SettingsMultiplePlot{i};
                        end
                        
                        % check on the legend settings
                        if ~isfield(SettingsSinglePlot,{'legendOrientation'})
        
                            legendOrientation = 'Vertical';
                        else
                            legendOrientation = SettingsSinglePlot.legendOrientation;
                        end
                        if ~isfield(SettingsSinglePlot,{'removeLegendBox'})
        
                            removeLegendBox = false;
                        else
                            removeLegendBox = SettingsSinglePlot.removeLegendBox;
                        end
 
                        % deactivate the legendlist
                        SettingsSinglePlot.legendList = {};
                                           
                        mbs.generateSingle2DPlot(xAxis,yAxis(counter,:),SettingsSinglePlot,figureNumbersList(k),i,subFiguresPatternSinglePlot);
                        
                        % use the legendList here
                        if ~isempty(legendList)
                            
                            leg = legend(legendList{counter},'Location','best');
            
                            % default settings for the legend.
                            set(leg,'Interpreter','latex', ...
                                'Orientation',legendOrientation);
                
                            if removeLegendBox
                
                                legend boxoff;
                            end
                        end
                        counter = counter + 1;
                    end
                    
                    % add the figures numbers to the FigureData structure
                    FigureData.figureNumbersList(k) = figureNumbersList(k);    
                end
            end
            
        otherwise           
            error('[generateMultiple2DPlots]: mode variable must be either "newplot" or "replot".')          
    end  
    
    % FigureData contains all the settings of the current figures, plus the
    % figures numbers. It is necessary in case of replot on the same figure
    FigureData.numOfFigures                = numOfFigures;
    FigureData.numOfSubFigures             = numOfSubFigures;
    FigureData.subFiguresPatternSinglePlot = subFiguresPatternSinglePlot;
    FigureData.legendList                  = legendList;
end
