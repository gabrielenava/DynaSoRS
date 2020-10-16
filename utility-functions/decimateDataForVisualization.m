function [time_dec, jointPos_dec, w_H_b_dec, updatedFrameRate] = decimateDataForVisualization(time, jointPos, w_H_b, frameRate)

    % decimate the data in order to match as much as possible the desired
    % user-defined frame rate
    
    % get the current FPS. NOTE: this function will do nothing if the time 
    % step is not constant, or if the desired FPS is smaller than the current 
    % FPS (both cases would require interpolation!)
    tol       = 1e-10;
    diffTime  = diff(time); 
    checkDiff = sum(abs(diffTime-diffTime(1)) < tol)/length(diffTime);
    
    if checkDiff < 1
        
        disp('[decimateDataForVisualization]: WARNING: time step is not constant. Decimation unsupported.')
        time_dec         = time;
        jointPos_dec     = jointPos; 
        w_H_b_dec        = w_H_b;
        updatedFrameRate = frameRate;
    else   
        % in this case, compute the current FPS
        currentFPS       = 1/diffTime(1);
        desiredFPS       = frameRate;
        
        if currentFPS/desiredFPS < 2
            
            disp('[decimateDataForVisualization]: WARNING: currentFPS/desiredFPS < 2. Decimation unsupported.')
            time_dec         = time;
            jointPos_dec     = jointPos; 
            w_H_b_dec        = w_H_b;
            updatedFrameRate = currentFPS;
        else   
            decimationStep   = floor(currentFPS/desiredFPS);

            % verify that the length of time vector is greater than the step 
            % chosen for decimation, otherwise do nothing
            if length(time) <= decimationStep

                disp('[decimateDataForVisualization]: WARNING: time vector is smaller equal than decimation step. Skipping decimation.')
           
                time_dec         = time;
                jointPos_dec     = jointPos; 
                w_H_b_dec        = w_H_b;
                updatedFrameRate = currentFPS;
            else
                time_dec         = time(1:decimationStep:end);
                
                % updating framerate
                decimFrameRate   = 1/(time_dec(2)-time_dec(1));
                updatedFrameRate = decimFrameRate;
           
                % verify that the joint position and the w_H_b are not 1D
                % vectors (or empty)
                if isempty(jointPos) || size(jointPos, 2) == 1
                
                    jointPos_dec = jointPos;       
                else               
                    jointPos_dec = jointPos(:,1:decimationStep:end);
                end
                if size(w_H_b, 2) == 1
                
                    w_H_b_dec = w_H_b;  
                else  
                    w_H_b_dec = w_H_b(:,1:decimationStep:end);
                end
                disp('[decimateDataForVisualization]: data decimation completed.')
            end    
        end     
    end
end
