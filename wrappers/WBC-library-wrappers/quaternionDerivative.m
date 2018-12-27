function qtDot   = quaternionDerivative(qt, b_omega, k)

    % wrapper of https://github.com/robotology/whole-body-controllers/tree/master/library
    qtDot = wbc.quaternionDerivative(qt, b_omega, k);
end