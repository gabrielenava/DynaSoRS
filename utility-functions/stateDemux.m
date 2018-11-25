function varargout = stateDemux(chi,ndof,baseLinkStatus)

    % STATEDEMUX demux the system state vector. The output of the function
    %            varies if the system is fixed base or floating base.
    %
    % FORMAT:  varargout = stateDemux(chi,ndof,baseLinkStatus)
    %
    % INPUTS:  - chi: [2*ndof x 1] or [2*ndof + 13 x 1] current system state. 
    %                 Expected format: chi = [jointVel; jointPos] (fixed
    %                 base) or chi = [baseVel; jointVel; basePose; jointPos] 
    %                 (floating base). The base orientation is expressed
    %                 using quaternions;
    %          - ndof: dimension of the joint space;
    %          - baseLinkStatus: either 'fixed' for fixed base systems of
    %                            'floating' for floating base systems.
    %
    % OUTPUTS: - fixed base: [jointVel, jointPos] vector of joints
    %                        velocities and vector of joints positions;
    %          - floating base: [baseVel, jointVel, basePose, jointPos] 
    %                           - baseVel = [6 x 1] [base linear velocity;
    %                                                base angular velocity];
    %                           - basePose = [7 x 1] [base position;
    %                                                 base orientation (quat)];
    %
    % Author : Gabriele Nava (gabriele.nava@iit.it)
    % Genova, Nov 2018

    %% ------------Initialization----------------

    % either fixed base or floating base
    switch baseLinkStatus
        
        case 'fixed'
            
            jointVel     = chi(1:ndof);
            jointPos     = chi(ndof+1:end);
            
            varargout{1} = jointVel;
            varargout{2} = jointPos;
            
        case 'floating'
            
            % the base rotation is expected to be represented using quaternions
            baseVel      = chi(1:6);
            jointVel     = chi(7:ndof+6);
            basePose     = chi(ndof+7:ndof+13);
            jointPos     = chi(ndof+14:end);
            
            varargout{1} = baseVel;
            varargout{2} = jointVel;
            varargout{3} = basePose;
            varargout{4} = jointPos;
            
            % debug outputs
            if length(baseVel)~=6 || length(basePose)~=7
        
                error('[stateDemux]: baseVel and/or basePose do not have length "6/7".')
            end
            
        otherwise   
            
            error('[stateDemux]: unrecognized baseLinkStatus')
    end 
    
    % debug outputs
    if length(jointVel)~=ndof || length(jointPos)~=ndof
        
        error('[stateDemux]: jointPos and/or jointVel do not have length "ndof".')
    end
end
        