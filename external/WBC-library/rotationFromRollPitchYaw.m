function R = rotationFromRollPitchYaw(rpy)

    % wrapper of https://github.com/robotology/whole-body-controllers/tree/master/library
    R = wbc.rotationFromRollPitchYaw(rpy);
end
