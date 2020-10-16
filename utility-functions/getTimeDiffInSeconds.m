function c_diff = getTimeDiffInSeconds(c_in,c_out)

    % GETTIMEDIFFINSECONDS evaluates the difference in seconds between two
    %                      outputs of the matlab function "clock". It will
    %                      assume that the year and month are the same in
    %                      both inputs.
    %
    % FORMAT:  c_diff = getTimeDiffInSeconds(c_in,c_out)
    %
    % INPUTS:  - c_in: [1 x 6] output of the "clock" function;
    %          - c_out: [1 x 6] output of the "clock" function;
    %
    % OUTPUTS: - c_diff: (c_out-c_in) in seconds.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
   
    % the "clock" format is: [year month day hour minute second]
    tol = 0.001;
    
    if abs(c_out(1)-c_in(1))>tol || abs(c_out(2)-c_in(2))>tol
    
        error('[getTimeDiffInSeconds]: the inputs must have the same year and month.')
    end
    
    % convert in seconds BEFORE subtracting or the result may be wrong!
    c_in   = c_in(3)*86400 + c_in(4)*3600 + c_in(5)*60 + c_in(6);
    c_out  = c_out(3)*86400 + c_out(4)*3600 + c_out(5)*60 + c_out(6);
    
    % difference in seconds
    c_diff = c_out-c_in;
end