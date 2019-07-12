function [] = runVisualizer(jointPos,w_H_b,time,createVideo,KinDynModel,iDyntreeVisualizer,Simulator)   

    % RUNVISUALIZER runs the iDyntree visualizer. Even if the system state 
    %               has been obtained through variable-step integration, the 
    %               update rate of the visualizer is adjusted accordingly.
    %
    % FORMAT:  [] = runVisualizer(jointPos,w_H_b,time,createVideo,KinDynModel,iDyntreeVisualizer,Simulator) 
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
    %          - time: [s] integration time vector. It must always be defined such 
    %                  that length(time) = max(size(jointPos,2),size(w_H_b,2))
    %
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
    %                       - savedDataTag: [string];
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
    if length(time) ~= max(size(jointPos,2),size(w_H_b,2))
       
        error('[runVisualizer]: time vector must have length = max(size(jointPos,2),size(w_H_b,2)).');
    end
    if sum(time < 0) ~= 0 || time(end) <= 0
        
        error('[runVisualizer]: time must be positive.');
    end
        
    % create the media folder for storing videos of the robot simulation
    if createVideo     
        if ~exist('./MEDIA', 'dir')
            mkdir('./MEDIA');
        end
        disp('[runVisualizer]: createVideo option is enabled. Trying to create a video of the simulation...'); 
        disp('[runVisualizer]: WARNING: creating the video will considerably slow down the simulation!');
    end

    % start the visualizer
    Visualizer               = iDynTreeWrappers.initializeVisualizer(KinDynModel,iDyntreeVisualizer.debug);

    % user defined visualization options
    cameraPos                = iDyntreeVisualizer.cameraPos;
    cameraTarget             = iDyntreeVisualizer.cameraTarget;
    lightDir                 = iDyntreeVisualizer.lightDir;
    disableViewInertialFrame = iDyntreeVisualizer.disableViewInertialFrame;

    iDynTreeWrappers.visualizerSetup(Visualizer,disableViewInertialFrame,lightDir,cameraPos,cameraTarget);
    
    % compute simulator real time factor
    c_in = clock;

    for i = 1:length(time)

        tic
       
        if size(w_H_b,2) == 1
           
            w_H_b_viz    = reshape(w_H_b(:,1),4,4);
        else    
            w_H_b_viz    = reshape(w_H_b(:,i),4,4);
        end
        if size(jointPos,2) == 1
            
            jointPos_viz = jointPos(:,1); 
        else
            jointPos_viz = jointPos(:,i); 
        end
            
        % update the visualizer
        iDynTreeWrappers.updateVisualizer(Visualizer,KinDynModel,jointPos_viz,w_H_b_viz);
        
        % create a .mp4 video from of the iDyntree simulation
        if createVideo 
            filename = strcat('./MEDIA/img',sprintf('%04d',i),'.png');         
            Visualizer.viz.drawToFile(filename);         
        end 
        
        t = toc;
        
        if i < length(time)
            
            pause(max(0,time(i+1)-time(i)-t))
            
        elseif length(time) == 1
            
            % the visualizer is used to just show a static system pose for 
            % the amount of time specified in the "time" variable
            pause(max(0,time-t))
        end       
    end  
    
    % compute the simulator real time factor
    c_out           = clock;
    c_diff          = getTimeDiffInSeconds(c_in,c_out);
 
    if length(time) > 1
        
        expectedEndTime = time(end)-time(1); % normalize
    else
        expectedEndTime = time;
    end

    realTimeFactor  = expectedEndTime/c_diff;
    
    disp(['[runVisualizer]: simulation real time factor: ', num2str(realTimeFactor),'.']);
    
    if createVideo   
        
        videoName = [Simulator.modelFolderName,'_',Simulator.savedDataTag];     

        command   = strcat('ffmpeg -framerate 60 -i ./MEDIA/img%04d.png -c:v libx264 -r 30 -pix_fmt yuv420p ./MEDIA/',videoName,'.mp4'); 
        [~, ~]    = system(command);

        disp(['[runVisualizer]: video ',Simulator.modelFolderName,'_',Simulator.savedDataTag,'.mp4 created. Removing images...']);      
    
        command   = strcat('rm -Rf ./MEDIA/*.png'); 
        [~, ~]    = system(command);
 
        disp('[runVisualizer]: done.'); 
   end
end
