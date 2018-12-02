function [] = runVisualizer(jointPos,w_H_b,time,fixedTimeStep,createVideo,KinDynModel,iDyntreeVisualizer,Simulator)   

    % RUNVISUALIZER runs the iDyntree visualizer. Even if the system state 
    %               has been obtained through variable-step integration, the 
    %               update rate of the visualizer is fixed and it is equal 
    %               to the user-defined variable fixedTimeStep.
    %
    % FORMAT:  [] = runVisualizer(jointPos,w_H_b,time,fixedTimeStep,createVideo,KinDynModel,iDyntreeVisualizer,Simulator) 
    %
    % INPUTS:  - jointPos: matrix of joints positions at each integration step.
    %
    %                      - CASE 1: jointPos = [ndof x numOfIterations]; 
    %                      - CASE 2: jointPos = [ndof x 1] the system will be
    %                                           considered a single rigid body;
    %
    %          - w_H_b: column-vectorization of the base-to-world transformation 
    %                   matrix at each integration time step. 
    %
    %                   - CASE 1: w_H_b = [16 x numOfIterations];
    %                   - CASE 2: w_H_b = [16 x 1] the system will be
    %                                     considered fixed-base;
    %
    %          - time: integration time vector. It must always be defined such 
    %                  that length(time) = max(size(jointPos,2),size(w_H_b,2))
    %
    %          - fixedTimeStep: the visualizer time step. 
    %          - createVideo: if TRUE, a video of the simulation will be created.
    %          - KinDynModel: a structure containing the loaded model and additional info.
    %          - iDyntreeVisualizer: iDyntree visualizer-specific configuration parameters;
    %
    %                                REQUIRED FIELDS: 
    %
    %                                - debug: [bool];
    %                                - cameraPos: [3 x 1] [double];   
    %                                - cameraTarget: [3 x 1] [double];
    %                                - lightDir: [3 x 1] [double];
    %                                - disableViewInertialFrame: [bool];
    %
    %          - Simulator: simulator-specific configuration parameters;
    %
    %                       REQUIRED FIELDS: 
    %
    %                       - modelFolderName: [string];
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    disp('[runVisualizer]: running the iDyntree visualizer.');
    
    % debug input vector size
    if size(jointPos,1) ~= KinDynModel.NDOF
        
        error('[runVisualizer]: invalid joint position vector.');
    end
    if size(w_H_b,1) ~= 16
        
        error('[runVisualizer]: invalid base pose vector.');
    end
    if fixedTimeStep <= 0
        
        error('[runVisualizer]: fixedTimeStep must be strictly positive.');
    end
    if length(time) ~= max(size(jointPos,2),size(w_H_b,2))
       
        error('[runVisualizer]: time vector must have length = max(size(jointPos,2),size(w_H_b,2)).');
    end
    if time(end) <= fixedTimeStep
        
        error('[runVisualizer]: time(end) must be greater than fixedTimeStep.');
    end
        
    % create the media folder for storing videos of the robot simulation
    if createVideo     
        if ~exist('./media', 'dir')
            mkdir('./media');
        end
        disp('[runVisualizer]: createVideo option enabled. Trying to create a video of the simulation...'); 
        disp('[runVisualizer]: creating the video will considerably slow down the simulation!');
    end
    
    % create the vector of fixed time step
    if length(time) > 1

        time_fixed = time(1):fixedTimeStep:time(end);
    else
        time_fixed = 0:fixedTimeStep:time;
    end 

    % interpolate the system state according to the fixed time step
    interp_jointPos = zeros(size(jointPos));
    interp_w_H_b    = zeros(size(w_H_b));
    
    if size(jointPos,2) > 1
            
        for k = 1:size(jointPos,1)
                
            interp_jointPos(k,:) = interp1(time,jointPos(k,:),time_fixed); 
        end
    else
        interp_jointPos = jointPos.*ones(size(jointPos,1),length(time_fixed));
    end
    
    if size(w_H_b,2) > 1
                
        % interpolation of the transformation matrix requires
        % special calculations, as the interpolated values must
        % belong to the group SO(3)
        % TODO 
    else
        interp_w_H_b = w_H_b.*ones(size(w_H_b,1),length(time_fixed));
    end

    % start the visualizer
    Visualizer               = idyn_initializeVisualizer(KinDynModel,iDyntreeVisualizer.debug);

    % user defined visualization options
    cameraPos                = iDyntreeVisualizer.cameraPos;
    cameraTarget             = iDyntreeVisualizer.cameraTarget;
    lightDir                 = iDyntreeVisualizer.lightDir;
    disableViewInertialFrame = iDyntreeVisualizer.disableViewInertialFrame;

    idyn_visualizerSetup(Visualizer,disableViewInertialFrame,lightDir,cameraPos,cameraTarget);
    
    % compute simulator real time factor
    c_in  = clock;

    for i = 1:length(time_fixed)

        tic
       
        w_H_b_viz    = reshape(interp_w_H_b(:,i),4,4);
        jointPos_viz = interp_jointPos(:,i); 
            
        % update the visualizer
        idyn_updateVisualizer(Visualizer,KinDynModel,jointPos_viz,w_H_b_viz);
        
        % create a .mp4 video from of the iDyntree simulation
        if createVideo 
            filename = strcat('./media/img',sprintf('%04d',i),'.png');         
            Visualizer.viz.drawToFile(filename);         
        end 
        
        t = toc;
        
        pause(max(0,fixedTimeStep-t))
    end  
    
    % compute the simulator real time factor
    c_out           = clock;
    c_diff          = getTimeDiffInSeconds(c_in,c_out);
    expectedEndTime = time_fixed(end); %[s]
    realTimeFactor  = expectedEndTime/c_diff;
    
    disp(['[runVisualizer]: simulation real time factor: ', num2str(realTimeFactor),'.']);
    
    if createVideo   
        
        videoName = [Simulator.modelFolderName,'_',num2str(c_out(4)),'_',num2str(c_out(5))];     

        command   = strcat('ffmpeg -framerate 60 -i ./media/img%04d.png -c:v libx264 -r 30 -pix_fmt yuv420p ./media/',videoName,'.mp4'); 
        [~, ~]    = system(command);

        disp('[runVisualizer]: video created. Removing images...');      
    
        command   = strcat('rm -Rf ./media/*.png'); 
        [~, ~]    = system(command);
 
        disp('[runVisualizer]: done.'); 
   end
end