classdef Logger < handle
    % LOGGER logs data when running numerical integration of dynamical
    %        systems.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties
        data
    end

    properties (Access = protected)
        debug
    end

    methods

        function obj = Logger(varargin)

            switch nargin

                case 1
                    obj.debug = varargin{1};
                otherwise
                    obj.debug = false;
            end

            obj.data = struct;
            disp('Logger ready.')
        end

        function [] = addNewData(obj, newData, name)

            % append a new variable to the logger
            if ~isfield(obj.data, name)

                obj.data.(name) = newData;

                if obj.debug
                    disp(['Added a new data field ', name])
                end
            else
                warning('Data field already exists!')
            end
        end

        function [] = updateData(obj, newData, name)

            % update an existing variable
            if isfield(obj.data, name)

                obj.data.(name) = [obj.data.(name), newData];

                if obj.debug
                    disp(['Updated data field ', name])
                end
            else
                error('Data field not found: cannot update data!')
            end
        end

        function [] = removeData(obj, name)

            % remove an existing field
            if isfield(obj.data, name)

                obj.data = rmfield(obj.data, name);

                if obj.debug
                    disp(['Removed data field ', name])
                end
            else
                error('Data field not found: cannot remove data!')
            end
        end

        function [] = logData(obj, data, name)

            % start/continue logging data. Wraps the functionalities of
            % updateData and addNewData together.
            if ~isfield(obj.data, name)

                obj.addNewData(data, name);
            else
                obj.updateData(data, name);
            end
        end

        function figNum = plotData(obj, name, varargin)

            if ~isfield(obj.data, name)

                error('Data field not found: cannot plot data!')
            end

            % the user can specify plot options and/or the figure number
            switch nargin

                case 3
                    % understand if figure number or options
                    if isfloat(varargin{1})

                        plot_options = [];
                        figNum = varargin{1};
                        figure(figNum);
                    else
                        plot_options = varargin{1};
                        fig = figure();
                        figNum = fig.Number;
                    end

                case 4
                    % both figure number and options are specified
                    plot_options = varargin{1};
                    figNum = varargin{2};
                    figure(figNum);

                otherwise
                    % no figure number and options specified or malformed input
                    plot_options = [];
                    fig = figure();
                    figNum = fig.Number;
            end

            % plot collected data
            hold all
            grid on

            dataToPlot = obj.data.(name);

            if obj.debug
                disp(['Plotting data field ', name])
            end

            if isempty(plot_options)

                plot(dataToPlot);
            else
                plot(plot_options.xValue, dataToPlot, 'Linewidth', plot_options.lineSize)

                % customize plot with user-specified options
                xlabel(plot_options.xLabel, 'Fontsize', plot_options.fontSize)
                ylabel(plot_options.yLabel, 'Fontsize', plot_options.fontSize)
                title(plot_options.title, 'Fontsize', plot_options.fontSize)
                leg = legend(plot_options.legend, 'Fontsize', plot_options.fontSize);
                leg.Location = 'best';
            end
        end
    end
end
