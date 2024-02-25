function fig=QM_plot(x_values,column4,column5,column6,Y_Value)
final_vector = zeros(1, length(column4) * 3);
for i = 1:length(column4)
    final_vector((i-1)*3 + 1) = column4(i);
    final_vector((i-1)*3 + 2) = column5(i);
    final_vector((i-1)*3 + 3) = column6(i);
end
N = length(x_values); 
%% 每三个元素为一组，复制每一组的最后一个元素(除了最后一组)
% x_expanded = zeros(1, N + floor((N-1)/3)); 
% j = 1; % x_expanded的索引
% for i = 1:N
% x_expanded(j) = x_values(i);
% j = j + 1;
% % 每三个Y值复制对应的X值一次，包括最后一组之前的所有组
% if mod(i, 3) == 0 && i < N
% x_expanded(j) = x_values(i);
% j = j + 1;
% end
% end
%% 每三个元素为1组，复制每一组的首尾两个元素(除第一个和倒数第一个)
% % sln1.动态分配数组
% x_expanded = x_values(1);%初始化(notice)
% for i = 1:2:N-2
%     x_expanded = [x_expanded,x_values(i),x_values(i+1), x_values(i+2)]; % 复制第一个和第三个元素
% end
% x_expanded(1)=[];
% sln2.静态分配数组
expanded_size = 3 * ((N - 1) / 2); % 预计算空间
x_expanded = zeros(1, expanded_size); % 预分配
idx = 1; 
for i = 1:2:N-2
    x_expanded(idx:idx+2) = [x_values(i), x_values(i+1), x_values(i+2)]; 
    idx = idx + 3; % 更新x_expanded的索引
end
%x_expanded = [x_expanded, x_values(end)];%添加最后一个元素
fig=figure;%返回值（图形句柄）被存储在变量 fig 中
plot(x_expanded, final_vector, '-o'); % 使用连线和标记点绘制
xlabel('Длина ракеты');%make sure UTF-8
ylabel(Y_Value);
plotTitle = sprintf('%s vs. Длина ракеты', Y_Value);
title(plotTitle);
% for i = 1:length(x_expanded)
%     %text三个参数：x位置、y位置和要显示的文本字符串
%     %text(x_expanded(i), final_vector(i), sprintf('(%0.2f, %0.2f)', x_expanded(i), final_vector(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
%     text(x_expanded(i),final_vector(i), sprintf('%0.2f', final_vector(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
% 
% end
grid on; 
end