function [] = runVisualizerFixedBase(chi_matr,KinDynModel,Config)   

    % RUNVISUALIZERFIXEDBASE starts the visualizer for fixed base models.
    %                        The update rate of the visualizer is fixed and
    %                        equal to the user defined tStep.
    %
    % FORMAT: [] = runVisualizerFixedBase(chi_matr,KinDynModel,Config)
    %
    % INPUTS:  - chi_matr: [timeInstants x 2*ndof] system state at each 
    %                      integration step.
    %          - KinDynModel: a structure containing the loaded model and 
    %                         additional info.
    %          - Config: simulation-specific configuration parameters;
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    % start the visualizer
    Visualizer               = idyn_initializeVisualizer(KinDynModel,Config.visualizer.debug);

    % user defined visualization options
    cameraPos                = Config.visualizer.cameraPos;
    cameraTarget             = Config.visualizer.cameraTarget;
    lightDir                 = Config.visualizer.lightDir;
    disableViewInertialFrame = Config.visualizer.disableViewInertialFrame;
    w_H_b_fixed              = Config.visualizer.w_H_b_fixed;

    idyn_visualizerSetup(Visualizer,disableViewInertialFrame,lightDir,cameraPos,cameraTarget);

    for i = 1:size(chi_matr,1)

        tic
        
        % demux the system state
        [~, jointPos] = stateDemux(chi_matr(i,:),KinDynModel.NDOF,'fixed');
        
        % update the visualizer
        idyn_updateVisualizer(Visualizer,KinDynModel,jointPos,w_H_b_fixed);
        
        t = toc;
        
        pause(max(0,Config.integration.tStep-t))
    end    
end