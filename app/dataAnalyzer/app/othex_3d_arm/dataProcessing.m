% DATAPROCESSING formats data in a format that can be played-back by the 
%                iDyntree visualizer.
%
%                EXPECTED VARIABLES:
%
%                time:  [n x 1] vector of n time instants;
%                w_H_b: [16 x n] or [16 x 1] column vecotrization of the
%                        transformation matrix from world to base frame;
%
%                Optional:
%
%                jointPos: [nDof x n] or [1 x n] vector of joint positions;
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------

% Load the dataset. WARNING: the dataset should not contain a variable 
% called 'Config' or it will be overwritten!
expData  = load('./exp/exp1.mat');

% Get the base pose and the joints positions
basePos  = expData.basePos_DATA.signals(1).values;
baseRot  = expData.baseRotRPY_DATA.signals(1).values*pi/180;
jointPos = expData.jointPos_DATA.signals(1).values*pi/180;
time     = expData.time_Genom.signals.values;
w_H_b    = zeros(16,size(basePos,1));

% Update the base postion w.r.t. world frame
for k = 1:size(basePos,1)
    
    basePosAndRot = [wbc.rotationFromRollPitchYaw(baseRot(k,:)), basePos(k,:)';
                     0 0 0 1];
    w_H_b(1:16,k) = basePosAndRot(:);
end

% define a new structure for the iDyntree visualizer containing the
% joints position, base pose and time vector
Config.SimulationOutput.jointPos = jointPos';
Config.SimulationOutput.w_H_b    = w_H_b;
Config.SimulationOutput.time     = time;
