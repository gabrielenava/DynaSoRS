classdef OptiQPCasadi < handle
    % OPTIQPCASADI wraps the Casadi-MATLAB bindings to set up Quadratic
    %              Programming optimization.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties
        sol
        options
        parameters
        variables
        casadi_optimizer
    end

    methods
        function obj = OptiQPCasadi()

            % set default options. Only QP is allowed for this class
            obj.options.optimization_type = 'conic';
            obj.options.solver            = 'osqp';
            obj.options.plugin_options    = struct('expand',true);
            obj.options.solver_options    = struct();
            obj.casadi_optimizer          = casadi.Opti(obj.options.optimization_type);

            obj.casadi_optimizer.solver(obj.options.solver, obj.options.plugin_options, obj.options.solver_options);
        end

        function [] = addOptiVariable(obj, name, size)

            % add a new optimization variables
            obj.variables.(name) = obj.casadi_optimizer.variable(size);
        end
        function [] = addParameter(obj, name, size)

            % add a new parameter
            obj.parameters.(name) = obj.casadi_optimizer.parameter(size);
        end
        function [] = setInitConditions(obj, name, initCond)

            obj.casadi_optimizer.set_initial(obj.variables.(name),initCond);
        end
        function [] = setBounds(obj, name, x_min, x_max)

            % for now, the bounds must be objects of the class Casadi.MX.
            % Use obj.addparameter() to easily create them
            obj.casadi_optimizer.subject_to(obj.variables.(name) <= x_max);
            obj.casadi_optimizer.subject_to(obj.variables.(name) >= x_min);
        end
        function [] = setLinearInequality(obj, name, B, y_min, y_max)

            % for now, y_max and y_min must be objects of the class Casadi.MX.
            % Use obj.addparameter() to easily create them
            obj.casadi_optimizer.subject_to(B*obj.variables.(name) <= y_max);
            obj.casadi_optimizer.subject_to(B*obj.variables.(name) >= y_min);
        end
        function [] = setLinearEquality(obj, name, B, y)

            % for now, y must be objects of the class Casadi.MX. Use
            % obj.addparameter() to easily create it
            obj.casadi_optimizer.subject_to(B*obj.variables.(name) == y);
        end
        function [] = setObjectiveFcn(obj, fcn)

            % the input is a function handle with variable set using
            % Casadi.MX. class
            obj.casadi_optimizer.minimize(fcn);
        end
        function [] = updateParameter(obj, name, value)

            % update a parameter
            obj.casadi_optimizer.set_value(obj.parameters.(name), value);
        end
        function u_star = solve(obj)

            % compute the solution of the QP problem
            try
                obj.sol = obj.casadi_optimizer.solve();
                u_star  = obj.sol.value(obj.casadi_optimizer.x);

                % set the initial state of the optimizer to the optimal
                % solution found in the previous iteration by the solver
                obj.casadi_optimizer.set_initial(obj.casadi_optimizer.x, obj.sol.value(obj.casadi_optimizer.x));

            catch exception
                try
                    obj.casadi_optimizer.debug.show_infeasibilities;
                    disp(exception.getReport)
                catch
                    disp(exception.message)
                end
            end
        end
        function u_star = getOptimalValue(obj, name)

            % to be run after obj.solve() is called. Retuns the optimal
            % value of the selected variable
            if ~isempty(obj.sol)
                u_star = obj.sol.value(obj.variables.(name));
            else
                u_star = [];
            end
        end
    end
end
