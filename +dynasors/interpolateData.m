function varargout = interpolateData(varargin)

    % Interpolate and decimate data so that they can be visualized real
    % time with the Visualizer class. JointPos is a matrix of size
    % ndofxlength(time), while w_H_b is of size 4x4xlength(time).
    %
    % Floating base:
    %
    %  [w_H_b_dec, jointPos_dec, time_dec] = interpolateData(w_H_b, jointPos, time, tStep)
    %
    % Fixed base:
    %
    %  [jointPos_dec, time_dec] = interpolateData(jointPos, time, tStep)
    %
    switch nargin
        case 4
            w_H_b    = varargin{1};
            jointPos = varargin{2};
            time     = varargin{3};
            tStep    = varargin{4};
        case 3
            jointPos = varargin{1};
            time     = varargin{2};
            tStep    = varargin{3};
        otherwise
            error('[interpolateData]: wrong number of inputs!')
    end

    time_dec = time(1):tStep:time(end);

    if nargin == 4
        % it is necessary to convert w_H_b in position + rpy  before
        % proceeding with the interpolation
        pos = zeros(3, length(time));
        rpy = zeros(3, length(time));

        for k = 1:length(time)

            w_H_b_k   = w_H_b(:,:,k);
            pos(:, k) = w_H_b_k(1:3, 4);
            rpy(:, k) = dynasors.rollPitchYawFromRotation(w_H_b_k(1:3, 1:3));
        end
        state = [pos; rpy; jointPos];
    else
        state = jointPos;
    end

    % interpolate the state
    state_dec = interp1(time, transpose(state), time_dec);
    state_dec = transpose(state_dec);

    % now that signals are decimated, we regenerate w_H_b and jointPos
    if nargin == 4
        basePosRpy   = state_dec(1:6, :);
        jointPos_dec = state_dec(7:end, :);
        w_H_b_dec    = zeros(4, 4, length(time_dec));

        for k = 1:length(time_dec)

            w_H_b_dec(1:3, 4, k) = basePosRpy(1:3, k);
            w_H_b_dec(1:3, 1:3, k) = dynasors.rotationFromRollPitchYaw(basePosRpy(4:6, k));
            w_H_b_dec(4, 1:4, k) = [0 0 0 1];
        end
        varargout{1} = w_H_b_dec;
        varargout{2} = jointPos_dec;
        varargout{3} = time_dec;
    else
        jointPos_dec = state_dec;
        varargout{1} = jointPos_dec;
        varargout{2} = time_dec;
    end
end
