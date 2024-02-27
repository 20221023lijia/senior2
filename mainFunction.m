function mainFunction()
    a = 10;
    b = 20;
    result = subFunction(a, b);
    disp(result);
end

function output = subFunction(x, y)
    % 假设这里有一个错误，比如除以0的错误
    output = (x + y) / 0;
end
