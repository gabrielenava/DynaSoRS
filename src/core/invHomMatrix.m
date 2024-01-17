function b_H_a = invHomMatrix(a_H_b)

    % compute the inverse of the homogeneous transf. matrix a_H_b, i.e.
    %
    % b_H_a = [ transpose(a_R_b) -transpose(a_R_b)*a_pos_a,b;
    %               0   0   0               1 ];
    %
    b_H_a = [a_H_b(1:3, 1:3)', -a_H_b(1:3, 1:3)' * a_H_b(1:3, 4); ...
             zeros(1,3), 1];
end
