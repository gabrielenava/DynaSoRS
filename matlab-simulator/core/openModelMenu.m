function modelFolderName = openModelMenu(Simulator)

    % OPENMODELMENU opens a Matlab GUI that selects the name of the folder
    %               containing the model to load.
    %
    % FORMAT:  modelFolderName = openModelMenu(Simulator)
    %
    % INPUTS:  - Simulator: simulator-specific configuration parameters:
    %                         
    %                       REQUIRED FIELDS: 
    %
    %                       - useDefaultModel: [bool];
    %                       - foldersList: [cell array of strings];
    %                       - defaultModelFolderName: [string];
    %
    % OUTPUTS: - modelFolderName: the name of the folder containing the
    %                             selected model.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    modelFolderName = [];
    
    if ~Simulator.useDefaultModel
        
        % open the GUI and select the desired model
        modelsList        = Simulator.foldersList;
        [modelNumber, ~]  = listdlg('PromptString','CHOOSE A MODEL:', ...
                                    'ListString',modelsList, ...
                                    'SelectionMode','single', ...
                                    'ListSize',[250 150]);                                
        if ~isempty(modelNumber)
       
            modelFolderName = Simulator.foldersList{modelNumber};
        end
    else
        % choose the default model
        modelFolderName = Simulator.defaultModelFolderName;
    end
end