function c_hms = sec2hms(c_sec)

    % SEC2HMS converts a time in seconds in a [3 x 1] vector of the following
    %         format: [hours, minutes, seconds].
    %
    % FORMAT:  c_hms = sec2hms(c_sec)
    %
    % INPUTS:  - c_sec: time in seconds;
    %
    % OUTPUTS: - c_hms: [3 x 1] time in hms.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
   
    % seconds are positive or zero
    if c_sec < 0
        
        error('[sec2hms]: the input must be >= 0.')
    end
    
    hours = floor(c_sec/3600);
    min   = floor((c_sec-hours*3600)/60);
    sec   = c_sec - hours*3600 - min*60;
    
    % all values must be zero or positive
    if (hours < 0) || (min < 0) || (sec < 0)
        
        error('[sec2hms]: the output must be >= 0.')
    end
    
    c_hms = [hours, min, sec];

end