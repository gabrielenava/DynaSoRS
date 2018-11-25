## matlab-multi-body-sim

### Dependencies

- This repository requires [iDyntree](https://github.com/robotology/idyntree) and [Matlab](https://it.mathworks.com/products/matlab.html) to be installed on your machine. When compiling `iDyntree`, it is required to set the option `IDYNTREE_USES_MATLAB` to `ON`.

- To use the [functions associated with the idyntree visualizer](https://github.com/gabrielenava/idyntree-high-level-wrappers/blob/master/wrappers/idyn_initializeVisualizer.m), it is also required to install the `Irrlicht` library (see also this [README](wrappers#visualizer-and-simpleleggedodometry-class)). To install the library on Ubuntu, just run on a terminal:

```
sudo apt-get install libirrlicht-dev
```

### Structure of the repo

- **idyntree-high-level-wrappers**: the available `iDyntree` methods wrapped in Matlab functions. [[README]](idyntree-high-level-wrappers/README.md)

- **matlab-simulator**: [[README]](matlab-simulator/README.md)

- **utility-functions**: [[README]](utility-functions/README.md)

### Installation and usage

If all the required dependencies are correctly installed and configured, it is just necessary to clone this repository on your pc. 

### Mantainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava))
