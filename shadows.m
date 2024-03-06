close all
L1 = 0.5;
L2 = 2.75;
L3 = 6.0;
x = [0, L1, L1, L2, L2, L3, L3, 0];
y = [0, 0, 1, 1, 0, 0, -1, -1];
figure;
fill(x, y, [0.8 0.8 0.8]); % light gray color背景
hold on;
% Draw the outline总体轮廓
plot(x, y, 'k');
% Add hatches  [x1,x2]与[y1,y2]
for i = 0:0.1:L2
    line([i, i], [0, 1], 'Color', 'k', 'LineStyle', '--');
end
% Draw dimension lines and dimension text绘制标注线和标注文本
line([0, L1], [1.5, 1.5], 'Color', 'k'); 
line([L1, L2], [1.5, 1.5], 'Color', 'k');
line([L2, L3], [-1.5, -1.5], 'Color', 'k'); 
plot([0, 0], [1.2, 1.8], 'k'); % vertical line for arrow
plot([L1, L1], [1.2, 1.8], 'k');
plot([L2, L2], [1.2, 1.8], 'k'); 
plot([L3, L3], [-1.2, -1.8], 'k'); 
text(L1/2, 1.7, '0.5', 'HorizontalAlignment', 'center');
text(L1 + (L2-L1)/2, 1.7, '2.75', 'HorizontalAlignment', 'center');
text(L2 + (L3-L2)/2, -1.7, '6.0', 'HorizontalAlignment', 'center');
axis off;%关闭坐标轴
hold off;
