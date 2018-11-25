function [] = idyn_visualizerSetup(Visualizer,disableViewInertialFrame,lightDir,cameraPos,cameraTarget)

    % IDYN_VISUALIZERSETUP modifies the visualization environment according to the 
    %                      user specifications.
    %
    % This matlab function wraps a functionality of the iDyntree library.                     
    % For further info see also: http://wiki.icub.org/codyco/dox/html/idyntree/html/
    %
    % REQUIREMENTS: compile iDyntree with Irrlicht (IDYNTREE_USES_IRRLICHT = ON).
    %
    % FORMAT:  [] = idyn_visualizerSetup(Visualizer,disableViewInertialFrame,lightDir,cameraPos,cameraTarget)
    %
    % INPUTS:  - Visualizer: a structure containing the visualizer and its options.
    %          - disableViewInertialFrame: boolean for disabling the view of the 
    %                                      inertial frame;
    %          - lightDir: [3 x 1] vector describing the light direction;
    %          - cameraPos: [3 x 1] vector describing the camera position;
    %          - cameraTarget: [3 x 1] vector describing the camera target;
    % 
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------
    
    % disable environmental features  
    if disableViewInertialFrame
        
        enviroment = Visualizer.viz.enviroment();  
        ack        = enviroment.setElementVisibility('root_frame',false);   
        
        % check for errors
        if ~ack
            error('[idyn_visualizerSetup]: unable to disable the inertial frame view.')
        end         
    end
    
    % set lights
    sun = Visualizer.viz.enviroment().lightViz('sun');     
    lightDir_idyntree = iDynTree.Direction();     
    lightDir_idyntree.fromMatlab(lightDir); 
    sun.setDirection(lightDir_idyntree);

    % set camera     
    cam = Visualizer.viz.camera();     
    cam.setPosition(iDynTree.Position(cameraPos(1),cameraPos(2),cameraPos(3)));     
    cam.setTarget(iDynTree.Position(cameraTarget(1),cameraTarget(2),cameraTarget(3)));    
    
    % draw the model
    Visualizer.viz.draw();
end
