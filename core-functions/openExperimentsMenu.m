function experimentName = openExperimentsMenu(experimentFolder)

    % OPENEXPERIMENTSMENU opens a Matlab GUI that allows to select the 
    %                     available experiments data (MAT file format).
    %
    % FORMAT:  experimentName = openExperimentsMenu(experimentFolder)
    %
    % INPUTS:  - experimentFolder [string]: the path to the experiment folder;
    %
    % OUTPUTS: - experimentName [string]: the selected MAT file.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2020

    %% ------------Initialization----------------
    
    experimentStruct = dir([experimentFolder,'*mat']);
    experimentList   = {};
    
    for k = 1:length(experimentStruct)
       
        experimentList{k} = experimentStruct(k).name; %#ok<AGROW>
    end
         
    % open the GUI and select the experiments from list
    [experimentsNumber,~] = listdlg('PromptString', 'Choose the experiments to play back:', ...
                                    'ListString', experimentList, ...
                                    'SelectionMode', 'single', ...
                                    'ListSize', [250 150]);                                
    if ~isempty(experimentsNumber)
       
        experimentName = experimentList{experimentsNumber};
    else
        % no experiments selected
        experimentName = {};
    end
end
