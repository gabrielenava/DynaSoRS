classdef KinDynWrapper
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

        function A = getJetsMappingMomentum(~, KinDynModel, posCoM, Config)

            % GETJETSMAPPINGMOMENTUM compute the matrix that maps the jets
            %                        intensities into the centroidal momentum
            %                        dynamics (centroidal coordinates).

            % turbines and joints data
            njets       = Config.turbinesData.njets;
            turbineList = Config.turbinesData.turbineList;
            turbineAxis = Config.turbinesData.turbineAxis;

            % initialize A matrix
            A = zeros(6,njets);

            % iterate on njets to calculate jets quantities
            for i = 1:njets

                % forward kinematics
                w_H_j_i = iDynTreeWrappers.getWorldTransform(KinDynModel, turbineList{i});
                w_R_j_i = w_H_j_i(1:3,1:3);
                w_o_j_i = w_H_j_i(1:3,4);
                r_jet_i = w_o_j_i - posCoM;
                l_jet_i = sign(turbineAxis(i))*w_R_j_i(1:3,abs(turbineAxis(i)));

                % compute i-th column of matrix A
                A(:,i)  = iRonCubLib.skewBar(r_jet_i)*l_jet_i;
            end
        end

        function [b_matrixOfJetsAxes, b_matrixOfJetsArms] = getJetsAxesAndArmsBody(~, KinDynModel, w_H_b, posCoM, Config)

            % GETJETSAXESANDARMSBODY computes the jet axis and arms
            %                        calculated w.r.t. the base frame.

            % CoM position in body coordinates
            b_H_w    = invHomMatrix(w_H_b);
            b_posCoM = b_H_w*[posCoM; 1];
            b_posCoM = b_posCoM(1:3);

            % jets homogeneous matrices (body coordinates)
            b_H_J1   = iDynTreeWrappers.getRelativeTransform(KinDynModel, Config.model.baseLinkName, Config.turbinesData.turbineList{1});
            b_H_J2   = iDynTreeWrappers.getRelativeTransform(KinDynModel, Config.model.baseLinkName, Config.turbinesData.turbineList{2});
            b_H_J3   = iDynTreeWrappers.getRelativeTransform(KinDynModel, Config.model.baseLinkName, Config.turbinesData.turbineList{3});
            b_H_J4   = iDynTreeWrappers.getRelativeTransform(KinDynModel, Config.model.baseLinkName, Config.turbinesData.turbineList{4});

            % Assumption: consider a frame attached to each jet. Then, one of the
            % principal axis (x,y,z) of this frame is parallel to the thrust force.
            % Under the above assumption, the following mapping holds:
            %
            % x axis = +-1;
            % y axis = +-2;
            % z axis = +-3;
            %
            % the sign (positive or negative) identifies the thrust orientation
            % w.r.t. the axis to which the thrust force is parallel.
            %
            orientations       = sign(Config.turbinesData.turbineAxis);
            axes               = abs(Config.turbinesData.turbineAxis);
            b_matrixOfJetsAxes = [orientations(1)*b_H_J1(1:3,axes(1)), orientations(2)*b_H_J2(1:3,axes(2)),...
                orientations(3)*b_H_J3(1:3,axes(3)), orientations(4)*b_H_J4(1:3,axes(4))];

            % Distances between the jets locations and the CoM position
            r_J1               = b_H_J1(1:3,4) - b_posCoM;
            r_J2               = b_H_J2(1:3,4) - b_posCoM;
            r_J3               = b_H_J3(1:3,4) - b_posCoM;
            r_J4               = b_H_J4(1:3,4) - b_posCoM;
            b_matrixOfJetsArms = [r_J1, r_J2, r_J3, r_J4];
        end

        function [b_J_rel, b_J_ang] = getJetsJacobiansBody(~, KinDynModel, w_H_b, Config)

            % GETJETSJACOBIANSBODY computes the jet Jacobians w.r.t. body.

            % compute CoM and jets jacobians
            b_H_w      = invHomMatrix(w_H_b);
            b_R_w      = b_H_w(1:3,1:3);
            J_CoM      = iDynTreeWrappers.getCenterOfMassJacobian(KinDynModel);
            J_J1       = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.turbinesData.turbineList{1});
            J_J2       = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.turbinesData.turbineList{2});
            J_J3       = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.turbinesData.turbineList{3});
            J_J4       = iDynTreeWrappers.getFrameFreeFloatingJacobian(KinDynModel, Config.turbinesData.turbineList{4});

            J_J1_lin   = J_J1(1:3,:);
            J_J2_lin   = J_J2(1:3,:);
            J_J3_lin   = J_J3(1:3,:);
            J_J4_lin   = J_J4(1:3,:);

            J_J1_ang   = J_J1(4:6,:);
            J_J2_ang   = J_J2(4:6,:);
            J_J3_ang   = J_J3(4:6,:);
            J_J4_ang   = J_J4(4:6,:);

            b_J_J1_rel = b_R_w*(J_J1_lin(:,7:end) - J_CoM(:,7:end));
            b_J_J2_rel = b_R_w*(J_J2_lin(:,7:end) - J_CoM(:,7:end));
            b_J_J3_rel = b_R_w*(J_J3_lin(:,7:end) - J_CoM(:,7:end));
            b_J_J4_rel = b_R_w*(J_J4_lin(:,7:end) - J_CoM(:,7:end));

            b_J_J1_ang = b_R_w*J_J1_ang(:,7:end);
            b_J_J2_ang = b_R_w*J_J2_ang(:,7:end);
            b_J_J3_ang = b_R_w*J_J3_ang(:,7:end);
            b_J_J4_ang = b_R_w*J_J4_ang(:,7:end);

            % combine Jacobians
            b_J_rel    = [b_J_J1_rel;
                b_J_J2_rel;
                b_J_J3_rel;
                b_J_J4_rel];

            b_J_ang    = [b_J_J1_ang;
                b_J_J2_ang;
                b_J_J3_ang;
                b_J_J4_ang];
        end

        function J_G = getCentroidalTotalMomentumJacobian(~, KinDynModel)

            % GETCENTROIDALTOTALMOMENTUMJACOBIAN gets the centroidal momentum jacobian,
            %                                    i.e. the matrix that maps the state
            %                                    velocity to the centroidal momentum.

            % get the cmm jacobian
            KinDynModel.kinDynComp.getCentroidalTotalMomentumJacobian(KinDynModel.dynamics.J_G_iDyntree);

            % covert to Matlab format
            J_G = KinDynModel.dynamics.J_G_iDyntree.toMatlab;
        end
    end
end
