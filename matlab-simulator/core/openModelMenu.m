function modelFolderName = openModelMenu(Simulator)

    % OPENMODELMENU opens a Matlab GUI that allows to select between the
    %               folders containing the urdf models.
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
        
        % open the GUI and select the model folder
        foldersList      = Simulator.foldersList;
        [folderNumber,~] = listdlg('PromptString', 'Choose a model folder:', ...
                                   'ListString', foldersList, ...
                                   'SelectionMode', 'single', ...
                                   'ListSize', [250 150]);                                
        if ~isempty(folderNumber)
       
            modelFolderName = Simulator.foldersList{folderNumber};
        end
    else
        % choose the default model
        modelFolderName = Simulator.defaultModelFolderName;
    end
end