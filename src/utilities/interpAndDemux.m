function [w_H_b, jointPos, time_dec] = interpAndDemux(state, time, Config)

    % interpolate data so that they can be visualized real time
    time_dec = time(1):Config.interpolation.tStep:time(end);

    % it is necessary to isolate the quaternions and convert them before
    % proceeding with interpolation
    baseQuat_matrix = state(:, (6+Config.ndof+3+1):(6+Config.ndof+3+4));
    rpy_matrix      = zeros(length(time),3);

    for k = 1:size(baseQuat_matrix,1)

        qt_k            = baseQuat_matrix(k,:);
        w_R_b_k         = wbc.rotationFromQuaternion(qt_k);
        rpy_matrix(k,:) = wbc.rollPitchYawFromRotation(w_R_b_k);
    end

    state_rpy = [state(:,1:6+Config.ndof+3), rpy_matrix];

    % interpolate the state after converting rotation to RPY
    state_dec = interp1(time, state_rpy, time_dec);

    % now that signals are decimated, we proceed with data demux
    w_H_b    = zeros(4,4,length(time_dec));
    jointPos = zeros(Config.ndof,length(time_dec));

    for k = 1:length(time_dec)

        % demux the state
        [~, jointPos(:,k), basePosRpy] = wbc.vectorDemux(state_dec(k,:)', [6, Config.ndof, 6]);
        w_H_b(1:3,4,k)                 = basePosRpy(1:3);
        w_H_b(1:3,1:3,k)               = wbc.rotationFromRollPitchYaw(basePosRpy(4:6));
        w_H_b(4,1:4,k)                 = [0 0 0 1];
    end
end
