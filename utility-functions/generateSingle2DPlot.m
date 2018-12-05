function FigureStruct = generateSingle2DPlot(xAxis,yAxis,Settings,figureNumber,currentSubFigure,totalSubFigures)

    % GENERATESINGLE2DPLOT creates a single 2D plot according to the 
    %                      user-defined settings.
    %
    % FORMAT:  FigureStruct = generateSingle2DPlot(xAxis,yAxis,Settings,figureNumber,currentSubFigure,totalSubFigures)
    %
    % INPUTS:  - xAxis: [1 x nIterations] or [nIterations x 1] vector of data 
    %                   to use as y-axis;
    %          - yAxis: [nData x nIterations] matrix of data to use as y-axis;
    %          - Settings: structure containing user-defined settings. None
    %                      of them is compulsory.
    %
    %                      FIELDS OVERVIEW:
    %
    %                      -lineWidth         = [int];
    %                      -fontSize_axis     = [int];
    %                      -fontSize_leg      = [int];
    %                      -xLabel            = {string};
    %                      -yLabel            = {string};
    %                      -figTitle          = {string};
    %                      -legendList        = {nData x 1} {cell string};
    %                      -yLimits           = [int, int];
    %                      -xLimits           = [int, int];
    %                      -yTicksVector      = [nTicks x 1];
    %                      -xTicksVector      = [nTicks x 1];
    %                      -removeLegendBox   = [bool];
    %                      -legendOrientation = [string];
    %
    %          - figureNumber: [int] current figure number;
    %          - currentSubFigure: [int] current sub-figure number;
    %          - totalSubFigure: [n x p] matrix representing the
    %                            sub-figures pattern.
    %
    % OUTPUTS: - FigureStruct: structure containing the current figure info.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    % check if all the required fields of the Settings structure exist. If 
    % not, use default values
    if ~isfield(Settings,{'lineWidth'})
        
        lineWidth = 1.5;
    else
        lineWidth = Settings.lineWidth;
    end
    if ~isfield(Settings,{'fontSize_axis'})
        
        fontSize_axis = 18;
    else
        fontSize_axis = Settings.fontSize_axis;
    end
    if ~isfield(Settings,{'fontSize_leg'})
        
        fontSize_leg = 18;
    else
        fontSize_leg = Settings.fontSize_leg;
    end
    if ~isfield(Settings,{'xLabel'})
        
        xLabel = {};
    else
        xLabel = Settings.xLabel;
    end
    if ~isfield(Settings,{'yLabel'})
        
        yLabel = {};
    else
        yLabel = Settings.yLabel;
    end
    if ~isfield(Settings,{'figTitle'})
        
        figTitle = {};
    else
        figTitle = Settings.figTitle;
    end
    if ~isfield(Settings,{'legendList'})
        
        legendList = {};
    else
        legendList = Settings.legendList;
    end
    if ~isfield(Settings,{'yLimits'})
        
        yLimits = [];
    else
        yLimits = Settings.yLimits;
    end
    if ~isfield(Settings,{'xLimits'})
        
        xLimits = [];
    else
        xLimits = Settings.xLimits;
    end
    if ~isfield(Settings,{'yTicksVector'})
        
        yTicksVector = [];
    else
        yTicksVector= Settings.yTicksVector;
    end
    if ~isfield(Settings,{'xTicksVector'})
        
        xTicksVector = [];
    else
        xTicksVector = Settings.xTicksVector;
    end
    if ~isfield(Settings,{'legendOrientation'})
        
        legendOrientation = 'Vertical';
    else
        legendOrientation = Settings.legendOrientation;
    end
    if ~isfield(Settings,{'removeLegendBox'})
        
        removeLegendBox = false;
    else
        removeLegendBox = Settings.removeLegendBox;
    end

    % check on xAxis
    if min(size(xAxis)) > 1
        
        error('[generateSingle2DPlot]: xAxis is not a vector or scalar.')
    end
    
    % check on the fonts and lineWidth
    if lineWidth <=0 || fontSize_axis <= 0 || fontSize_leg <=0
        
        error('[generateSingle2DPlot]: lineWidth and/or fontSize must be strictly positive.')
    end
    
    % check on titles and axis labels
    if length(figTitle) > 1
        
        error('[generateSingle2DPlot]: figTitle size must be 1 or empty.')
    end
    if length(xLabel) > 1
        
        error('[generateSingle2DPlot]: xLabel size must be 1 or empty.')
    end 
    if length(yLabel) > 1
        
        error('[generateSingle2DPlot]: yLabel size must be 1 or empty.')
    end
    if length(legendList) ~= size(yAxis,1) && ~isempty(legendList)
        
        error('[generateSingle2DPlot]: legendList size must be = size(yAxis,1) or empty.')
    end
    
    % checks on the figure and subFigures numbers
    if ~isempty(figureNumber) 
        
        if figureNumber <=0 || round(figureNumber) ~= figureNumber
        
            error('[generateSingle2DPlot]: figureNumber is not a positive integer.')
        end
    end
    if sum(size(totalSubFigures)) ~= 3 || sum(totalSubFigures <= 0) ~= 0 || sum(totalSubFigures ~= round(totalSubFigures)) ~= 0
        
        error('[generateSingle2DPlot]: invalid totalSubFigures value.')
    end
    if currentSubFigure > (totalSubFigures(1)*totalSubFigures(2))  || round(currentSubFigure) ~= currentSubFigure || currentSubFigure <= 0
        
        error('[generateSingle2DPlot]: invalid currentSubFigure value.')
    end
    
    % checks on the x-y limits 
    if ~isempty(yLimits) && yLimits(1) >= yLimits(2)
        
        error('[generateSingle2DPlot]: invalid yLimits.')
    end
    if ~isempty(xLimits) && xLimits(1) >= xLimits(2)
        
        error('[generateSingle2DPlot]: invalid xLimits.')
    end  
    
    % checks on the legend settings
    if ~strcmpi(legendOrientation,'Horizontal') && ~strcmpi(legendOrientation,'Vertical')
        
        error('[generateSingle2DPlot]: wrong legendOrientation value.')
    end
    if ~islogical(removeLegendBox)
        
        error('[generateSingle2DPlot]: wrong removeLegendBox value.')
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% 2D single plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ismatrix(yAxis)
        
        % check the size of xAxis w.r.t. the size of yAxis. If they are
        % of a different size, ignore the xAxis
        if length(xAxis) ~= size(yAxis,2)
            
            disp('[generateSingle2DPlot]: WARNING: xAxis and yAxis dims are different: ignoring xAxis.')
            xAxis = [];
        end
        
        % in case the figureNumber is not specified, a new figure will be opened
        if ~isempty(figureNumber) 
            
            FigureStruct = figure(figureNumber);
        else
            FigureStruct = figure('units','normalized','outerposition',[0 0 1 1]);
        end
    
        % user-defined currentSubFigure and totalSubFigures. 
        subplot(totalSubFigures(1),totalSubFigures(2),currentSubFigure)   
        hold on
        
        for counter = 1:size(yAxis,1)
            
            if ~isempty(xAxis)
                    
                plot(xAxis,yAxis(counter,:),'lineWidth',lineWidth) 
            else
                plot(yAxis(counter,:),'lineWidth',lineWidth) 
            end 
        end
        
        % user-defined settings
        if ~isempty(legendList)
                        
            leg = legend(legendList,'Location','best');
            
            % default settings for the legend.
            set(leg,'Interpreter','latex', ...
                    'Orientation',legendOrientation);
                
            if removeLegendBox
                
                legend boxoff;
            end
        end           
        if ~isempty(figTitle)
                        
            title(figTitle);
        end    
        if ~isempty(xLabel)
                        
            xlabel(xLabel,'HorizontalAlignment','center',...
                          'FontWeight','bold',...
                          'FontSize',fontSize_axis,...
                          'Interpreter','latex');
        end
        if ~isempty(yLabel)
                        
            ylabel(yLabel,'HorizontalAlignment','center',...
                          'FontWeight','bold',...
                          'FontSize',fontSize_axis,...
                          'Interpreter','latex');
        end
        if ~isempty(yLimits)
            
            ylim(yLimits)
        end
        if ~isempty(xLimits)
            
            xlim(xLimits)
        end
        if ~isempty(yTicksVector)
            
            yticks(yTicksVector)
        end
        if ~isempty(xTicksVector)
            
            xticks(xTicksVector)
        end
        
        set(gca,'fontsize',fontSize_axis);
        grid on  
    end
end