function [demoFolderName,demoScriptName] = openSimulationMenu(Model,Simulator)

    % OPENSIMULATIONMENU opens a Matlab GUI for selecting the simulation
    %                    script and folder, or selects the default simulation.
    %
    % FORMAT:  [demoFolderName,demoScriptName] = openSimulationMenu(Model,Simulator)
    %
    % INPUTS:  - Model: [struct] with model-specific configuration parameters;
    %                  
    %                   REQUIRED FIELDS: 
    %
    %                   - simulationList: [cell array of strings];
    %                   - demoFolderList: [cell array of strings];
    %                   - defaultSimulation: [string];
    %                   - defaultDemoFolder: [string];
    %
    %          - Simulator: [struct] with simulator-specific configuration parameters;
    %         
    %                       REQUIRED FIELDS: 
    %
    %                       - runDefaultSimulation: [bool];
    %    
    % OUTPUTS: - demoFolderName: [string] the name of the folder containing
    %                            the selected demo.
    %
    %          - demoScriptName: [string] the name of the script for running
    %                            the selected demo.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    demoFolderName = [];
    demoScriptName = [];
    
    % open the GUI and select the desired simulation
    if ~Simulator.runDefaultSimulation
  
        [simulationNumber, ~] = listdlg('PromptString', 'Choose a simulation:', ...
                                        'ListString', Model.simulationList, ...
                                        'SelectionMode', 'single', ...
                                        'ListSize', [250 150]);                                
        if ~isempty(simulationNumber)
       
            demoFolderName = Model.demoFolderList{simulationNumber};
            demoScriptName = Model.simulationList{simulationNumber};
        end
    else
        % choose the default simulation
        demoFolderName = Model.defaultDemoFolder;
        demoScriptName = Model.defaultSimulation;
    end
end