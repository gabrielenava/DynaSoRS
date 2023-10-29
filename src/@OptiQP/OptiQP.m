classdef OptiQP < handle
    % OPTIQP wraps Quadratic Programming optimization with OSQP and QUADPROG
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties
        opti_type
        solver
        variables
    end

    methods
        function obj = OptiQP(opti_type)

            obj.opti_type      = opti_type;
            obj.variables.H    = [];
            obj.variables.g    = [];
            obj.variables.A    = [];
            obj.variables.b    = [];
            obj.variables.Aeq  = [];
            obj.variables.beq  = [];
            obj.variables.lb   = [];
            obj.variables.ub   = [];
            obj.variables.x0   = [];
            obj.variables.opts = optimoptions('quadprog','Display','off');

            switch obj.opti_type

                case 'osqp'

                    obj.solver = osqp();

                case 'quadprog'

                    obj.solver = [];

                otherwise
                    error('opti_type not recognized.')
            end
        end

        function [] = setup(obj, var)

            % setup QP problem for OSQP
            switch obj.opti_type

                case 'osqp'
                    % OSQP variables mapping:
                    %
                    % P = var.H
                    % q = var.g
                    % A = var.A
                    % l = var.lb
                    % u = var.ub
                    %
                    % other variables are ignored
                    %
                    obj.solver = osqp();
                    obj.solver.setup(var.H, var.g, var.A, var.lb, var.ub, 'alpha', 1);
            end

            % setup opti variables
            obj.update(var);
        end

        function [] = update(obj, var)

            % update opti variables. If the user does not specify some of
            % the fields, default values are used
            variables_names = fieldnames(var);

            for k = 1:length(variables_names)

                obj.variables.(variables_names{k}) = var.(variables_names{k});
            end

            % update QP problem for OSQP
            switch obj.opti_type

                case 'osqp'
                    % WARNING! calling solver.setup instead of solver.update
                    %
                    % something is strange when calling solver.update: it
                    % does not work always. For the moment, sticking to the
                    % use of solver.setup which has been verified to work.
                    %
                    % for the record, the call to solver.update would be:
                    %
                    %   obj.solver.update('Px', nonzeros(triu(obj.variables.H)), 'q', obj.variables.g, ...
                    %                     'Ax', nonzeros(obj.variables.A), 'l', obj.variables.lb, ...
                    %                     'u', obj.variables.ub);
                    %
                    obj.solver = osqp();
                    obj.solver.setup(obj.variables.H, obj.variables.g, obj.variables.A, ...
                        obj.variables.lb, obj.variables.ub, 'alpha', 1);
            end
        end

        function u_star = solve(obj)

            % solve the QP problem
            switch obj.opti_type

                case 'osqp'
                    % selected solver is OSQP
                    sol    = obj.solver.solve();
                    u_star = sol.x;

                    if ~strcmp(sol.info.status, 'solved')
                        error('OSQP did not solve the problem!')
                    end

                case 'quadprog'
                    % selected solver is QUADPROG
                    var    = obj.variables;
                    u_star = quadprog(var.H, var.g, var.A, var.b, var.Aeq, ...
                        var.beq, var.lb, var.ub, var.x0, var.opts);
            end
        end
    end
end
