# DynaSoRS

**Dynamic SimulatOr of Rigid Systems**

A collection of MATLAB classes that can be used for simulation of rigid body systems kinematics, dynamics, and control.

## Operating system

The code has been tested on Ubuntu 20.04.3 LTS.

## Dependencies

- [MATLAB](https://it.mathworks.com/products/matlab.html), tested up to `R2022a`.

- DynaSoRS is based on the [iDyntree](https://github.com/robotology/idyntree) library. To install `iDyntree` and its dependencies, refer to the [iDyntree README](https://github.com/robotology/idyntree#installation). When compiling `iDyntree`, it is required to set the option `IDYNTREE_USES_MATLAB` to `ON`. In order to use the [iDyntree bindings](https://github.com/robotology/idyntree/tree/master/bindings/matlab), and the [iDyntree wrappers](https://github.com/robotology/idyntree/tree/master/bindings/matlab/+iDynTreeWrappers) for MATLAB, add to the MATLAB path the `path/where/the/iDyntree/generated/mex/file/is`.

- Some classes depend on `wbc`, a library of MATLAB functions for multi-body systems dynamics, kinematics and control available inside [whole-body-controllers](https://github.com/robotology/whole-body-controllers). To download the library, follow the instructions in the [whole-body-controllers README](https://github.com/robotology/whole-body-controllers/blob/master/README.md#installation-and-usage).

- Some classes depend on [casadi](https://web.casadi.org/) library. Download and install the MATLAB bindings from the [website](https://web.casadi.org/get/).

## Installation and usage (to be updated)

Provided that the dependencies are met, `git clone` or download this repository as standalone library.

## Example

An example of usage of the library is given in the script [testDynaSoRS.m](https://github.com/gabrielenava/DynaSoRS/blob/master/testDynaSoRS.m), which is based on the robot models available in [ironcub_mk1_software](https://github.com/ami-iit/ironcub_mk1_software). **USAGE**: after installing the additional dependency `ironcub_mk1_software`, just run the script.

## Mantainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava)).
