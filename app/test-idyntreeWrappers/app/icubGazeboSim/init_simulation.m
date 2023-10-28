% INIT_SIMULATION initializes the user-defined simulation.
%
%     REQUIRED VARIABLES:
%
%         - Config: [struct] with fields:
%
%             - Simulator: [struct];
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018; Modified Sept. 2020
    
%% ------------Initialization----------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% iDynTree wrappers inputs %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set some inputs to the wrappers
Config.wrappersTest.frameVelRepr = 'mixed';
Config.wrappersTest.frameName    = 'l_sole';
Config.wrappersTest.frame2Name   = 'r_sole';
Config.wrappersTest.frameID      = 1;
Config.wrappersTest.frame2ID     = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% iDyntree visualizer setup %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the view options for the iDynTree visualizer
Config.iDyntreeVisualizer.w_H_b_fixed        =  eye(4);
Config.iDyntreeVisualizer.meshesPath         =  Config.Simulator.pathToModel;
Config.iDyntreeVisualizer.color              =  [0.9,0.9,0.9];
Config.iDyntreeVisualizer.material           = 'metal';
Config.iDyntreeVisualizer.transparency       =  1;
Config.iDyntreeVisualizer.debug              =  true; 
Config.iDyntreeVisualizer.view               =  [-92.9356   22.4635];
Config.iDyntreeVisualizer.groundOn           =  true; 
Config.iDyntreeVisualizer.groundColor        =  [0.5 0.5 0.5];
Config.iDyntreeVisualizer.groundTransparency =  0.5;
Config.iDyntreeVisualizer.groundFrame        = 'l_sole';
