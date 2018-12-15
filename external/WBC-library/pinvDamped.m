function pinvDampA = pinvDamped(A,regDamp)

    % wrapper of https://github.com/robotology/whole-body-controllers/tree/master/library
    pinvDampA = wbc.pinvDamped(A,regDamp);
end
