clc;close all
% K:\Matlab\code\mechaincs\launch_vehicle\load
h=4.5;%km
g0=9.81;Re=6371;rho_0=1.225;beta=1.3e-4;
P=2400;%KN->N
m=163772.2;%kg<-ton
u=26.5;V=350;
alpha=atan(u/V);
Stage1=46.28;  Stage3=16.49;%m
block1=17.34;  block2=12.45;
frame=[0 3.27 7.12 8.73 8.98 12.56 14 16.49 18.49 21.29 23.97 28.94 30.02 35.31 37 42.25 46.28];
%fuel=
D=[0 3.2 2.6 3.8 5.6];
%oxidizer=
l01=1.93; l45=1.64; l89=2.64; l1314=2.8;
EF=1e-8*[1 15 10 10 7 7 5.5 5.5 12 12 12 18 20 25 25 25 37];%N
% stairs(qm); 绘制阶梯图
%tube_length=zeros(length(frame)-1,1);
%for i=1:length(frame)-1
    %tube_length(i)=frame(i+1)-frame(i);
%end
%tube_length'
tube_length=[3.2700 3.8500 1.6100+0.2500 3.5800 1.4400 2.4900 2.0000 2.8000 2.6800 4.9700 1.0800    5.2900    1.6900    5.2500    4.0300];
interlevel_segment=[1.86 4.97 4.03];
tube=[3.85 14.99 13.31];
lamba=tube./D(2:4);
l_F=[tube_length(1) interlevel_segment tube];
r_F=[0 tube_length(1) interlevel_segment tube];
%% 1.2 计算纵向过载nx以及轴力N
g=g0*(Re/(Re+h))^2;
rho=rho_0*exp(-beta*h);
q=rho*V^2/2;%无需速度合成
X_p=zeros(1,length(D));
for i=1:length(D)-1
X_p(i)=3/2*(alpha^2+2*beta^2)*q*(pi*(D(i)^2-D(i+1)^2)/4);
end
X=sum(X_p)*(1+0.4)*(1+0.2);
nx=(P-X)/m/g;

F=zeros(1,length(l_F));
for i=1:length(l_F)
F(i)=(r(i)+r(i+1))*l_F(i)/2/2;
end
ac=@(x)sin(x)./x
s=quad(ac,pi/4,pi/2)

r=0:0.1:Stage1;
q_ax=-(sum(X_p)*0.4/sum(F)+2*sum(X_p)/Stage1/(0+D(end)/2))*r;
qm=[0 160 125 100 55 55 100 100 250 250 250 370 400 500 500 500 740];%kg/m
q_m=zeros(1,100);
for i=1:length(q_m)-1
    qm=[0 160 125 125 125 100 ...
        55 55 100 100 250 250 ...
        250 370 400 400 500 500 ...
        500 740];%kg/m
    q_m(i)=@(r)(frame(i)<r<=frame(i+1))*(qm(i+1)-qm(i))/(frame(i+1)-frame(i));
end
%q_m(q_m==0) = []; 
q_m=-q_m;



%% 1.3 计算法向过载ny、角加速度zz，剪力Q和弯矩M
delta=deg2rad(4.8);
Y_t=1.5*alpha^2*q.*lamba.*(pi.*D(2:4).^2/4);
Y_i=zeros(1,length(D));
for i=1:length(D)-1
Y_i(i)=3*alpha*q*(pi*(D(i)^2-D(i+1)^2)/4);
end
Y=sum(Y_t)+sum(Y_i);
ny=(P*delta+Y)/m/g;



figure; 
for i = 1:5
    rectangle('Position',[i, 0, 1, 1], 'FaceColor', 'b');
end
% 添加水平线
line([0, 6], [1, 1], 'Color', 'k', 'LineStyle', '--');
% 添加文本
text(3, 1.1, '\it{Q}_{mx}', 'HorizontalAlignment', 'center');
% 添加箭头
annotation('arrow', [0.2 0.6], [0.8 0.8]);
axis([0 6 0 2]);
axis off; 


figure; % 创建一个新的图形

% 绘制三角形
% 定义三角形的顶点坐标
x_triangle = [1, 2, 1.5];
y_triangle = [0, 0, 1];
fill(x_triangle, y_triangle, 'b'); % 使用 'b' 作为填充颜色

hold on; % 保持当前图形，以便在同一图形上绘制更多的形状

% 绘制梯形
% 定义梯形的顶点坐标
x_trapezoid = [3, 4, 3.75, 3.25];
y_trapezoid = [0, 0, 0.5, 0.5];
fill(x_trapezoid, y_trapezoid, 'r'); % 使用 'r' 作为填充颜色

hold off;
% 调整坐标轴视图
axis([0 5 0 2]);
axis off; 

 


figure;
fill([1, 2, 3], [0, 1, 0], 'b'); 
hold on;
fill([4, 5, 5], [0, 1, 1], 'b'); 
fill([2, 3, 4, 5], [0, 1, 1, 0], 'b'); 
% 添加竖线
for i = 1:5
    line([i, i], [0, 1], 'Color', 'k', 'LineStyle', '--');
end
% 添加文本并指向箭头
text(3, 1.1, '\it{Q}_{mx}', 'HorizontalAlignment', 'center');
text(3, 0.5, 'Text', 'HorizontalAlignment', 'center'); % 添加额外的文本
annotation('arrow', [0.2 0.6], [0.8 0.8]);

axis([0 6 0 2]);
axis off;
hold off;



























































