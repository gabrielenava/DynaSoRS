classdef LinearMPC < handle
    % LINEARMPC implements a constrained linear-quadratic MPC using OSQP.
    %
    % LinearMPC solves the following problem:
    %
    %   min (x_N - x_r)^T*Q_N*(x_N - x_r) + ...
    %       \sum_(k=0)^(N-1) (x_k - x_r)^T*Q*(x_k - x_r) u_k^T*R*u_k
    %
    %      s.t. x_(k+1) = A*x_k + B*u_k
    %           x_min <= x_k <= x_max
    %           u_min <= u_k <= u_max
    %           x_0 = \bar{x}
    %
    % Author: Gabriele Nava, gabriele.nava@iit.it
    % Dec. 2022
    %
    properties
        P
        q
        A
        l
        u
        N
        Q
        Q_N
        x_0
        x_r
        solver
    end

    methods
        function obj = LinearMPC()

            obj.P      = [];
            obj.q      = [];
            obj.A      = [];
            obj.l      = [];
            obj.u      = [];
            obj.solver = [];
            obj.N      = [];
            obj.Q      = [];
            obj.Q_N    = [];
            obj.x_0    = [];
            obj.x_r    = [];
        end

        function [] = setup(obj, var)

            % setup the MPC problem. Required inputs:
            %
            % var.N     = number of steps;
            % var.Ax    = matrix A of the system \dot{x} = Ax + Bu
            % var.Bu    = matrix B of the system \dot{x} = Ax + Bu
            % var.Q_N   = weight of final cost
            % var.Q     = weight of the step-by-step cost
            % var.R     = weight of the input cost
            % var.x_r   = reference state
            % var.x_0   = initial state
            % var.x_min = state lower bound
            % var.x_max = state upper bound
            % var.u_min = input lower bound
            % var.u_max = input upper bound
            %
            obj.N   = var.N;
            obj.Q_N = var.Q_N;
            obj.Q   = var.Q;
            obj.x_r = var.x_r;
            obj.x_0 = var.x_0;

            Ax      = var.Ax;
            Bu      = var.Bu;
            R       = var.R;
            x_min   = var.x_min;
            x_max   = var.x_max;
            u_min   = var.u_min;
            u_max   = var.u_max;

            % compute the hessian
            %
            % input state y is:
            %
            %   y = [x(0); x(1); ...; x(N); u(0); ...; u(N-1)]
            %
            % so, the Hessian must be build as follows:
            %
            %   P = [Q   0 ... R ... 0;
            %        0   Q ... 0 ... 0;
            %              ...
            %        0   0 ... 0 ... R];
            %
            Px    = kron(eye(obj.N), obj.Q);
            Pu    = kron(eye(obj.N), R);
            Pxn   = obj.Q_N;
            obj.P = blkdiag(Px, Pxn, Pu);

            % compute the gradient
            %
            % must be build as
            %
            %   q = [-Q*x_r; ...; -Qf*x_r; ...; 0]
            %
            % the term x_r'*Q*x_r does not affect the gradient
            %
            qx    =  repmat(-obj.Q*obj.x_r, obj.N, 1);
            qxn   = -obj.Q_N*obj.x_r;
            qu    =  zeros(obj.N*size(Bu, 2), 1);
            obj.q =  [qx; qxn; qu];

            % compute the constraints
            %
            % linear dynamics and initial conditions
            %
            %   expand the linear dynamics constraint to each state
            %
            %     0 = -x_(k+1) + A*x_k + B*u_k (dynamics)
            %
            %     A_dyn = [-1   0 ... 0  0
            %               Ax -1 ... 0  0
            %               0   0 ... Ax -1]
            %
            %     B_dyn = [0 0  ... 0
            %              0 Bu ... 0
            %              0 0  ... Bu]
            %
            %     leq = ueq = [-x0; 0; 0]
            %
            A_dyn = kron(eye(obj.N+1), -eye(size(Ax,1))) + kron(diag(ones(obj.N, 1), -1), Ax);
            B_dyn = kron([zeros(1, obj.N); eye(obj.N)], Bu);
            Aeq   = [A_dyn, B_dyn];
            leq   = [-obj.x_0; zeros(obj.N*size(Ax,1), 1)];
            ueq   = leq;

            % compute the bounds on state and input
            Aineq = eye((obj.N+1)*size(Ax,1) + obj.N*size(Bu,2));
            lineq = [repmat(x_min, obj.N+1, 1); repmat(u_min, obj.N, 1)];
            uineq = [repmat(x_max, obj.N+1, 1); repmat(u_max, obj.N, 1)];

            % formulate OSQP constraints
            obj.A = [Aeq; Aineq];
            obj.l = [leq; lineq];
            obj.u = [ueq; uineq];

            % setup the OSQP problem
            obj.solver = osqp();
            obj.solver.setup(obj.P, obj.q, obj.A, obj.l, obj.u, 'warm_start', true);
        end

        function [] = update(obj, var)

            % update the MPC problem. Required inputs:
            %
            % var.x_r   = reference state
            % var.x_0   = initial state
            %
            % NB: other fields of 'var' are ignored.
            %
            x_r_upd = var.x_r;
            x_0_upd = var.x_0;

            if ~sum(x_0_upd == obj.x_0)

                % update the init state
                obj.l(1:length(x_0_upd)) = -x_0_upd;
                obj.u(1:length(x_0_upd)) = -x_0_upd;
                obj.solver.update('l', obj.l, 'u', obj.u);
            end

            if ~sum(x_r_upd == obj.x_r)

                % update the reference state
                qx    =  repmat(-obj.Q*x_r_upd, obj.N, 1);
                qxn   = -obj.Q_N*x_r_upd;
                obj.q(1:length(x_r_upd)*(obj.N+1)) = [qx; qxn];
                obj.solver.update('q', obj.q);
            end
        end

        function u_star = solve(obj)

            % solve the MPC problem
            sol    = obj.solver.solve();
            u_star = sol.x;

            if ~strcmp(sol.info.status, 'solved')
                error('OSQP did not solve the problem!')
            end
        end
    end
end
