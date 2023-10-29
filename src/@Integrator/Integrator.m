classdef Integrator < handle
    % INTEGRATOR wraps different numerical integration methods.
    %
    %            Currently available methods:
    %              - Euler forward
    %              - ode15s
    %              - ode23t
    %              - ode45
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties

        init_state;
        integr_opt;
        integr_fcn;
        solver_opt;
        input_ctrl;
    end

    methods
        function obj = Integrator(init_state, integr_fcn, integr_opt, varargin)

            % Construct an instance of this class
            obj.init_state = init_state;
            obj.integr_opt = integr_opt;
            obj.integr_fcn = integr_fcn;
            obj.input_ctrl = [];

            switch nargin

                case 4

                    % the user-specified options for the solver
                    obj.solver_opt = varargin{1};

                otherwise
                    obj.solver_opt = [];
            end
        end

        % --------------------------------------------------------------- %
        function [time, state] = solve(obj)

            % identify the solver type
            solver_type = obj.integr_opt.solver_type;

            % Choose the solver
            switch solver_type

                case 'euler'

                    % solver options not available here
                    [time, state] = eulerForward(obj);

                case 'ode15s'

                    [time, state] = ode15s(obj.integr_fcn, obj.integr_opt.t_init:obj.integr_opt.t_step:obj.integr_opt.t_end, ...
                        obj.init_state, obj.solver_opt);

                case 'ode23t'

                    [time, state] = ode23t(obj.integr_fcn, obj.integr_opt.t_init:obj.integr_opt.t_step:obj.integr_opt.t_end, ...
                        obj.init_state, obj.solver_opt);

                case 'ode45'

                    [time, state] = ode45(obj.integr_fcn, obj.integr_opt.t_init:obj.integr_opt.t_step:obj.integr_opt.t_end, ...
                        obj.init_state, obj.solver_opt);

                otherwise
                    error('Integration method not available.')
            end
        end

        % --------------------------------------------------------------- %
        function [time, state] = solveStepByStep(obj, varargin)

            % SOLVESTEPBYSTEP solves numerical integration step by step.
            %                 This means that the solver integrates for the
            %                 user-defined time step, then the solver is
            %                 stopped and the integration restarted for
            %                 another time step with new initial conditions.
            %                 An external function can be passed to the
            %                 method and it will be called in between steps.
            %

            % initialize values that are going to be changed at each iteration
            initState = obj.init_state;
            t_init    = obj.integr_opt.t_init;
            t_end     = obj.integr_opt.t_end;
            integrFcn = obj.integr_fcn;
            n_iter    = 0;
            time      = [];
            state     = [];

            switch nargin

                case 2

                    % initialize in-steps function
                    inStepFcn      = varargin{1};
                    obj.input_ctrl = inStepFcn(t_init, initState);
                otherwise
                    inStepFcn = [];
            end

            % update t_end as the time duration of the initial step
            obj.integr_opt.t_end = t_init + obj.integr_opt.t_step;

            while obj.integr_opt.t_end < t_end && n_iter < obj.integr_opt.max_n_iter

                % integrate one step
                [time_k, state_k] = obj.solve();

                if ~isempty(inStepFcn)

                    % call to the in-between-steps function. Default
                    % format: u = fcn(t, x, params). Your forward dynamics
                    % function must then be of the form:
                    %
                    %   dx = fcn(t, x, obj.input_ctrl, params)
                    %
                    % to receive the updated u correctly
                    %
                    obj.input_ctrl = inStepFcn(time_k(end), transpose(state_k(end,:)));
                end

                % save the state and time
                time  = [time; time_k(1:end-1)];     %#ok<AGROW>
                state = [state; state_k(1:end-1,:)]; %#ok<AGROW>

                % update time and init state
                obj.init_state        = state_k(end,:);
                obj.integr_opt.t_init = time_k(end);
                obj.integr_opt.t_end  = obj.integr_opt.t_init + obj.integr_opt.t_step;
                n_iter                = n_iter + 1;
            end

            % restore original values of time and init conditions, for
            % consistency with the values set by the user
            obj.init_state        = initState;
            obj.integr_opt.t_init = t_init;
            obj.integr_opt.t_end  = t_end;
            obj.integr_fcn        = integrFcn;

            if n_iter >= obj.integr_opt.max_n_iter
                warning('Max number of iteration reached: exit while loop for safety.');
            end
        end

        % --------------------------------------------------------------- %
        function [time, state] = eulerForward(obj)

            % implement forward Euler numerical integration
            time       = obj.integr_opt.t_init:obj.integr_opt.t_step:obj.integr_opt.t_end;
            state      = zeros(length(time), length(obj.init_state));
            state(1,:) = obj.init_state;

            for k = 2:length(time)

                state(k,:) = state((k-1),:) + obj.integr_opt.t_step*obj.integr_fcn(time(k), state((k-1),:)')';
            end
        end
    end
end
