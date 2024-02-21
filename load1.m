clc;close all
% K:\Matlab\code\mechaincs\launch_vehicle\load
h=4.5e3;%km->m
g=9.81;Re=6371e3;rho_0=1.225;beta=1.3e-4;
u=26.5;V=350;
alpha=atan(u/V);
gamma=1.4;R=287.05;T0=288.15;lamda_T=6.5;
c=sqrt(gamma*R*(T0-lamda_T*h/1e3));%对流层温度估算公式
Ma=V/c;
P=2400;%KN->N
m=163772.2;%kg<-ton

Stage1=46.28;  Stage3=16.49;%m
block1=17.34;  block2=12.45;
frame=[0 3.27 7.12 8.73 8.98 12.56 14 16.49 18.49 21.29 23.97 28.94 30.02 35.31 37 42.25 46.28];
%fuel=
D=[0 3.2 2.6 3.8 5.6];
%oxidizer=
l01=1.93; l45=1.64; l89=2.64; l1314=2.8;
EF=1e-8*[1 15 10 10 7 7 5.5 5.5 12 12 12 18 20 25 25 25 37];%N
% stairs(qm); 绘制阶梯图
tube_length=[3.2700 3.8500 1.6100+0.2500 3.5800 1.4400 2.4900 2.0000 2.8000 2.6800 4.9700 1.0800    5.2900    1.6900    5.2500    4.0300];
interlevel_segment=[1.86 4.97 4.03];
tube=[3.85 14.99 13.31];
lamba=tube./D(2:4);
l_F=[0 tube_length(1) interlevel_segment];
%% 1.2 计算纵向过载nx以及轴力N
%g=g0*(Re/(Re+h))^2;
rho=rho_0*exp(-beta*h);
q=rho*V^2/2;%无需速度合成
r=0:0.1:Stage1;
X_p=zeros(1,length(D)-1);
F_t=X_p;F_j=X_p;
for i=1:length(D)-1
    tube=[0 3.85 14.99 13.31];%matlab中局部作用域生效在整个区间
    beta1(i)=atan2((D(i+1)-D(i)),l_F(i+1)*2);
    F_t(i)=(D(i)+D(i+1))*l_F(i+1)/2/2;
    F_j(i)=D(i)*tube(i)/2;
    X_p(i)=3/2*(alpha^2+2*beta1(i)^2)*q*(pi*(D(i+1)^2-D(i)^2)/4);%修改角度
    q_axp(i)=-2*pi*beta1(i)*q*(alpha^2+2*beta1(i)^2);
end
X=sum(X_p)*(1+0.4)*(1+0.2);
nx=(P-X)/m/g;
% ac=@(x)sin(x)./x
% s=quad(ac,pi/4,pi/2)%自适应 Simpson 积分法计算数值积分
%'function_handle' 类型的操作数不支持运算符 '+'。  不支持一元运算符 '-'。
%q_ax=-(sum(X_p)*0.4/sum(F_t+F_j)*r+(@(r)(0<r<l_F(2))*q_axp(1)+(l_F(2)<r<l_F(3))*q_axp(2)+(l_F(3)<r<l_F(4))*q_axp(3)+(l_F(4)<r<l_F(5))*q_axp(4)));
%必须分开算q_axp——因为每一段l、r1、r2不一样
%matlab中索引从1开始
q_ax=@(x)((x>frame(1)&x<frame(2))*q_axp(1).*x+...
    (x>frame(3)&x<frame(5))*q_axp(2).*x+...
    (x>frame(end-6)&x<frame(end-5))*q_axp(3).*x+...
    (x>frame(end-1)&x<frame(end))*q_axp(4).*x-...
    sum(X_p)*0.4/sum(F_t+F_j).*x);
figure(1)
plot(r,q_ax(r))%调用句柄
%plot 函数期望的是向量或矩阵形式的数据作为输入
qm=[0 160 125 100 55 55 100 100 250 250 250 370 400 500 500 500 740];%kg/m
%% 出错，请保持修正
% for i=1:2:length(q_m)-1
%     frame1=[0 3.27 3.27 7.12 7.12 8.73 ...
%         8.73 8.98 8.98 12.56 12.56 14 ...
%         14 16.49 16.49 18.49 18.49 21.29 ...
%         21.29 23.97 23.97 28.94 28.94 30.02 ...
%         30.02 35.31 35.31 37 37 42.25 ...
%         42.25 46.28];
%     qm=[0 160 125 125 125 100 ...
%         55 55 100 100 250 250 ...
%         250 370 400 400 500 500 ...
%         500 740];%kg/m
%     %无法从 function_handle 转换为 double      
%     q_m(i)=@(r)(r>frame1(i)&r<=frame1(i+1))*(((qm(i+1)-qm(i))/(frame1(i+1)-frame1(i)).*(r-frame1(i)))+qm(i));
% end
% %q_m(q_m==0) = [];
% q_m=-q_m;



%% 1.3 计算法向过载ny、角加速度zz，剪力Q和弯矩M
delta=deg2rad(4.8);
Y_t=1.5*alpha^2*q.*lamba.*(pi.*D(2:4).^2/4);
Y_i=zeros(1,length(D));
for i=1:length(D)-1
    Y_i(i)=3*alpha*q*(pi*(D(i)^2-D(i+1)^2)/4);
    c(i)=l_F(i+1)/3*(1+D(i+1)/(D(i+1)+D(i)));
end
Y=sum(Y_t)+sum(Y_i);
ny=(P*delta+Y)/m/g;

% 压心

%EF刚度
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



























































