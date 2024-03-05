function R = rotx(alpha)

    % computes a rotation along the x axis (rotation matrix).
    R =  [1, 0, 0;
        0, cos(alpha), -sin(alpha);
        0, sin(alpha), cos(alpha)];
end
