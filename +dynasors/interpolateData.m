function [w_H_b_dec, jointPos_dec, time_dec] = interpolateData(w_H_b, jointPos, time, tStep)

    % interpolate and decimate data so that they can be visualized real
    % time with the Visualizer class. JointPos is a matrix of size
    % ndofxlength(time), while w_H_b is of size 4x4xlength(time).
    time_dec = time(1):tStep:time(end);

    % it is necessary to convert w_H_b in position + rpy  before proceeding
    % with interpolation
    pos = zeros(3, length(time));
    rpy = zeros(3, length(time));

    for k = 1:length(time)

        w_H_b_k   = w_H_b(:,:,k);
        pos(:, k) = w_H_b_k(1:3, 4);
        rpy(:, k) = dynasors.rollPitchYawFromRotation(w_H_b_k(1:3, 1:3));
    end

    state_rpy = [pos; rpy; jointPos];

    % interpolate the state
    state_dec = interp1(time, transpose(state_rpy), time_dec);
    state_dec = transpose(state_dec);

    % now that signals are decimated, we regenerate w_H_b and jointPos
    basePosRpy   = state_dec(1:6, :);
    jointPos_dec = state_dec(7:end, :);
    w_H_b_dec    = zeros(4, 4, length(time_dec));

    for k = 1:length(time_dec)

        w_H_b_dec(1:3, 4, k) = basePosRpy(1:3, k);
        w_H_b_dec(1:3, 1:3, k) = dynasors.rotationFromRollPitchYaw(basePosRpy(4:6, k));
        w_H_b_dec(4, 1:4, k) = [0 0 0 1];
    end
end
