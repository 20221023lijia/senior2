function QM_plot(x_values,column4,column5,column6)
final_vector = zeros(1, length(column4) * 3);
for i = 1:length(column4)
    final_vector((i-1)*3 + 1) = column4(i);
    final_vector((i-1)*3 + 2) = column5(i);
    final_vector((i-1)*3 + 3) = column6(i);
end
N = length(x_values); % X值的总数
x_expanded = zeros(1, N + floor((N-1)/3)); % 初始化扩展X向量
j = 1; % x_expanded的索引
for i = 1:N
x_expanded(j) = x_values(i);
j = j + 1;
% 每三个Y值复制对应的X值一次，包括最后一组之前的所有组
if mod(i, 3) == 0 && i < N
x_expanded(j) = x_values(i);
j = j + 1;
end
end
fig=figure;%返回值（图形句柄）被存储在变量 fig 中
plot(x_expanded, final_vector, '-o'); % 使用连线和标记点绘制
xlabel('X Value');
ylabel('Y Value');
title('Y Values vs. X Value with Replicated X Values at Boundaries');
grid on; 
end