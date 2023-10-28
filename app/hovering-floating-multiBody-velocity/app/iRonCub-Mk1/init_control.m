%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %  
%                 PARAMETERS FOR THE FLIGHT CONTROLLER                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% joints limits
torsoJointsLimit = [ 15, 45; -20, 20;  -20, 20];
armsJointsLimit  = [-90, 10;  0,  160; -30, 80;  15, 100];
legsJointsLimit  = [-35, 80;  5,  90;  -70, 70; -35, 0; -30, 30; -20, 20];

Config.sat.jointPositionLimits = [torsoJointsLimit; ...
                                  armsJointsLimit; armsJointsLimit; ...         
                                  legsJointsLimit; legsJointsLimit] * pi/180;
                              
%% ADD THRUSTS AND JOINT POSITION LIMITS IN THE QP
Config.INCLUDE_THRUST_LIMITS = false;
Config.INCLUDE_JOINTS_LIMITS = false;
Config.eps_thrust_limit      = 2;
Config.eps_joint_limit       = 5;

%% CONTROLLER GAINS

% Linear momentum gains 
Config.Gains.momentum.KP_linear  = [15, 15, 15];                             
Config.Gains.momentum.KD_linear  = 2 * sqrt(Config.Gains.momentum.KP_linear);
Config.Gains.KO_momentum         = 10 .* eye(6); 

% Angular momentum gains
Config.Gains.momentum.KP_angular = 40 .* ones(1,3);                            
Config.Gains.momentum.KD_angular = 2 * sqrt(Config.Gains.momentum.KP_angular);

Config.Gains.KP_momentum         = diag([Config.Gains.momentum.KP_linear, Config.Gains.momentum.KP_angular]);
Config.Gains.KD_momentum         = diag([Config.Gains.momentum.KD_linear, Config.Gains.momentum.KD_angular]);

% Postural task gains                    % torso    % left arm     % right arm     % left leg           % right leg
Config.Gains.KP_postural         = diag([30 60 60   40 40 40 40    40 40 40 40     30 30 30 30 30 30    30 30 30 30 30 30])/50;  

%% QP WEIGHTS AND THRESHOLDS

% weights for the momentum and postural tasks
Config.weights.postural            = 50; 
Config.weights.momentum            = 1e-2;    

% QP regularization
Config.reg.hessianQp               = 1e-4;  

% QP boundaries
Config.sat.maxJetsIntVar           = [50; 50; 50; 50];
Config.sat.maxJetsInt              = [160; 160; 220; 220];
Config.sat.maxJointVelDes          = 45 .* pi/180 .* ones(Config.Model.nDof,1);
