function J_frameVel = idyn_getRelativeJacobian(KinDynModel,frameVel,frameRef)

    % IDYN_GETRELATIVEJACOBIAN gets the relative jacobian, i.e. the matrix that
    %                          maps the velocity of frameVel expressed w.r.t.
    %                          frameRef, to the joint velocity. 
    %
    % This matlab function wraps a functionality of the iDyntree library.                     
    % For further info see also: http://wiki.icub.org/codyco/dox/html/idyntree/html/
    %
    % FORMAT:  J_frameVel = idyn_getRelativeJacobian(KinDynModel,frameVel,frameRef)
    %
    % INPUTS:  - frameRef: a string that specifies the frame w.r.t. the velocity
    %                      of frameVel is expressed;
    %          - frameVel: a string that specifies the frame whose velocity
    %                      is the one mapped by the jacobian;
    %          - KinDynModel: a structure containing the loaded model and additional info.
    %
    % OUTPUTS: - J_frameVel: [6 x ndof] frameVel Jacobian.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    % create the matrix that must be populated with the jacobian map
    J_frameVel_iDyntree = iDynTree.MatrixDynSize(6,KinDynModel.NDOF);
    
    % get the relative jacobian
    ack = KinDynModel.kinDynComp.getRelativeJacobian(frameVel,frameRef,J_frameVel_iDyntree);  
    
    % check for errors
    if ~ack  
        error('[idyn_getRelativeJacobian]: unable to get the relative jacobian from the reduced model.')
    end
    
    % covert to Matlab format
    J_frameVel = J_frameVel_iDyntree.toMatlab; 
end
