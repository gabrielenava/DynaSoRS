% INITMATLABSIMULATOR matlab simulator of rigid multi body systems. In order 
%                     to use the simulator, the following configuration 
%                     files are required:
%                     
%                     - a urdf model of the system (e.g. model.urdf);
%                     - a Matlab script named initModel.m which contains
%                       model-specific information such as the joints names,
%                       the chosen base link and so on. 
%
% All configuration files must be stored inside the 'app/robotName' folder. 
% An example of configuration files is stored in the folder 'app/icubGazeboSim'.
% To switch between different configuration files edit the variable 
% 'initFolderName' on top of this script.
%
% After running this script a menu will appear. It will be possible to select 
% different simulations. The simulations list depend on the loaded model. 
% For the 'icubGazeboSim' model, the available simulations are:
%
% - test-idyntree-wrappers (test)
% - gravity compensation (torque control)
% - end-effector control through inverse kinematics (position control)
% - momentum-based balancing control (torque control)
% 
% The first demo is a test of the iDyntree high level wrappers. The gravity
% compensation and IK demos consider the base link fixed on ground. The 
% last one instead requires to specify the list of links which are considered 
% to be in contact with the environment. At the moment, only rigid contacts
% are allowed. The link in contact is assumed to be fixed, i.e. it has a 
% constant pose w.r.t. an inertial reference frame. 
%
% It is possible to avoid opening the menu and directly run one of the
% available simulations by setting the variable 'useStaticGui' in the 
% initModel.m configuration file.
%
% Additionally, to use the iDyntree visualizer it may be required to provide
% the mesh files of the links in your model. You can store the meshes in a 
% folder called 'meshes' where your initModel.m is. WARNING: not all the mesh 
% files are loaded correctly by the iDyntree visualizer!
%
% Author: Gabriele Nava (gabriele.nava@iit.it)
% Genova, Nov 2018
    
%% ------------Initialization----------------
clear
close all
clc

fprintf('\n######################################\n');
fprintf('\nMatlab rigid-multi-body-simulator V1.0\n');
fprintf('\n######################################\n\n');

disp('[initMatlabSimulator]: ready to start.') 

% choose the folder containing the model to initialize. Default: 'icubGazeboSim'
Config.initFolderName = 'icubGazeboSim';

% add paths to the library and wrappers folders
addpath('./simulations/common-functions')
addpath(genpath('../utility-functions'))
addpath(genpath('../idyntree-high-level-wrappers'))

% run the configuration files (and create the Config variable)
run(strcat(['app/',Config.initFolderName,'/initModel.m'])); 

% run the menu for selecting the simulation, or run the default simulation
selectSimulation(Config);

% remove paths to the library and wrappers folders
rmpath('./simulations/common-functions')
rmpath(genpath('../utility-functions'))
rmpath(genpath('../idyntree-high-level-wrappers'))

disp('[initMatlabSimulator]: simulation ended.') 