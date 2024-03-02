function output = repeatAndTrim(input)
    output = repmat(input, 2, 1);
    output = output(:)';%% 一列列来
    output(end) = [];
    output(2) = [];
end