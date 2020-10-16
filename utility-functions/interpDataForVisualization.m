function [time_dec, jointPos_dec, w_H_b_dec, updatedFrameRate] = interpDataForVisualization(time, jointPos, w_H_b, frameRate)

    % interpolate the data in order to match as much as possible the desired
    % user-defined frame rate.
    
    % generate the new time vector, unless the final time is smaller than
    % the desired time step
    if time(end) > (1/frameRate) 
    
        time_dec         = time(1):1/frameRate:time(end);
        updatedFrameRate = frameRate;
        
        % verify that the joint position and the w_H_b are not 1D
        % vectors (or empty)
        if isempty(jointPos) || size(jointPos, 2) == 1
                
            jointPos_dec = jointPos;       
        else  
            for k = 1:size(jointPos,1)
                
                jointPos_dec(k,:) = interp1(time,jointPos(k,:),time_dec);
            end
        end
        if size(w_H_b, 2) == 1
                
            w_H_b_dec = w_H_b;  
        else
            
            basePoseRPY = [];
            w_H_b_dec   = [];
            
            for k = 1:size(w_H_b,2)
                
                % convert from rotation matrix to rpy
                w_H_b_current   = reshape(w_H_b(:,k),4,4);
                basePos_current = w_H_b_current(1:3,4);
                w_R_b_current   = w_H_b_current(1:3,1:3);
                baseRPY_current = wbc.rollPitchYawFromRotation(w_R_b_current);    
                basePoseRPY     = [basePoseRPY, [basePos_current; baseRPY_current]];
            end
            for k = 1:size(basePoseRPY, 1)
                
                basePoseRPY_dec(k,:) = interp1(time,basePoseRPY(k,:),time_dec);
            end
            for k = 1:size(basePoseRPY_dec,2)
                
                % re-convert from rpy to rotation matrix
                basePos_current = basePoseRPY_dec(1:3,k);
                baseRPY_current = basePoseRPY_dec(4:6,k);
                w_R_b_current   = wbc.rotationFromRollPitchYaw(baseRPY_current);   
                w_H_b_current   = [w_R_b_current, basePos_current;
                                   0   0   0   1];
                w_H_b_dec       = [w_H_b_dec, w_H_b_current(:)];
            end
        end 
        disp('[interpDataForVisualization]: data interpolation completed.')
    else
        disp('[interpDataForVisualization]: WARNING: total time < desired time step (1/frameRate). Interpolation unsupported.')
        time_dec         = time;
        jointPos_dec     = jointPos; 
        w_H_b_dec        = w_H_b;
        
        % update frame rate if dt is constant
        tol       = 1e-10;
        diffTime  = diff(time); 
        checkDiff = sum(abs(diffTime-diffTime(1)) < tol)/length(diffTime);
    
        if checkDiff < 1
     
            updatedFrameRate = frameRate;
        else
            updatedFrameRate = 1/diffTime(1);
        end
    end
end
