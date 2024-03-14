# DynaSoRS

**Dynamic SimulatOr of Rigid Systems**

A small collection of MATLAB classes and functions that can be used to simulate rigid body systems kinematics, dynamics, and control.

## Operating system

The code has been tested on Ubuntu 20.04.3 LTS.

## Dependencies

- [MATLAB](https://it.mathworks.com/products/matlab.html), tested up to `R2022a`.

- DynaSoRS is based on the [iDyntree](https://github.com/robotology/idyntree) library. To install `iDyntree` and its dependencies, refer to the [iDyntree README](https://github.com/robotology/idyntree#installation). When compiling `iDyntree`, it is required to set the option `IDYNTREE_USES_MATLAB` to `ON`. In order to use the [iDyntree bindings](https://github.com/robotology/idyntree/tree/master/bindings/matlab), and the [iDyntree wrappers](https://github.com/robotology/idyntree/tree/master/bindings/matlab/+iDynTreeWrappers) for MATLAB, add to the MATLAB path the `path/where/the/iDyntree/generated/mex/file/is`.

- Some classes depend on [casadi](https://web.casadi.org/) library. Download and install the MATLAB bindings from the [website](https://web.casadi.org/get/).

- **Optional**: some examples depend on `wbc`, a MATLAB library for multi-body systems dynamics, kinematics and control available inside [whole-body-controllers](https://github.com/robotology/whole-body-controllers). To download the library, follow the instructions in the [whole-body-controllers README](https://github.com/robotology/whole-body-controllers/blob/master/README.md#installation-and-usage).

- **Optional**: the example on iRonCub-Mk1_1 depends on `wbc` library and on [ironcub-mk1-software](https://github.com/ami-iit/ironcub-mk1-software).

## Installation and usage

#### On Ubuntu
Provided that the dependencies are met, `git clone` or download this repository. Then, run the following commands:

```
mkdir build & cd build
```
```
cmake .. -DCMAKE_INSTALL_PREFIX="/path/to/desired/install/dir"
make install
```

In order to use the library, add to the MATLAB path the `path/where/the/installed/dynasors/package/is`.

## Tests

The main classes of the library are tested in the [tests](tests) folder. This is also a good way to verify if the code has been installed correctly.

## Examples

Examples of usage of the library are given in the [examples](examples) folder:

- [simpleRobot](examples/simpleRobot): dynamics simulation and control of a simple fixed-base serial robot.
- [iRonCub-Mk1_1](examples/iRonCub-Mk1_1) dynamics simulation and QP control of a floating-base jet-powered humanoid robot.

## Maintainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava)).
