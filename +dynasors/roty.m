function R = roty(alpha)

    % computes a rotation along the y axis (rotation matrix).
    R = [cos(alpha), 0, sin(alpha);
        0, 1, 0;
        -sin(alpha), 0, cos(alpha)];
end
