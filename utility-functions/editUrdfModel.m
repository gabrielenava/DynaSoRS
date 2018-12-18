function [] = editUrdfModel(oldModelPath, oldModelName, newModelPath, newModelName, textToReplace, newText)

    % EDITURDFMODEL allows to edit a urdf model from Matlab. It is possible
    %               to look for a specific text inside the urdf and replace
    %               it with a new one. Also, it is possible to overwrite
    %               the original model as well as create a new model.
    %
    % FORMAT:  [] = editUrdfModel(oldModelPath, oldModelName, newModelPath, newModelName, textToReplace, newText)
    %
    % INPUTS:  - oldModelPath = [string] the path to the original model;
    %          - oldModelName = [string] the name of the original model;
    %          - newModelPath = [string] the path to the new model;
    %          - newModelName = [string] the name of the new model;
    %          - textToReplace = [string] the text to be replaced;
    %          - newText = [string] the new text to write in the file.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Dec 2018

    %% ------------Initialization----------------

    % open the original model
    fid = fopen([oldModelPath, oldModelName], 'rt');

    % scan the entire file
    cell_urdf = textscan(fid, '%s', 'delimiter', '\n');
    somethingHasBeenModified = false;

    % search for the text to replace inside the urdf file
    for k = 1:length(cell_urdf{1})
    
        index_start_absolute_path = strfind(cell_urdf{1}{k},textToReplace);
        
        if ~isempty(index_start_absolute_path)
            
            cell_urdf{1}{k} = [cell_urdf{1}{k}(index_start_absolute_path-1), newText, cell_urdf{1}{k}(length(textToReplace)-1)];
            somethingHasBeenModified = true;
        end
    end
    
    % if nothing has been modified, print a warning message
    if ~somethingHasBeenModified
        
        warning('[editUrdfModel]: nothing has been modified!')
    end

    % close the full model
    fclose(fid);

    % write the cell_urdf into a new urdf file that will be used in the optimization
    fid2 = fopen([newModelPath, newModelName], 'w');

    for i = 1:numel(cell_urdf{1})

        fprintf(fid2,'%s\n', cell_urdf{1}{i});
    end
    
    if strcmp(newModelPath,oldModelPath) && strcmp(newModelName,oldModelName)
        
        % overwriting the original model
        disp(['[editUrdfModel]: edited model ',newModelPath, newModelName])
    else
        % new model has been created
        disp(['[editUrdfModel]: created new model ',newModelPath, newModelName])
    end
    
    fclose(fid2);
end