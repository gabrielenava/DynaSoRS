function [] = idyn_setFrameVelocityRepresentation(KinDynModel,frameVelRepr)

    % IDYN_SETFRAMEVELOCITYREPRESENTATION sets the frame velocity representation.
    %
    % This matlab function wraps a functionality of the iDyntree library.                     
    % For further info see also: http://wiki.icub.org/codyco/dox/html/idyntree/html/
    %
    % FORMAT: [] = idyn_setFrameVelocityRepresentation(KinDynModel,frameVelRepr)
    %
    % INPUTS:  - frameVelRepr: a string with one of the following values:
    %                          'mixed', 'body', 'inertial';
    %          - KinDynModel: a structure containing the loaded model and additional info.
    %
    % Mapping for the frame velocity reperesentation
    %
    %  0 = INERTIAL_FIXED_REPRESENTATION
    %
    %  1 = BODY_FIXED_REPRESENTATION
    %
    %  2 = MIXED_REPRESENTATION
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    switch frameVelRepr
        
        case 'mixed'
            
            frameVelRepr_idyntree = iDynTree.MIXED_REPRESENTATION;
                    
        case 'body'
            
            frameVelRepr_idyntree = iDynTree.BODY_FIXED_REPRESENTATION;
                    
        case 'inertial'
            
            frameVelRepr_idyntree = iDynTree.INERTIAL_FIXED_REPRESENTATION;
                    
        otherwise        
            error('[idyn_setFrameVelocityRepresentation]: frameVelRepr is not a valid string.')
    end
             
    % set the desired frameVelRepr
    ack = KinDynModel.kinDynComp.setFrameVelocityRepresentation(frameVelRepr_idyntree);
    
    % check for errors
    if ~ack    
        error('[idyn_setFrameVelocityRepresentation]: unable to set the frame velocity representation.')
    end
end