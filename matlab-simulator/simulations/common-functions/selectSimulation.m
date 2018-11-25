function [] = selectSimulation(Config)

    % SELECTSIMULATION opens a Matlab GUI allowing for selecting the
    %                  simulation to run, or directly runs the default
    %                  simulation.
    %
    % FORMAT:  [] = selectSimulation(Config)
    %
    % INPUTS:  - Config: simulation-specific configuration parameters;
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % open the GUI and select the desired simulation
    if Config.initModel.useStaticGui
    
        simulationsList        = Config.initModel.simulationList;
        [simulationNumber, ~]  = listdlg('PromptString', 'Choose a simulation:', ...
                                         'ListString', simulationsList, ...
                                         'SelectionMode', 'single', ...
                                         'ListSize', [250 150]);                                
        if ~isempty(simulationNumber)
       
            disp(['[selectSimulation]: running ', Config.initModel.demoFolderList{simulationNumber},' demo.'])
            addpath(['./simulations/',Config.initModel.demoFolderList{simulationNumber}])
            run(Config.initModel.simulationList{simulationNumber}); 
            rmpath(['./simulations/',Config.initModel.demoFolderList{simulationNumber}])
        end
    else
        % choose the default simulation
        disp(['[selectSimulation]: running ', Config.initModel.defaultSimulation,' demo.'])
        addpath(['./simulations/',Config.initModel.defaultDemoFolder])
        run(Config.initModel.defaultSimulation); 
        rmpath(['./simulations/',Config.initModel.defaultDemoFolder])
    end
end