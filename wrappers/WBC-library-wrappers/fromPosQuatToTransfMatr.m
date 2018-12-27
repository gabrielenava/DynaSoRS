function H = fromPosQuatToTransfMatr(q)

    % wrapper of https://github.com/robotology/whole-body-controllers/tree/master/library
    H = wbc.fromPosQuatToTransfMatr(q);
end
