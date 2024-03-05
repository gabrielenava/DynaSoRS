classdef Visualizer < handle
    % VISUALIZER wraps the iDynTree/MATLAB-based robot visualization.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Feb. 2024
    %
    properties
        time;
        w_H_b;
        viz_opt;
        jointPos;
        robotFig;
        KinDynModel;
        basePoseAsTimeseries;
        jointPosAsTimeseries;
    end

    methods
        function obj = Visualizer(w_H_b, jointPos, time, KinDynModel, varargin)

            % two acceptable sizes for w_H_b and jointPos: either 4x4
            % matrix and nx1 vector, or 4x4xlength(time) matrix and/or nxlength(time) vector
            [basePoseAsTimeseries, jointPosAsTimeseries] = checkInput(obj, w_H_b, jointPos, time);

            if basePoseAsTimeseries

                w_H_b_init = w_H_b(:,:,1);
            else
                w_H_b_init = w_H_b;
            end
            if jointPosAsTimeseries

                jointPos_init = jointPos(:,1);
            else
                jointPos_init = jointPos;
            end

            obj.basePoseAsTimeseries = basePoseAsTimeseries;
            obj.jointPosAsTimeseries = jointPosAsTimeseries;
            obj.KinDynModel     = KinDynModel;
            obj.time            = time;
            obj.w_H_b           = w_H_b;
            obj.jointPos        = jointPos;

            % initialize visualizer options, then update fields if the user
            % specify them as input
            viz_opt.gravityVector = [0; 0; -9.81];
            viz_opt.meshesPath    = '';
            viz_opt.color = [0.9,0.9,0.9];
            viz_opt.material = 'metal';
            viz_opt.transparency = 0.7;
            viz_opt.debug = false;
            viz_opt.view = [-92.9356 22.4635];
            viz_opt.groundOn = true;
            viz_opt.groundColor = [0.5 0.5 0.5];
            viz_opt.groundTransparency = 0.5;

            switch nargin

                case 5
                    % the user specified visualization options
                    viz_opt_input = varargin{1};
                    viz_opt = updateStructFields(obj, viz_opt, viz_opt_input);
            end

            obj.viz_opt = viz_opt;

            % initialize the visualizer
            iDynTreeWrappers.setRobotState(obj.KinDynModel, w_H_b_init, jointPos_init, zeros(6,1), ...
                zeros(length(jointPos(:,1)),1), obj.viz_opt.gravityVector);

            obj.robotFig = iDynTreeWrappers.prepareVisualization(obj.KinDynModel, obj.viz_opt.meshesPath, 'color', ...
                obj.viz_opt.color, 'material', obj.viz_opt.material, 'transparency', obj.viz_opt.transparency, 'debug', ...
                obj.viz_opt.debug, 'view', obj.viz_opt.view, 'groundOn', obj.viz_opt.groundOn, 'groundColor', ...
                obj.viz_opt.groundColor, 'groundTransparency', obj.viz_opt.groundTransparency);
        end

        function [] = update(obj, w_H_b, jointPos)

            % update iDynTree first
            iDynTreeWrappers.setRobotState(obj.KinDynModel, w_H_b, jointPos, zeros(6,1), ...
                zeros(length(jointPos(:,1)),1), obj.viz_opt.gravityVector);

            iDynTreeWrappers.updateVisualization(obj.KinDynModel, obj.robotFig);
        end

        function [] = run(obj)

            t = obj.time;

            for k = 1:length(t)

                % call the figure update at each time step
                if obj.basePoseAsTimeseries

                    w_H_b_k = obj.w_H_b(:,:,k);
                else
                    w_H_b_k = obj.w_H_b;
                end
                if obj.jointPosAsTimeseries

                    jointPos_k = obj.jointPos(:,k);
                else
                    jointPos_k = obj.jointPos;
                end

                update(obj, w_H_b_k, jointPos_k);
                drawnow;
            end
        end

        function [] = close(obj)

            close(obj.robotFig.mainHandler)
        end
    end

    methods(Access = private)

        function [basePoseAsTimeseries, jointPosAsTimeseries] = checkInput(~, w_H_b, jointPos, time)

            % check if either w_H_b or jointPos is a time series
            basePoseAsTimeseries = false;
            jointPosAsTimeseries = false;

            dim_w_H_b    = size(w_H_b);
            dim_time     = length(time);
            dim_jointPos = size(jointPos);

            if length(dim_w_H_b) == 3

                if dim_w_H_b(3) == dim_time
                    basePoseAsTimeseries = true;
                else
                    error('Dimension 3 of w_H_b does not correspond to length(time).')
                end
            end
            if dim_jointPos(2) > 1

                if dim_jointPos(2) == dim_time
                    jointPosAsTimeseries = true;
                else
                    error('Dimension 2 of jointPos does not correspond to length(time).')
                end
            end
        end

        function viz_opt = updateStructFields(~, viz_opt, viz_opt_input)

            % update fields of the visualization options struct
            input_fields = fieldnames(viz_opt_input);
            default_fields = fieldnames(viz_opt);

            for k = 1:length(input_fields)

                for j = 1:length(default_fields)

                    if strcmpi(input_fields{k}, default_fields{j})

                        viz_opt.(default_fields{j}) = viz_opt_input.(input_fields{k});
                    end
                end
            end
        end
    end
end
