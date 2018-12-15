function modelFolderName = openModelMenu(Simulator)

    % OPENMODELMENU opens a Matlab GUI that allows to select the model folder
    %               between the folders containing the available urdf models.
    %
    % FORMAT:  modelFolderName = openModelMenu(Simulator)
    %
    % INPUTS:  - Simulator: [struct] with simulator-specific configuration parameters.
    %                         
    %                       REQUIRED FIELDS: 
    %
    %                       - useDefaultModel: [bool];
    %                       - modelFoldersList: [cell array of strings];
    %                       - defaultModelFolderName: [string];
    %
    % OUTPUTS: - modelFolderName: [string] the name of the folder containing
    %                             the model to load.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    modelFolderName = [];
    
    if ~Simulator.useDefaultModel
        
        % open the GUI and select the model folder
        [folderNumber,~] = listdlg('PromptString', 'Choose a model folder:', ...
                                   'ListString', Simulator.modelFoldersList, ...
                                   'SelectionMode', 'single', ...
                                   'ListSize', [250 150]);                                
        if ~isempty(folderNumber)
       
            modelFolderName = Simulator.modelFoldersList{folderNumber};
        end
    else
        % choose the default model
        modelFolderName = Simulator.defaultModelFolderName;
    end
end