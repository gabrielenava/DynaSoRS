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

% Load the dataset
experimentFolder = './exp/';
experimentName   = mbs.openExperimentsMenu(experimentFolder);
expData          = load([experimentFolder,experimentName]);

% Get the base pose and the joints positions
time     = expData.jointData.time;
jointPos = [];
w_H_b    = [];

for k = 1:length(expData.jointData.signals)-1
    
    jointPos = [jointPos, expData.jointData.signals(k).values*pi/180]; %#ok<AGROW>
end

for k = 1:length(time)
    
    w_R_b         = expData.basePoseData.signals(2).values(:,:,k);
    basePos       = expData.basePoseData.signals(1).values(:,:,k);   
    w_H_b_matr    = [w_R_b, basePos;
                     0   0   0   1];
    w_H_b         = [w_H_b, w_H_b_matr(:)]; %#ok<AGROW>
end

% define a new structure for the iDyntree visualizer containing the
% joints position, base pose and time vector
Config.SimulationOutput.jointPos = jointPos';
Config.SimulationOutput.w_H_b    = w_H_b;
Config.SimulationOutput.time     = time;
