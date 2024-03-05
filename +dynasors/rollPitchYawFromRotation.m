function rollPitchYaw = rollPitchYawFromRotation(R)

    % converts a rotation matrix into Euler angles. The Euler angles
    % convention follows the one of iDyntree and is such that the rotation
    % matrix is:  R = Rz(yaw)*Ry(pitch)*Rx(roll).
    %
    rollPitchYaw = zeros(3,1);

    if (R(3,1) < +1)

        if (R(3,1) > -1)
            rollPitchYaw(2) = asin(-R(3,1));
            rollPitchYaw(3) = atan2(R(2,1),R(1,1));
            rollPitchYaw(1) = atan2(R(3,2), R(3,3));
        else
            % not a unique solution : roll − yaw = atan2(−R23,R22)
            rollPitchYaw(2) = pi/2;
            rollPitchYaw(3) =-atan2(-R(2,3),R(2,2));
            rollPitchYaw(1) = 0;
        end
    else
        % not a unique solution : roll − yaw = atan2(−R23,R22)
        rollPitchYaw(2) = -pi/2;
        rollPitchYaw(3) = atan2(-R(2,3),R(2,2));
        rollPitchYaw(1) = 0;
    end
end
