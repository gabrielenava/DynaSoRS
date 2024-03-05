function R = rotationFromRollPitchYaw(rpy)

    % converts Euler angles (roll-pitch-yaw) into a rotation matrix.
    % Composition rule for rotation matrices explained here:
    %
    % https://robotology.github.io/idyntree/classiDynTree_1_1Rotation.html
    %
    R = dynasors.rotz(rpy(3))*dynasors.roty(rpy(2))*dynasors.rotx(rpy(1));
end
