# Multi-Body Simulator (MBS) Core

This repository contains the `core` functionalities of the `multi-body simulator` (MBS) of dynamics, kinematics and control of multi-body systems.

## Operating system

The code has been developed and tested on Ubuntu 18.04.5 LTS.

## Dependencies

- [MATLAB](https://it.mathworks.com/products/matlab.html), tested up to `R2020a`.

- The MBS simulator is based on the [iDyntree](https://github.com/robotology/idyntree) library. To install `iDyntree` and its dependencies, refer to the [iDyntree README](https://github.com/robotology/idyntree#installation). When compiling `iDyntree`, it is required to set the option `IDYNTREE_USES_MATLAB` to `ON`. In order to use the [iDyntree bindings](https://github.com/robotology/idyntree/tree/master/bindings/matlab), and the [iDyntree wrappers](https://github.com/robotology/idyntree/tree/master/bindings/matlab/+iDynTreeWrappers) for MATLAB, add to the MATLAB path the `path/where/the/iDyntree/generated/mex/file/is`.

- **Optional**: an external library of MATLAB function for multi-body system dynamics, kinematics and control is available inside [whole-body-controllers](https://github.com/robotology/whole-body-controllers). To download the library, follow the instructions in the [whole-body-controllers README](https://github.com/robotology/whole-body-controllers/blob/master/README.md#installation-and-usage).

## Installation and usage

This repository can be installed in two different ways:

- `git clone` or download this repository as standalone library. **Warning**: do not directly add the MBS library functions to the [MATLAB path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html). Instead, `install` this repository with `cmake`. Use the following commands after opening a terminal in the MBS source folder:

  ```
  mkdir build
  cd build
  ccmake ..
  ```

In the cmake GUI that will open, set the `CMAKE_INSTALL_PREFIX` to your desired installation folder. Then, run `make install`.

- Dowload this repository using the [mbs_superbuild](https://github.com/gabrielenava/mbs_superbuild) **(suggested)**. In this way, there will be also the possibility to use already existing [models](https://github.com/gabrielenava/mbs_models) and [simulations](https://github.com/gabrielenava/mbs_app). For installation, follow the instructions in the [mbs_superbuild README](https://github.com/gabrielenava/mbs_superbuild/blob/master/README.md). 

In both installation cases, it is required to add to the MATLAB path the **parent** directory of the folder `+mbs` that will be installed in your cmake installation path. This can be done **manually** and **permanently** through MATLAB settings. If the repo is installed with the `mbs_superbuild` the paths can be also added by running only once the script [startup_mbs.m](https://github.com/gabrielenava/mbs_superbuild/blob/master/cmake/templates/startup_mbs.m.in) that is generated with cmake in the superbuild `build` folder. In this second case, the path will be loaded **only** if MATLAB is started from the `userpath` folders (usually `~/Documents/MATLAB`).

**Usage**: to call any `mbs_core` function inside MATLAB, you need to specify the `mbs` prefix as follows: `callToTheFunction = mbs.nameOfMyMbsFunction(**arguments**)`.

## Structure of the repo

- **core-functions**: the MATLAB functions constituting the `core` of the simulator. [[README]](core-functions/README.md)

- **utility-functions**: an internal library of utility functions. [[README]](utility-functions/README.md)

- **templates**: templates for local paths configuration. [[README]](templates/README.md)

## Mantainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava)).

