function [] = createAVIfromFrames(videoName,frameRate,visualizerFrames)     
         
    % creates a video in AVI format from a collection of frames
    writerObj = VideoWriter(['./MEDIA/',videoName]);
        
    % set user-defined frame rate
    writerObj.FrameRate = frameRate;       
    open(writerObj);

    for i=1:length(visualizerFrames)
          
        % convert the image to a frame  
        writeVideo(writerObj, visualizerFrames(i));
    end

    close(writerObj);
end