function dataFileName = saveSimulationData(Visualization,Simulator,mode)

    % SAVESIMULATIONDATA either creates a MAT file where the simulation
    %                    results are stored, or updates an already existing 
    %                    MAT file. 
    %
    % FORMAT:  dataFileName = saveSimulationData(Visualization,Simulator,mode)
    %
    % INPUTS:  - Visualization: [struct] with plots-specific configuration parameters;
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
    %          - Simulator: [struct] with simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - modelFolderName: [string] "init" mode only;
    %                       - savedDataTag; [string] "init" model only;
    %
    %          - mode: [string] either "init" to create the MAT file or "update" to
    %                  update the already existing file.
    %
    % OUTPUTS: - dataFileName = [string] with the name of the MAT file
    %                           that has been created (mode = "init"). If
    %                           mode = 'update', this output is empty.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    dataFileName = [];
    
    if strcmp(mode,'init')
        
        if ~exist('DATA','dir')
            
            mkdir('DATA');
        end
        
        % generate the MAT file name
        dataFileName = [Simulator.modelFolderName,'_',Simulator.savedDataTag];
        
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
        save(['./DATA/',dataFileName,'.mat'],Visualization.vizVariableList{:});
        
        disp(['[saveSimulationData]: created file ','./DATA/',dataFileName,'.mat']);
    
    elseif strcmp(mode,'update')
        
        if exist('DATA','dir')
            
            if exist(['./DATA/',Visualization.dataFileName,'.mat'],'file') == 2
                
                % update the data inside the MAT file
                DataForVisualization = matfile(['./DATA/',Visualization.dataFileName,'.mat'],'Writable',true);
                
                % the variable updatedVizVariableList contains all the
                % user-selected variables names that existed in the
                % workspace at the moment that saveSimulationData has
                % been called in "update" mode. These variables are
                % assumed to be either structures, cell, scalars, 2D or 3D
                % vectors or matrices (eventually of booleans).
                for k = 1: length(Visualization.updatedVizVariableList)
                    
                    % dimension to be concatenated
                    concatenateDim = 2;
                    currentData    = Visualization.dataForVisualization.(Visualization.updatedVizVariableList{k});
                    
                    if isstring(currentData) || ischar(currentData)
                            
                        % not easy to save them in a human-readable format
                        error('[saveSimulationData]: string and char not supported. Use cell array of strings instead.');
                    end   

                    if isvector(currentData)

                        if size(currentData,1) == 1
                           
                           % all saved vectors are saved in the form [n x 1]
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
            error('[saveSimulationData]: Folder "DATA" does not exist.'); 
        end          
    else
        error('[saveSimulationData]: "mode" must be either "init" or "update".');
    end
end