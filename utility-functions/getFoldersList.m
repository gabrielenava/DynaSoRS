function foldersList = getFoldersList(parentfolderName)

    % GETFOLDERSLIST creates a list of all the folders contained inside a
    %                parent folder.
    %
    % FORMAT:  foldersList = getFoldersList(parentfolderName)
    %
    % INPUTS:  - parentfolderName: [string] the name of the parent folder;
    %
    % OUTPUTS: - foldersList: [cell array of strings] containing the names 
    %                         of the child folders.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % check if the parent folder exists
    if ~exist(parentfolderName,'dir')
        
        error('[getFoldersList]: parent folder not found.')
    end
    
    childFolders = dir(parentfolderName);
    foldersList  = {};
    cont         = 1;

    for k = 1:size(childFolders,1)
    
        % avoid the trivial folders '.' and '..'
        if ~strcmp(childFolders(k).name,'.') && ~strcmp(childFolders(k).name,'..')
        
            % avoid non-folders
            if childFolders(k).isdir
                
                foldersList{cont} = childFolders(k).name; %#ok<AGROW>
                cont = cont + 1;
            end
        end
    end
end
