function dataFileName = saveSimulationData(Visualization,Simulator,mode)

    % SAVESIMULATIONDATA either creates a MAT file where the simulation
    %                    results are stored, or updates an already existing 
    %                    MAT file. 
    %
    % FORMAT:  dataFileName = saveSimulationData(Visualization,Simulator,mode)
    %
    % INPUTS:  - Visualization: plots-specific configuration parameters;
    %
    %                           REQUIRED FIELDS: 
    %
    %                           - vizVariableList: [cell array of strings]
    %                                              "init" mode only;
    %                           - dataFileName: [string] "update" mode only;
    %                           - updatedVizVariableList: [cell array of strings]
    %                                                     "update" mode only;
    %                           - dataForVisualization: [struct] "update" mode only,
    %                                                   fields must have
    %                                                   the names specified
    %                                                   in the updatedVizVariableList;
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - modelFolderName: [string];
    %
    %          - mode: either "init" to create the MAT file or "update" to
    %                  update the already existing file.
    %
    % OUTPUTS: - dataFileName = a string specifying the name of the MAT
    %                           file that has been created (mode = "init"). 
    %                           If mode = "update", this output is empty.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    dataFileName = [];
    
    if strcmp(mode,'init')
        
        if ~exist('data','dir')
            
            mkdir('data');
        end
        
        % generate the MAT file name
        c            = clock;
        dataFileName = [Simulator.modelFolderName,'_',num2str(c(4)),'_',num2str(c(5))];
        
        % create the variables to plot if they do not exist
        if isempty(Visualization.vizVariableList)

           error('[saveSimulationData]: empty vizVariableList.');
        else
            for k = 1:length(Visualization.vizVariableList)
                
                if ~exist(Visualization.vizVariableList{k},'var')
                    
                    eval([Visualization.vizVariableList{k},' = [];'])
                end
            end
        end
        
        % save the variables in the MAT file
        save(['./data/',dataFileName,'.mat'],Visualization.vizVariableList{:});
    
    elseif strcmp(mode,'update')
        
        if exist('data','dir')
            
            if exist(['./data/',Visualization.dataFileName,'.mat'],'file') == 2
                
                % update the data inside the MAT file
                DataForVisualization = matfile(['./data/',Visualization.dataFileName,'.mat'],'Writable',true);
                
                % the variable updatedVizVariableList contains all the
                % user-selected variables names that existed in the
                % workspace at the moment that saveSimulationData has
                % been run in "update" mode. These variables are
                % assumed to be either structures, cell, scalars,
                % vectors or matrices (eventually of booleans).
                for k = 1: length(Visualization.updatedVizVariableList)
                    
                    % dimension to be concatenated
                    concatenateDim = 2;
                    currentData    = Visualization.dataForVisualization.(Visualization.updatedVizVariableList{k});
                    
                    if isstring(currentData) || ischar(currentData)
                            
                        % not easy to save them in a human-readable format
                        error('[saveSimulationData]: strings and char not supported. Use cell arrays instead.');
                    end   

                    if isvector(currentData)

                        if size(currentData,1) == 1
                           
                           % all saved vectors must be of the form [n x 1]
                           currentData = transpose(currentData);
                        end
                        
                    elseif ismatrix(currentData)
                        
                        % matrices are contatenated along a third dimension.
                        concatenateDim = 3;
                    else
                        error(['[saveSimulationData]: invalid data: ',Visualization.updatedVizVariableList{k}])
                    end
                    
                    DataForVisualization.(Visualization.updatedVizVariableList{k}) = cat(concatenateDim,DataForVisualization.(Visualization.updatedVizVariableList{k}),currentData);                  
                end
            else
                error(['[saveSimulationData]: mat-file ',Visualization.dataFileName,'.mat not found.']);
            end
        else
            error('[saveSimulationData]: Folder "data" does not exist.'); 
        end          
    else
        error('[saveSimulationData]: "mode" must be either "init" or "update".');
    end
end