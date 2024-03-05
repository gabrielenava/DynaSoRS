function R = rotz(alpha)

    % computes a rotation along the z axis (rotation matrix).
    R = [cos(alpha), -sin(alpha), 0;
        sin(alpha),  cos(alpha), 0;
        0,           0,          1];
end
