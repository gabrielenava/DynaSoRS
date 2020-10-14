function [] = createGIFfromFrames(videoName,frameRate,visualizerFrames)

    % creates a video in AVI format from a collection of frames
    for i=1:length(visualizerFrames)
          
        % generate a GIF
        RGB        = frame2im(visualizerFrames(i));
        [imind,cm] = rgb2ind(RGB,256);
                
        % write to the GIF File 
        if i == 1          
            imwrite(imind,cm,['./MEDIA/',videoName],'gif', 'Loopcount',inf,'DelayTime',1/frameRate);      
        else    
            imwrite(imind,cm,['./MEDIA/',videoName],'gif','WriteMode','append','DelayTime',1/frameRate);    
        end 
    end
end