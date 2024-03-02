function fig=plot_out(x)

frame_01=[0 3.27 3.85 1.61 0.25 3.58 1.44 2.49 2 2.8 2.68 4.97 1.08 5.29 1.69 5.25 4.03];
frame_0=cumsum(frame_01);
y=zeros(1,length(frame_0));
frame_1=zeros(1,length(frame_0)*2-2);
j=2;
for i=2:length(frame_0)
    frame_1(j:j+1)=[frame_0(i) frame_0(i)];
    j=j+2;
end
frame_1(end)=[];
for i=1:length(frame_0)
    y (i)= trapz(frame_0, x);
end
%点间距必须为指定均匀间距的标量，或者为每个数据点的 x 坐标向量。
if length(frame_1) ~= length(yAxisData)
    error('横坐标和纵坐标的数据长度必须相同。');
end

fig=figure; 
plot(frame_1, y);
xlabel('Frame'); % 横坐标标签
ylabel('Data'); % 纵坐标标签
title('Custom Graph'); % 图形标题
grid on;
ax = gca;
% 设置X轴和Y轴的刻度间隔
ax.XTick = min(frame_1):10:max(frame_1);
ax.YTick = min(y):10:max(y);
global frame_1
end