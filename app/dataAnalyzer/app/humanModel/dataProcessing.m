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
time     = expData.time_DATA;
w_H_b    = expData.w_H_b_DATA;
jointPos = expData.jointPos_DATA;
w_H_b    = w_H_b(:);   

% define a new structure for the iDyntree visualizer containing the
% joints position, base pose and time vector
Config.SimulationOutput.jointPos = jointPos';
Config.SimulationOutput.w_H_b    = w_H_b;
Config.SimulationOutput.time     = time;
