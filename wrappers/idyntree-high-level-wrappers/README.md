# idyntree high-level-wrappers

A collection of Matlab functions that wraps the functionalities of (mainly) the iDyntree class `KinDynComputations`. For further information on the single wrapper, refer to the description included in each function.

## KinDynComputations class

### Load the reduced model

- [idyn_loadReducedModel](idyn_loadReducedModel.m)

### Retrieve data from the model

- [idyn_getJointPos](idyn_getJointPos.m)
- [idyn_getJointVel](idyn_getJointVel.m)
- [idyn_getCentroidalTotalMomentum](idyn_getCentroidalTotalMomentum.m)
- [idyn_getRobotState](idyn_getRobotState.m)
- [idyn_getWorldBaseTransform](idyn_getWorldBaseTransform.m)
- [idyn_getBaseTwist](idyn_getBaseTwist.m) 
- [idyn_getModelVel](idyn_getModelVel.m) 
- [idyn_getFrameVelocityRepresentation](idyn_getFrameVelocityRepresentation.m)
- [idyn_getNrOfDegreesOfFreedom](idyn_getNrOfDegreesOfFreedom.m)
- [idyn_getFloatingBase](idyn_getFloatingBase.m)
- [idyn_getFrameIndex](idyn_getFrameIndex.m)
- [idyn_getFrameName](idyn_getFrameName.m)
- [idyn_getWorldTransform](idyn_getWorldTransform.m) 
- [idyn_getRelativeTransform](idyn_getRelativeTransform.m) 
- [idyn_getRelativeJacobian](idyn_getRelativeJacobian.m) 
- [idyn_getFreeFloatingMassMatrix](idyn_getFreeFloatingMassMatrix.m)
- [idyn_getFrameBiasAcc](idyn_getFrameBiasAcc.m)
- [idyn_getFrameFreeFloatingJacobian](idyn_getFrameFreeFloatingJacobian.m)
- [idyn_getCenterOfMassPosition](idyn_getCenterOfMassPosition.m) 
- [idyn_generalizedBiasForces](idyn_generalizedBiasForces.m) 
- [idyn_generalizedGravityForces](idyn_generalizedGravityForces.m)
- [idyn_getCenterOfMassJacobian](idyn_getCenterOfMassJacobian.m) 
- [idyn_getCenterOfMassVelocity](idyn_getCenterOfMassVelocity.m) 
 
### Set the model-related quantities
 
- [idyn_setJointPos](idyn_setJointPos.m) 
- [idyn_setFrameVelocityRepresentation](idyn_setFrameVelocityRepresentation.m)
- [idyn_setFloatingBase](idyn_setFloatingBase.m) 
- [idyn_setRobotState](idyn_setRobotState.m)

## Visualizer class

Not proper wrappers, they wrap more than one method of the class each. **Requirements:** compile iDyntree with Irrlicht `(IDYNTREE_USES_IRRLICHT = ON)`.

- [idyn_initializeVisualizer](idyn_initializeVisualizer.m)
- [idyn_visualizerSetup](idyn_visualizerSetup.m)
- [idyn_updateVisualizer](idyn_updateVisualizer.m)
