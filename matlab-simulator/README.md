# matlab-simulator

Matlab simulator of rigid multi body systems dynamics, kinematics and control. 

## Structure of the simulator

- All the models configuration files are inside the `app/robotName` folder. Example configuration files are stored in the folder [app/icubGazeboSim](app/icubGazeboSim).

- The available simulations are in the [simulations](simulations/) folder.

- The functions constituting the `core` of the simulator are stored in the [core](core/) folder.

## Configuration files

In order to use the simulator, the following configuration files are required:

- a **urdf model** of the system (e.g. [model.urdf](app/icubGazeboSim/model.urdf));
- a Matlab script named `init_($robotName).m` (e.g. [init_icubGazeboSim](app/icubGazeboSim/init_icubGazeboSim.m)) which contains model-specific information such as the joints names, the chosen base link and so on. 

**Do not add information related to a specific simulation in the init file**. It is strongly suggested to create (if necessary) a separate `init` file for each simulation inside the `app/robotName` folder.

## Instruction

To start the simulator, run the [runMatlabSimulator](runMatlabSimulator.m) script. After running the script, two menus will appear. 

- With the first menu, it will be possible to select the model to simulate. All the **models folders** inside the `app` folder are automatically added in the models list.
- With the second menu, it will be possible to choose between different simulations. The simulations list depends on the loaded model, e.g. for the `icubGazeboSim` model some of the available simulations are:

  - test-idyntree-wrappers (test)
  - gravity compensation (torque control)
  - momentum-based-control (torque control)
 
The first demo is a test of the iDyntree high level wrappers. The gravity compensation considers the base link fixed on ground. The momentum-based control demo instead requires to specify  the list of links which are considered to be in contact with the environment. At the moment, only rigid contacts are allowed. The link in contact is assumed to be fixed, i.e. it has a constant pose w.r.t. the inertial frame. 

It is possible to avoid opening the menus by setting to `TRUE` the variables `useDefaultModel` and/or `runDefaultSimulation` on top of the `runMatlabSimulator` and `init_($robotName)` scripts.

## Visualization

After running the simulation, it is possible to visualize the robot movements by means of the `iDyntree visualizer`, plot the results and take a video/save pictures of the simulation. In order to use the iDyntree visualizer it may be required to provide the mesh files of the links of your model. You can store the meshes in a folder called `meshes` inside the `app/robotName` folder. WARNING: not all the mesh files are loaded correctly by the iDyntree visualizer!

## Post-processing

It is also possible to save the simulation data and replay the iDyntree visualizer/replot the figures of the simulation by running the [openExistingSimulation](openExistingSimulation.m) script.
