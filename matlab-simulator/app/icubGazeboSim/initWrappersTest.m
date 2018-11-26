% INITWRAPPERSTEST initializes the iDyntree-wrappers test. WARNING: this script
%                  just tests if the wrappers are correctly working. It does
%                  not test if the quantities that are set to or get from
%                  the model are correct. Running the wrappers in DEBUG mode
%                  can help in testing the soundness of these quantities.
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------
    
% set the initial robot position and velocity
torso_Position     = [0  0  0];                 
left_arm_Position  = [10 45 0  15 0];           
right_arm_Position = [10 45 0  15 0];         
right_leg_Position = [0  0  0  0  0  0];        
left_leg_Position  = [0  0  0  0  0  0];

Config.initConditions.jointPos_init = [torso_Position';left_arm_Position';right_arm_Position';left_leg_Position';right_leg_Position']*pi/180;
Config.initConditions.jointVel_init = zeros(length(Config.initConditions.jointPos_init),1);

% configuration parameters
Config.gravityAcc   = [0;0;-9.81];
Config.frameVelRepr = 'mixed';
Config.frameName    = 'l_sole';
Config.frame2Name   = 'r_sole';
Config.frameID      = 10;
Config.frame2ID     = 1;

% set the view options for the visualizer
Config.visualizer.debug                    = false;
Config.visualizer.cameraPos                = [1,0,0.5];    
Config.visualizer.cameraTarget             = [0.4,0,0.5];
Config.visualizer.lightDir                 = [-0.5 0 -0.5]/sqrt(2);
Config.visualizer.disableViewInertialFrame = true;
Config.visualizer.w_R_b_fixed              = [-1  0  0;
                                               0 -1  0;
                                               0  0  1];
Config.visualizer.w_H_b_fixed              = [Config.visualizer.w_R_b_fixed , [0;0;0.7];
                                                   0        0        0          1];