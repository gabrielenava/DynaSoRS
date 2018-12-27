function q = fromTransfMatrixToPosQuat(H)

    % wrapper of https://github.com/robotology/whole-body-controllers/tree/master/library
    q = wbc.fromTransfMatrixToPosQuat(H);
end
