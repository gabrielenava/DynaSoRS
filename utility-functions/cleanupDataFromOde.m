function [] = cleanupDataFromOde(Visualization)

    % update the data saved while running ode by removing negative dt
    
    % load the data
    DataForVisualization = matfile(['./DATA/',Visualization.dataFileName,'.mat'],'Writable',true);
    
    % it is assumed that the time vector is named "t"
    [~, timeIndeces] = sort(DataForVisualization.t);

    timeIndeces_upd = timeIndeces;
    maxIndex        = timeIndeces(1);

    for k = 2:length(timeIndeces)
    
        if timeIndeces(k) > maxIndex
        
            maxIndex = timeIndeces(k);
        else
            timeIndeces_upd(k) = 0;
        end    
    end
    
    % find the times with positive dt
    timeIndeces_nonZero = timeIndeces_upd(timeIndeces_upd ~= 0);
    
    for k = 1:length(Visualization.vizVariableList)
       
        currentData = DataForVisualization.(Visualization.vizVariableList{k});
        
        if ismatrix(currentData)

            currentData = currentData(:,timeIndeces_nonZero);
                        
        elseif ndims(currentData) == 3
                        
            % matrices are concatenated along a third dimension.
            currentData = currentData(:,:,timeIndeces_nonZero);
            
        else      
            error(['[cleanupDataFromOde]: invalid data: ',Visualization.vizVariableList{k}])     
        end
                    
        % update the stored variable
        DataForVisualization.(Visualization.vizVariableList{k}) = currentData;
    end
    disp('[cleanupDataFromOde]: removed negative dt from saved data.')
end