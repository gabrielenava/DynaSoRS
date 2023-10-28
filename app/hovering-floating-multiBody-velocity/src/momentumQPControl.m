function [jointVelStar, TDotStar] = momentumQPControl(posCoM, jointPos, w_R_b, baseVel, T, J_jets, J_CoM, ...
                                                      matrixOfJetsAxes, matrixOfJetsArms, M, CMM, Config)

% references and gains
pos_vel_acc_jerk_CoM_des  = [Config.References.posCoM_init, zeros(3,3)];
rot_vel_acc_jerk_base_des = [Config.References.w_R_b_init, zeros(3,3)];
jointPos_des              = Config.References.jointPos_init;

KP_momentum = Config.Gains.KP_momentum;
KD_momentum = Config.Gains.KD_momentum;
KO_momentum = Config.Gains.KO_momentum;
KP_postural = Config.Gains.KP_postural;

% momentum-based controller for hovering
[HessianMatrix, gradient, lowerBound, upperBound] = flightControlMomentum(posCoM, jointPos, baseVel, T, J_jets, J_CoM, w_R_b, ...
                                                                          matrixOfJetsAxes, matrixOfJetsArms, M, CMM, pos_vel_acc_jerk_CoM_des, rot_vel_acc_jerk_base_des, ....
                                                                          jointPos_des, KP_momentum, KD_momentum, KO_momentum, KP_postural, Config);
% call to the QP solver (quadprog)
options = optimoptions('quadprog','Display','off');
uStar   = quadprog(HessianMatrix, gradient, [], [], [], [], lowerBound, upperBound, [], options);

TDotStar     = uStar(1:4);
jointVelStar = uStar(5:end);

end
