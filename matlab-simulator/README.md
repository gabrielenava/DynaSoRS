# Matlab simulator

Simulator of rigid multi body systems dynamics, kinematics and control. 

## Instructions

In order to use the simulator, the following configuration files are required:

%               - a urdf model of the system (e.g. model.urdf);
%               - a Matlab script named initModel.m which contains
%                 model-specific information such as the joints names,
%                 the chosen base link and so on. 
%
% All the configuration files must be stored inside the 'app/robotName' 
% folder. Example configuration files are stored in the folder 'app/icubGazeboSim'.
%
% After running this script, two menus will appear. 
%
% - With the first menu, it will be possible to select the model to simulate. 
%   all the models folders inside the 'app' folder are automatically added in 
%   the models list.
% - With the second menu, it will be possible to choose between different 
%   The simulations list depends on the loaded model, e.g. for the 
%   'icubGazeboSim' model the available simulations are:
%
%     - test-idyntree-wrappers (test)
%     - gravity compensation (torque control)
%     - end-effector control through inverse kinematics (position control)
%     - momentum-based balancing control (torque control)
% 
%   The first demo is a test of the iDyntree high level wrappers. The gravity
%   compensation and IK demos consider the base link fixed on ground. The 
%   momentum-based control demo instead requires to specify the list of 
%   links which are considered to be in contact with the environment. At 
%   the moment, only rigid contacts are allowed. The link in contact is 
%   assumed to be fixed, i.e. it has a constant pose w.r.t. the inertial frame. 
%
% It is possible to avoid opening the menus by setting to TRUE the variables 
% 'useDefaultModel' and/or 'runDefaultSimulation' on top of this script. In 
% this case the model contained in the folder specified by the variable 
% 'defaultConfig.initSim.modelFolderName' will be loaded.
% For each model, it is also possible to specifiy a default simulation that 
% can be set by editing the variables 'defaultSimulation' and 'defaultDemoFolder'
% in the initModel.m configuration file.
%
% Additionally, to use the iDyntree visualizer it may be required to provide
% the mesh files of the links in your model. You can store the meshes in a 
% folder called 'meshes' where your initModel.m is. WARNING: not all the mesh 
% files are loaded correctly by the iDyntree visualizer!
