classdef Visualizer

    % VISUALIZER wraps the iDynTree/MATLAB-based robot visualization.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties
        time;
        w_H_b;
        jointPos;
        robotFig;
        KinDynModel;
        isMatrix_base;
        isVector_joints;
    end

    methods
        function obj = Visualizer(w_H_b, jointPos, time, KinDynModel, meshesPath, varargin)

            % Construct an instance of this class

            % two acceptable sizes for w_H_b and jointPos: either 4x4
            % matrix and nx1 vector, or 4x4xsteps matrix and nxsteps vector
            [isMatrix_base, isVector_joints] = checkInput(obj, w_H_b, jointPos);

            if isMatrix_base

                w_H_b_init = w_H_b;
            else
                w_H_b_init = w_H_b(:,:,1);
            end
            if isVector_joints

                jointPos_init = jointPos;
            else
                jointPos_init = jointPos(:,1);
            end

            obj.isMatrix_base   = isMatrix_base;
            obj.isVector_joints = isVector_joints;
            obj.KinDynModel     = KinDynModel;
            obj.time            = time;
            obj.w_H_b           = w_H_b;
            obj.jointPos        = jointPos;

            % initialize the visualizer
            iDynTreeWrappers.setRobotState(obj.KinDynModel, w_H_b_init, jointPos_init, zeros(6,1), ...
                zeros(length(jointPos(:,1)),1), [0;0;-9.81]);

            switch nargin

                case 6
                    % the user specified visualization options
                    viz_opt      = varargin{1};
                    obj.robotFig = iDynTreeWrappers.prepareVisualization(obj.KinDynModel, meshesPath, 'color', ...
                        viz_opt.color, 'material', viz_opt.material, 'transparency', viz_opt.transparency, 'debug', ...
                        viz_opt.debug, 'view', viz_opt.view, 'groundOn', viz_opt.groundOn, 'groundColor', ...
                        viz_opt.groundColor, 'groundTransparency', viz_opt.groundTransparency);
                otherwise
                    % no visualization options specified
                    obj.robotFig = iDynTreeWrappers.prepareVisualization(obj.KinDynModel, meshesPath);
            end
        end

        function [] = update(obj, w_H_b, jointPos)

            % update iDynTree first
            iDynTreeWrappers.setRobotState(obj.KinDynModel, w_H_b, jointPos, zeros(6,1), ...
                zeros(length(jointPos(:,1)),1), [0;0;-9.81]);

            iDynTreeWrappers.updateVisualization(obj.KinDynModel, obj.robotFig);
        end

        function [] = run(obj)

            t = obj.time;

            for k = 1:length(t)

                w_H_b_k    = obj.w_H_b(:,:,k);
                jointPos_k = obj.jointPos(:,k);

                update(obj, w_H_b_k, jointPos_k);
                drawnow;
            end
        end
    end

    methods(Access = private)

        function [isMatrix_base, isVector_joints] = checkInput(~, w_H_b, jointPos)

            isMatrix_base   = true;
            isVector_joints = true;

            if length(size(w_H_b)) == 3

                isMatrix_base = false;
            end
            if length(size(jointPos)) == 2

                isVector_joints = false;
            end
        end
    end
end
