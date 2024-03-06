function [theta]=ring_in2(filename)
%data = importdata(filename, '*', 1);
your_data = importdata(filename, '*', 0);
%your_data = data.data;%当有行标题的时候可以这样读取
% 将数据转换为浮点数类型
your_data = double(your_data);
A_no_nan = your_data(~isnan(your_data)); % 去除矩阵中的NaN值
m=36;n=10;
A_no_nan_reshaped = reshape(A_no_nan, m, n);
back={[A_no_nan_reshaped(:,1);A_no_nan_reshaped(:,6)],...
                  [A_no_nan_reshaped(:,2);A_no_nan_reshaped(:,7)],...
                  [A_no_nan_reshaped(:,3);A_no_nan_reshaped(:,8)],...
                   [A_no_nan_reshaped(:,4);A_no_nan_reshaped(:,9)],...
                  [A_no_nan_reshaped(:,5);A_no_nan_reshaped(:,10)]};
theta=cell2mat(back);
end
