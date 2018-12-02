function foldersList = getFoldersList(parentfolderName)

    % GETFOLDERSLIST creates a list of all the folders contained inside a
    %                parent folder.
    %
    % FORMAT:  foldersList = getFoldersList(parentfolderName)
    %
    % INPUTS:  - parentfolderName: the name of the parent folder;
    %
    % OUTPUTS: - foldersList: cell array containing the names of the child
    %                         folders.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % check if the parent folder exists
    if ~exist(parentfolderName,'dir')
        
        error('[createFoldersList]: the parent folder does not exist.')
    end
    
    modelFolders = dir(parentfolderName);
    foldersList  = {};
    cont         = 1;

    for k = 1:size(modelFolders,1)
    
        % avoid the trivial folders '.' and '..'
        if ~strcmp(modelFolders(k).name,'.') && ~strcmp(modelFolders(k).name,'..')
        
            foldersList{cont} = modelFolders(k).name; %#ok<AGROW>
            cont = cont + 1;
        end
    end
end