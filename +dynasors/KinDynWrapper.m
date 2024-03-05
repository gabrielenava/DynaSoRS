classdef KinDynWrapper < handle
    % KINDYNWRAPPER wraps the iDynTree MATLAB bindings to compute advanced
    %               dynamic and kinematic quantities for control. Is acts
    %               similarly (and makes use of) the iDynTree high-level
    %               wrappers, but it computes more complex control-related
    %               quantities not avaialable with the wrappers only.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties

    end

    methods
        function obj = KinDynWrapper()

        end

        function J_G = getCentroidalTotalMomentumJacobian(~, KinDynModel)

            % GETCENTROIDALTOTALMOMENTUMJACOBIAN gets the centroidal momentum jacobian,
            %                                    i.e. the matrix that maps the state
            %                                    velocity to the centroidal momentum.

            % create the matrix that must be populated with the jacobian map
            J_G_iDyntree = iDynTree.MatrixDynSize(6, KinDynModel.NDOF+6);

            % get the cmm jacobian
            ack =  KinDynModel.kinDynComp.getCentroidalTotalMomentumJacobian(J_G_iDyntree);

            % check for errors
            if ~ack
                error('[getCentroidalTotalMomentumJacobian]: unable to get the Jacobian from the reduced model.')
            end

            % covert to Matlab format
            J_G = J_G_iDyntree.toMatlab;
        end
    end
end
