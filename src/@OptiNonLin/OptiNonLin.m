classdef OptiNonLin < handle
    % OPTINONLIN wraps Nonlinear optimization with FMINCON.
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Jan. 2023
    %
    properties
        solver
        cost
        u_init
        A
        b
        Aeq
        beq
        lb
        ub
        nonlcon
        options
    end

    methods
        function obj = OptiNonLin()

            obj.cost    = [];
            obj.u_init  = [];
            obj.A       = [];
            obj.b       = [];
            obj.Aeq     = [];
            obj.beq     = [];
            obj.lb      = [];
            obj.ub      = [];
            obj.nonlcon = [];
            obj.solver  = 'fmincon';
            obj.options = optimoptions('fmincon','Display','off');
        end

        function [] = update(obj, var)

            % update opti variables. If the user does not specify some of
            % the fields, default values are used
            variables_names = fieldnames(var);

            for k = 1:length(variables_names)

                obj.(variables_names{k}) = var.(variables_names{k});
            end
        end

        function u_star = solve(obj)

            % solve the nonlinear optimization problem
            [u_star, ~, exitflag, output] = fmincon(obj.cost, obj.u_init, obj.A, obj.b, obj.Aeq, obj.beq, ...
                obj.lb, obj.ub, obj.nonlcon, obj.options);

            if exitflag < 1

                error(output.message)
            end
        end
    end
end
