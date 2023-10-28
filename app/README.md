# Multi Body Simulator (MBS) App

Multi-body dynamics simulations developed using the `multi-body-simulator`.

## Operating system

The code has been tested on Ubuntu 20.04.3 with MATLAB 2021a.

## Dependencies

- [mbs_core](https://github.com/gabrielenava/mbs_core), and its dependencies.

- **OPTIONAL:** [mbs_models](https://github.com/gabrielenava/mbs_models).

- **OPTIONAL:** [whole-body-controllers library](https://github.com/robotology/whole-body-controllers/tree/master/library/matlab-wbc/%2Bwbc).

## Installation and usage

This repository can be installed in two different ways:

- `git clone` or download this repository as standalone repo. In this case, it is required to manually specify your local paths to the `mbs_core` and `mbs_models` folders, and to other `external sources` (if there is any).

- Download this repository using the [mbs_superbuild](https://github.com/gabrielenava/mbs_superbuild) **(suggested)**. In this way, the local paths are automatically set. **Note**: path to the optional WBC library is not set automatically. 
 
## Structure of the repo

### Testing

- [test-idyntreeWrappers](test-idyntreeWrappers): test the wrappers of the `iDyntree` library.

### Available simulations

- [gravComp-fixed-multiBody](gravComp-fixed-multiBody)
- [freeFalling-singleBody](freeFalling-singleBody)
- [balancing-floating-multiBody](balancing-floating-multiBody)

### Post processing and data analysis

- [dataAnalyzer](dataAnalyzer)

## Mantainer

Gabriele Nava ([@gabrielenava](https://github.com/gabrielenava)).
