function [time, state] = integrateForwardDynamics(forwardDynamicsFCN, state_0, tStart, tStep, tEnd)

time       = tStart:tStep:tEnd;
state      = zeros(length(time), length(state_0));
state(1,:) = state_0;

for k = 2:length(time)
    
    % forward Euler integration
    state(k,:) = state((k-1),:) + tStep*forwardDynamicsFCN(time(k), state((k-1),:)')'; 
end
end
