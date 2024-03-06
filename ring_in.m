%function ring_in(filename)
fileID = fopen('1.txt', 'r');
data = textscan(fileID, '%s', 'Delimiter', '');
fclose(fileID);
data = string(data{1});%bug.字符串形式,无法处理 
new_data = [];
for i = 1:numel(data)
    if contains(data(i), '*')
        % 遇到星号，跳过
        continue;
    elseif mod(i, 5) == 1
        new_row = [str2double(data(i)), str2double(data(i+1)), str2double(data(i+2)), str2double(data(i+3)), str2double(data(i+4))];
        new_data = [new_data; new_row];
    end
end
disp(new_data)
%end
