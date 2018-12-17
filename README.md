# matlab-multi-body-sim_core

This repository contains the `core` of the `matlab-multi-body-sim` simulator of dynamics, kinematics and control of rigid multi-body systems.

## Operating system

The code has been developed and tested on Ubuntu 18.04.

## Dependencies

- [Matlab](https://it.mathworks.com/products/matlab.html), tested only with `R2018a`.

- The simulator is based on the [iDyntree](https://github.com/robotology/idyntree) library. To install `iDyntree` and its dependencies, refer to the [iDyntree README](https://github.com/robotology/idyntree#installation). When compiling `iDyntree`, it is required to set the option `IDYNTREE_USES_MATLAB` to `ON`. In order to use the [idyntree-high-level-wrappers](wrappers/idyntree-high-level-wrappers), add to the Matlab path the `path/where/the/iDyntree/mex/file/is`. 

- To use the [wrappers associated with the iDyntree visualizer](wrappers/idyntree-high-level-wrappers/idyn_initializeVisualizer.m), it is also required to install the `Irrlicht` library (see also this [README](wrappers/idyntree-high-level-wrappers#visualizer-class)). To install the library on Ubuntu 18.04, just run on a terminal:

   ```
   sudo apt-get install libirrlicht-dev
   ```

- The [WBC-library-wrappers](wrappers/WBC-library-wrappers) require an additional dependency on the [whole-body-controllers-library](https://github.com/robotology/whole-body-controllers). Follow the instructions in the [whole-body-controllers README](https://github.com/robotology/whole-body-controllers/blob/master/README.md#installation-and-usage).

## Installation and usage

This repository can be used in two different ways:

- `git clone` or download this repository as standalone library. In order to use the library, you may write your code following this [templates](https://github.com/gabrielenava/matlab-multi-body-sim_app/templates). This approach does not necessarily require to `install` the repository, but the user must add (temporarily or permanently) the `$PATH-TO-MULTI-BODY-SIM_CORE` to the [Matlab path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html). **WARNING!** If there are other functions with the same name in your Matlab path, unexpected things may happen!

- Dowload this repository using the [matlab-multi-body-sim_superbuild](https://github.com/gabrielenava/matlab-multi-body-sim_superbuild) **(suggested)**. In this way, there will be the possibility to use already existing [models](https://github.com/gabrielenava/matlab-multi-body-sim_models) and [simulations](https://github.com/gabrielenava/matlab-multi-body-sim_app). Follow the instructions in the [superbuild README](https://github.com/gabrielenava/matlab-multi-body-sim_superbuild/blob/master/README.md). The `superbuild` **will install** (copy and paste) all the functions of this repo inside the `$PATH-TO-SUPERBUILD/build/install` folder. This results in a cleaner installation as the [standard simulations](https://github.com/gabrielenava/matlab-multi-body-sim_app) by default assume the path to the `core` files to be `$PATH-TO-SUPERBUILD/build/install`.
 
## Structure of the repo

- **core-functions**: the Matlab functions constituting the `core` of the simulator. [[README]](core-functions/README.md)

- **utility-functions**: an internal library of utility functions. [[README]](utility-functions/README.md)

- **wrappers**: the available `iDyntree` and `whole-body-controllers` methods wrapped in Matlab functions. [[README]](wrappers/README.md)

## Mantainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava)).
