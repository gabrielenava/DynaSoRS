function [w_H_b, jointPos] = demuxState(state, ndof)

    % assumes that the input 'state' is composed as follows:
    %
    %   state = [n_timeSteps x n_state]
    %
    %   state(i,:) = [L, jointPos, basePoseQuat]
    %
    % i.e., the last 7 elements of each row of 'state' are the base position
    % and orientation (expressed using quaternions).

    % it is necessary to isolate the quaternions and convert them to RPY
    baseQuat_matrix = state(:, (6+ndof+3+1):(6+ndof+3+4));
    rpy_matrix      = zeros(size(state,1),3);

    for k = 1:size(baseQuat_matrix,1)

        qt_k            = baseQuat_matrix(k,:);
        w_R_b_k         = wbc.rotationFromQuaternion(qt_k);
        rpy_matrix(k,:) = wbc.rollPitchYawFromRotation(w_R_b_k);
    end

    state_rpy = [state(:,1:6+ndof+3), rpy_matrix];
    w_H_b     = zeros(4,4,size(state,1));
    jointPos  = zeros(ndof,size(state,1));

    for k = 1:size(state,1)

        % demux the state
        [~, jointPos(:,k), basePosRpy] = wbc.vectorDemux(state_rpy(k,:)', [6, ndof, 6]);
        w_H_b(1:3,4,k)                 = basePosRpy(1:3);
        w_H_b(1:3,1:3,k)               = wbc.rotationFromRollPitchYaw(basePosRpy(4:6));
        w_H_b(4,1:4,k)                 = [0 0 0 1];
    end
end
