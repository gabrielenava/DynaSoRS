function nDof = idyn_getNrOfDegreesOfFreedom(KinDynModel)

    % IDYN_GETNROFDEGREESOFFREEDOM gets the dimension of the joint space. 
    %
    % This matlab function wraps a functionality of the iDyntree library.                     
    % For further info see also: http://wiki.icub.org/codyco/dox/html/idyntree/html/
    %
    % FORMAT:  nDof = idyn_getNrOfDegreesOfFreedom(KinDynModel)
    %
    % INPUTS:  - KinDynModel: a structure containing the loaded model and additional info.
    %
    % OUTPUTS: - nDof: number of DoFs of the system.
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    % get the number of DoF
    nDof = KinDynModel.kinDynComp.getNrOfDegreesOfFreedom(); 
    
    % Debug output
    if KinDynModel.DEBUG
        
        disp('[idyn_getNrOfDegreesOfFreedom]: debugging outputs...')
        
        % check nDof is not empty
        if isempty(nDof)
            
            error('[idyn_getNrOfDegreesOfFreedom]: nDof is empty.')
        end
               
        disp('[idyn_getNrOfDegreesOfFreedom]: done.')     
    end
end
