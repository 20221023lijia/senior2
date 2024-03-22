clc;close all;dbclear all;clear all
% K:\Matlab\code\mechaincs\launch_vehicle\load
%  fprintf("%.2f\n",X)
load('q_m_1.mat',"q_m_1")
load('T_qm1.mat',"T_qm1")
load('s_mi.mat',"s_mi")
load('N_m0.mat',"N_m0")
load('N_rho1.mat',"N_rho1")
load('N_o1.mat',"N_o1")
load('N_p1.mat',"N_p1")
load('q_ax1.mat',"q_ax1")
load('q_axf1.mat',"q_axf1")

global frame_1 

h=4.5e3;%km->m
g=9.81;Re=6371e3;rho_0=1.225;beta=1.3e-4;
u=26.5;V=350;
alpha=atan(u/V);
gamma=1.4;R=287.05;T0=288.15;lamda_T=6.5;
h1=7.8824e+03;
c1=sqrt(gamma*R*(T0-lamda_T*h1/1e3));%对流层温度估算公式
Ma=V/c1;%1.1342
%Ma= v2Mach(V,h); %1.1343 差别不大
P=2400e3;%KN->N
m=163772.2;%kg<-ton
m_x=21609;

Stage1=46.28;  Stage3=16.49;%m  越靠前级别就越高
block1=17.34;  block2=12.45;
frame=[0 3.27 7.12 8.73 8.98 12.56 14 16.49 18.49 21.29 23.97 28.94 30.02 35.31 37 42.25 46.28];
%fuel=
D=[0 3.2 2.6 3.8 5.6];
%oxidizer=
l01=1.93; l45=1.64; l89=2.64; l1314=2.8;
EF=1e-8*[1 15 10 10 7 7 5.5 5.5 12 12 12 18 20 25 25 25 37];%N
% stairs(qm); 绘制阶梯图
tabluar15_2=[3.2700 3.8500 1.6100 0.2500 3.5800 1.4400 2.4900 2.0000 2.8000 2.6800 4.9700 1.0800    5.2900    1.6900    5.2500    4.0300];
fprintf('tabular1.5column2_length=%.2f\n',tabluar15_2)
tube_length=[3.2700 3.8500 1.6100+0.2500 3.5800 1.4400 2.4900 2.0000 2.8000 2.6800 4.9700 1.0800    5.2900    1.6900    5.2500    4.0300];
interlevel_segment=[1.86 4.97 4.03];
tube=[3.85 14.99 13.31];
lamba=tube./D(2:4);
l_F=[0 tube_length(1) interlevel_segment];
frame_Y=[3.27 7.12 8.98 23.97 28.94 42.25 46.28];

%% 1.2 计算纵向过载nx以及轴力N
%计算空气阻力
k_axf=0.4;k_b=0.2;
rho=rho_0*exp(-beta*h);
q=rho*V^2/2;%无需速度合成
r=0:0.1:Stage1;
X_p=zeros(1,length(D)-1);
F_t=X_p;F_j=X_p;
for i=1:length(D)-1
    tube=[0 3.85 14.99 13.31];%matlab中局部作用域生效在整个区间
    beta1(i)=atan2((D(i+1)-D(i)),l_F(i+1)*2);%（y,x）
    F_t(i)=(D(i)+D(i+1))*l_F(i+1)/2/2;
    F_j(i)=D(i)*tube(i)/2;
    X_p(i)=3/2*(alpha^2+2*beta1(i)^2)*q*(pi*(D(i+1)^2-D(i)^2)/4);%修改角度
    %C_xp0=1.949*abs(beta1(2))^1.7*(0.8+1/Ma^2);
    %X_p(2)=-C_xp0*q*(pi*(D(3)^2-D(2)^2)/4)-5.1802e+03/2*alpha;
    %q_axp(i)=-2*pi*beta1(i)*q*(alpha^2+2*beta1(i)^2)*1.5;%仅计算系数
end
fprintf('tabular1.5column3_X_p=%.2f\n',X_p)
tube(tube==0)=[];
X=sum(X_p)*(1+k_axf)*(1+k_b);   %2-6   15-25
X_bottom=sum(X_p)*(1+k_axf)*k_b;
nx=(P-X)/m/g;
% ac=@(x)sin(x)./x
% s=quad(ac,pi/4,pi/2)%自适应 Simpson 积分法计算数值积分
%'function_handle' 类型的操作数不支持运算符 '+'。  不支持一元运算符 '-'。
%q_ax=-(sum(X_p)*0.4/sum(F_t+F_j)*r+(@(r)(0<r<l_F(2))*q_axp(1)+(l_F(2)<r<l_F(3))*q_axp(2)+(l_F(3)<r<l_F(4))*q_axp(3)+(l_F(4)<r<l_F(5))*q_axp(4)));
%必须分开算q_axp——因为每一段l、r1、r2不一样
%matlab中索引从1开始
% q_ax=@(x)((x>frame(1)&x<frame(2))*q_axp(1).*x+...
%     (x>frame(3)&x<frame(5))*q_axp(2).*x+...
%     (x>frame(end-6)&x<frame(end-5))*q_axp(3).*x+...
%     (x>frame(end-1)&x<frame(end))*q_axp(4).*x-...
%     sum(X_p)*0.2/sum(F_t+F_j).*x);
% figure(1)
% plot(r,q_ax(r))  %调用句柄
r1=[0    3.2  2.6  3.8 ]/2;
r1_=[3.2 2.6  3.8 5.6]/2;
r1__=[0 3.2 3.2 2.6+25/181*0.6 2.6 2.6 3.8 3.8 5.6]/2;
q_axp_=-2*X_p./(r1+r1_)./l_F(2:end);
q_axp_0=[q_axp_(1) q_axp_(1) q_axp_(2)  q_axp_(2) q_axp_(2)...
    q_axp_(3) q_axp_(3) q_axp_(4) q_axp_(4)];
q_axp=q_axp_0.*r1__;
fprintf('tabular1.5column5_q_axp=%.2f\n',-q_axp)
q_axf=-D(2:5)/2*sum(X_p)*k_axf/sum(F_t+F_j);
fprintf('tabular1.5column6_q_axf=%.2f\n',-q_axf)
fprintf('tabular1.5column7_q_ax1=\n')
fprintf('%.2f\n',-q_ax1)


frame_01=[0 3.27 3.85 1.61 0.25 3.58 1.44 2.49 2 2.8 2.68 4.97 1.08 5.29 1.69 5.25 4.03];
N_a1 = calculateValues(frame_01, q_ax1);
T_qm1 = calculateValues(frame_01,q_m_1);

frame_0=cumsum(frame_01);
frame_1=zeros(1,length(frame_0)*2-2);
N_a(1)=0;T_qm(1)=0;
j=2;
for i=2:length(frame_0)
    frame_1(j:j+1)=[frame_0(i) frame_0(i)];
    N_a(i)=(q_ax1(j-1)+q_ax1(j))*frame_01(i)/2;
    T_qm(i)=(q_m_1(j-1)+q_m_1(j))*frame_01(i)/2;
    j=j+2;
end
frame_1(end)=[];
% N_a=cumsum(N_a);T_qm=cumsum(T_qm);
% j=2;
% for i=2:length(frame_0)
%     N_a1(j:j+1)=[N_a(i) N_a(i)];
%     T_qm1(j:j+1)=[T_qm(i) T_qm(i)];
%     j=j+2;
% end
% N_a1(end)=[];T_qm1(end)=[];

fprintf('tabular1.5column8_N_a1=\n')
fprintf('%.2f\n',N_a1)
fprintf('tabular1.5column10_T_qm1=\n')
fprintf('%.2f\n',T_qm1)

plotWithAnnotations(frame_1, q_axf1, 1, 'q_axf1');
%plot向量或矩阵形式的数据作为输入
qm=[0 160 125 100 55 55 100 100 250 250 250 370 400 500 500 500 740];%kg/m
qm=-qm*nx*g
q_m=zeros(length(r),100);
for i=1:2:20
    frame1=[0 3.27 3.27 7.12 7.12 8.73 ...
        8.73  14 ...
        14 18.49 18.49 23.97 23.97 28.94 28.94 35.31 35.31 42.25 ...
        42.25 46.28];
    qm=[0 160 125 125 125 100 ...%0.25/(0.25+1.61)*25+100
        55 55 100 100 250 250 ...
        250 370 400 400 500 500 ...
        500 740];%kg/m
    %无法从 function_handle 转换为 double (不可以将其赋值给矩阵)
    %refresh
    q_m1=@(r)(r>=frame1(i)&r<=frame1(i+1)).*(((qm(i+1)-qm(i))/(frame1(i+1)-frame1(i)).*(r-frame1(i)))+qm(i));
    q_m(:,i)=q_m1(r);
end
q_m(q_m==0) = [];
q_m0=q_m*nx*g;
plotWithAnnotations(frame_1, q_m_1, 2, 'q_m_1');

% for i = 1:length(r)
%     text(r(i),q_m(i), sprintf('%0.2f', q_m(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
% end
plotWithAnnotations(frame_1, N_a1, 3, 'N_a1');
plotWithAnnotations(frame_1, T_qm1, 4, 'T_qm1');

%% fig4=plot_out(q_m);
N_m_L=-nx*g*m_x;
fprintf('N_m_L=%.2f\n',N_m_L)
N_rho_L=-nx*g*(m-m_x);
fprintf('N_rho_L=%.2f\n',N_rho_L)
%计算集中质量力（不加燃料）
mi=[0 0 2450 40 40 49+150 0 45 40 50+854 0 200 300 200 300+3801];
P_ix=-nx*mi*g;
P_ix1=-nx*s_mi*g;
N_m=-nx*N_m0*g;
fprintf('tabular1.5column14_N_m=\n')
fprintf('%.2f\n',-N_m)
plotWithAnnotations(frame_1, P_ix1, 5, 'P_ix1');
plotWithAnnotations(frame_1, N_m, 6, 'N_m');
%计算增压压力(注意正负)[不需要相减，计算结果见data.mat]
p_0=[.3  .27 .35 .35 .32 .29]*1e6;%MPA
D_0=[D(3) D(3) D(3) D(3) D(4) D(4)];
P_0x=pi.*D_0.^2/4.*p_0;
P_1x=[P_0x(1) P_0x(1)-P_0x(2) P_0x(2) ...
    P_0x(3) P_0x(3)-P_0x(4) P_0x(4) ...
    P_0x(5) P_0x(5) P_0x(6) P_0x(6)];
fprintf('tabular1.5column17_N_0=\n')
fprintf('%.0f\n',P_1x)
% fprintf('%ld\n',P_1x)%round()四舍五入;  %d int;  %u或ld unsigned int
%计算的边缘点，前两个罐子记得加减
%计算燃料压力(圆柱形=圆台+圆球)【需不需要想得更复杂一些】
mT=[979+15016 1412+6597 1459+17512 1288+12865 4988+40209.3 4400+35434.6];
P_Tx=-nx*mT*g;%作为前半部分存在
fprintf('tabular1.5column15_P_Tx=\n')
fprintf('%.0f\n',P_Tx)
fprintf('tabular1.5column16_N_rho=\n')
fprintf('%.0f\n',cumsum(P_Tx))
plotWithAnnotations(frame_1, N_rho1, 7, 'N_rho1');
N=N_m+N_a1'+N_rho1+N_o1+N_p1;
fprintf('tabular1.5column19_N=\n')
fprintf('%.2f\n',N)
plotWithAnnotations(frame_1, N_o1, 8, 'N_o1');
plotWithAnnotations(frame_1, N_p1, 9, 'N_p1');
plotWithAnnotations(frame_1, N, 10, 'N');
err(N_m_L,N_m(end),'err_m')  %input 字符串 只需要带引号
err(N_rho_L,N_rho1(end),'err_rho')
err(X_bottom,N(end),'err_N')%理论值 实验值

%% 1.3 计算法向过载ny、角加速度zz，剪力Q和弯矩M
delta=deg2rad(4.8);
Y_j=1.5*alpha^2*q.*lamba.*(pi.*D(2:4).^2/4);
Y_i=zeros(1,length(D)-1);
for i=1:length(D)-1
    Y_i(i)=3*alpha*q*(pi*(D(i+1)^2-D(i)^2)/4);
    c(i)=l_F(i+1)/3*(1+D(i+1)/(D(i+1)+D(i)));
end
Y_i(2)=alpha*q*(pi*(D(3)^2-D(2)^2)/4)*0.6;
Y=sum(Y_j)+sum(Y_i);
ny=(P*delta+Y)/m/g;
% 压心(对最前边取矩)
cz_0=[c(1) frame_Y(1)+tube(1)/2 frame_Y(2)+c(2) frame_Y(3)+tube(2)/2 ...
    frame_Y(4)+c(3) frame_Y(5)+tube(3)/2 frame_Y(6)+c(4)];
%Y_=[Y_i(1) Y_j(1) Y_i(2) Y_j(2) Y_i(3) Y_j(3) Y_i(4)];
Y_=[];%初始化
for i=1:2*length(Y_i)-1
    if mod(i,2) == 0 %偶数 2 4 6 8
        Y_(end+1)=Y_j(i/2);%想法设法让其变小
    else
        Y_(end+1)=Y_i((i+1)/2);
    end
end
cz=(Y_*cz_0')/Y;% 注意逆的位置
%EF刚度
a=-cz+29.412;b=Stage1-29.412;Iz=.20413e8;
Mz=Y*a-P*delta*b;%逆时针为正
zz=Mz/Iz;
writeDataToTxt(Y_, Y, c, tube, cz, cz_0, ny, zz, 'YYY.txt')
%% 绘制剪力、弯矩
A= [0,3.27, 3.85, 1.61, 0.25, 3.58, 0.3501, 1.09, 2.49, 2.0, 2.8, 0.3502, 2.33, 4.97, 1.08, 2.28, 3.01, 1.69, 2.246, 3.004, 4.03];
A=cumsum(A);
B0 = zeros(2*size(A,2)-1, 1);
for i = 1:size(A,2)-1
    B0(2*i-1) = A(i); % 将当前元素赋值到B
    B0(2*i) = (A(i) + A(i+1)) / 2; % 计算当前元素与下一个元素的平均值，并赋值
end
B0(end) = A(end);
Q1= [0, 76.56, 80.19, 75.77, 75.95, 71.25, 71.49, 65.52, 67.08, 68.22, 37.05, 37.14, 5.888, 59.19, 58.45, 57.99, -106, -108.2, -110.5, -113.7];
Q2= [19.15, 78.4, 77.46, 75.86, 74.87, 71.37, 69.36, 66.31, 67.69, 54.9, 37.09, 24.64, 30.17, 59.13, 58.25, -11.88, -106.7, -109.3, -190.0, -62.13];
Q3= [76.56, 80.19, 74.99, 75.95, 71.96, 71.49, 66.98, 67.08, 68.28, 39.86, 37.14, 11.09, 59.19, 59.06, 57.99, -85.97, -107.4, -110.5, -273.3, -0.00001943];

M1= [0.0, -83.47, -385.3, -512.8, -531.8, -798.8, -823.8, -899.8, -981.9, -1065.0, -1354.0, -1367.0, -1430.0, -1584.0, -1647.0, -1780.0, -1746.0, -1566.0, -1321.0, -243.3];
M2 = [-10.44, -232.6, -448.7, -522.3, -667.0, -811.3, -862.2, -981.9, -1132.0, -1287.0, -1360.0, -1403.0, -1474.0, -1616.0, -1714.0, -1816.0, -1657.0, -1444.0, -1095.0, -64.36];
M3 = [-83.47, -385.3, -510.1, -531.8, -798.7, -823.8, -899.4, -1065.0, -1200.0, -1353.0, -1367.0, -1424.0, -1584.0, -1647.0, -1780.0, -1742.0, -1566.0, -1321.0, -747.9, -0.0005365];
%sln1
Q = "Q";%字符串初始化
M = "M";
fig1=QM_plot(B0,Q1,Q2,Q3,Q);
fig2=QM_plot(B0,M1,M2,M3,M);
%% 截面校验
m_bottom5=40;m_fuel5=979;a=2.6/2;b=.35;cc=29.412;g0=9.81;cc0=3*b/8;
m_b6=49;m_gb6=150;m_fuel6=1412;m_bottom6=[m_b6  m_fuel6 m_gb6] ;
x_bottom5_b=cc-frame(6);x_bottom5_f=cc-frame(6)-cc0;
x_bottom6_b=cc-frame(7);x_bottom6_f=cc-frame(7)-cc0;x_bottom6_g=cc-frame(7)-1.64;
x_bottom6=[x_bottom6_b x_bottom6_f x_bottom6_g];
% 5截面   
g1=g0*(Re/(Re+h))^2;g1=9.81;
ny=0.3017;zz=-0.1354;
P5y_b=-(m_bottom5)*g1*(ny+zz/g1*x_bottom5_b);
P5y_f=-(m_fuel5)*g1*(ny+zz/g1*x_bottom5_f);
P5y=P5y_b+P5y_f;
I_bottom5=19/320*m_bottom5*b^2;I_fuel5=7;
M5=P5y_f*cc0-zz*I_fuel5;%% 顺时针为正
% 6截面
I_bottom6=19/320*m_b6*b^2;I_fuel6=10;I_gb6=m_gb6/2*a^2;%圆柱体转动惯量
x6y=[1.64 cc0 0 ];
Ig6=[0 I_fuel6 0];
P6y_b=-m_b6*g1.*(ny+zz/g1*x_bottom6_b);
P6y_g=-m_gb6*g1.*(ny+zz/g1*x_bottom6_g);
P6y_f=-m_fuel6*g1.*(ny+zz/g1*x_bottom6_f);
P6y_=P6y_b+P6y_g+P6y_f;
P6y=[P6y_g  P6y_f P6y_b];
% P6y=-m_b6*g1.*(ny+zz/g1*x_bottom6);
M6=P6y.*x6y-zz.*Ig6;
err(P5y,-1e3*(71.96-71.25),'err_Q5') %现在用的是i-1时刻减i时刻
err(P6y_,-1e3*(66.98-65.52),'err_Q6')%实验误差
err(M5,-1e3*(-798.7+798.8),'err_M5')
err(sum(M6),-1e3*(-899.4+899.8),'err_M6')
%% 2.2 qt、M、Q
f=1.35;
P_n=f*[-30 17];
P_n_p(6)=P_n(1);P_n_p(36+13)=P_n(2);
P_t=f*[25 -30];
P_t_p(18)=P_t(1);P_t_p(36+31)=P_t(2);
H=f*[10 -12];
H_p(35)=H(1);H_p(36+13)=H(2);
theta=ring_in2('1.txt');
y_label={'','M,КН*М','N,КН','Q,КН','QT,КН/М'};
for i=2:5
plot2s(theta(:,1),theta(:,i), i+11,  y_label(i))
%polarplot(theta(:,1),theta(:,2),'o')
end 
A=[];
Q_(6)=theta(6,4)+P_n_p(6);Q_(36+13)=theta(36+13,4)+P_n_p(36+13);
N_(18)=theta(18,3)+P_t_p(18);N_(36+31)=theta(36+31,3)+P_t_p(36+31);
M_(35)=theta(35,2)+H_p(35);M_(36+13)=theta(36+13,2)+H_p(36+13);
fprintf('Q_=%.2f\n',Q_(6),Q_(36+13))
fprintf('N_=%.2f\n',N_(18),N_(36+31))
fprintf('M_=%.2f\n',M_(35),M_(36+13))
%% 2.3 确定桁架横截面
Q_max = max(theta(:,4))*1e3; %in N
[M_max, idx]=max(theta(:,2)); %in N*mm
M_max=M_max*1e6;N_coor1=theta(idx,3)*1e3;
[M_min, idx]=min(theta(:,2));M_min=M_min*1e6;N_coor2=theta(idx,3)*1e3;
E = 7.2e4; %in MPa
sigma_o_2 = 270; %in MPa
alpha_belt= power(abs(Q_max) / (4.8 * E),1/3);
sigma_kp = sigma_o_2;
h_wall=power( (3 *abs(M_max)) / (2 * alpha_belt * sigma_kp),3/7);
F1 = abs(M_max)/2/h_wall/sigma_kp;
F1/(2e2)
F0=0.684;%in mm2

H_corner=18;S_corner=2;%in mm  
x0_corner=5.172;y0_corner=x0_corner;%in mm  
Ix_corner=2040;Iy_corner=Ix_corner;%in mm4
k=0.385;
b1_corner=H_corner-S_corner/2;
sigma_o_kp = k *E/((b1_corner/ S_corner)^2);%MPa
sigma_p=190;%比例极限
if sigma_o_kp>sigma_p
sigma_star = sigma_o_2 + ((sigma_o_2 - sigma_p)^2) / (0.002*E);
end
s = sqrt(1 + (4*sigma_star*sigma_o_kp) / ((sigma_star - sigma_p)^2));
sigma_kp1 = sigma_star *(s-1)/ (s+1);
h_wall1=ceil(abs(M_max)/ (2 * F1 * sigma_kp1));
delta_wall=ceil(alpha_belt * h_wall1^(1/3)); 
delta_covering=2.2;
t1 = 30; %mm
P_cp1 = abs(Q_max)*t1/h_wall1;%铆钉和墙
tao_B_D16AT=250;
F1_rivet=P_cp1/tao_B_D16AT;
d1_rivet=ceil(sqrt(2*F1_rivet/pi));%四舍五入到指定位数round(X, N)
t2=t1;
P_cp2 = abs(max(theta(:,5)))*t2/2;%铆钉和蒙皮
d2_rivet=ceil(sqrt(4*P_cp2/pi/tao_B_D16AT));
%% 2.4 桁架校验
%正应力
b0=30*delta_covering+delta_wall+H_corner+S_corner;
F=h_wall1*delta_wall+4*F1+b0*delta_covering...
    -2*d1_rivet*(delta_wall+2*S_corner)-2*d2_rivet*(delta_covering+S_corner);
S_x = b0 * delta_covering * (h_wall1+delta_covering)/2- 2*d2_rivet*(delta_covering+S_corner)* (h_wall1/2 +delta_covering-(delta_covering+S_corner)/2);
y_c = S_x /F;
y1_rivet=(H_corner-S_corner)/2+S_corner;
h1_rivet=h_wall1-2*y1_rivet;
I_wall = delta_wall * h_wall1^3 / 12 ;
I_covering=b0*delta_covering^3/ 12+delta_covering * b0 * (h_wall1/2 + delta_covering/2)^2;
I_corner=4*(Ix_corner+F0*(h_wall1/2-y0_corner)^2);
I_rivet= 2 * (d1_rivet^3 * (delta_wall+2*S_corner) / 12+d1_rivet*(delta_wall+2*S_corner) * (h1_rivet/2)^2)...
        +2 * (d2_rivet*(delta_covering+S_corner)^3 / 12+ d2_rivet*(delta_covering+S_corner)*(h_wall1/2 +delta_covering-(delta_covering+S_corner)/2))^2;
I = I_wall + I_covering +I_corner- I_rivet-F*y_c^2;

distance=[h/2-y_c h/2 + y_c];M=[M_max M_min];N=[N_coor1 N_coor2];
sigma_p_section = (M / I)*distance' + (N/ F);
sigma_p_tensile= max(sigma_p_section);
sigma_p_compressive= abs(min(sigma_p_section));
k_buckle_B = 0.8; % Buckling coefficient for point B
sigma_b = 440; % Ultimate or yield stress in MPa
eta_buckle = k_buckle_B * sigma_b / sigma_p_tensile;
eta_stability = sigma_kp1 / sigma_p_compressive;
%切应力
%横截面重心以上部分的静力矩
S_above_wall= (1/2) * (delta_wall*(h_wall1/2 - y_c)^2) + ...
    b0*delta_covering*(h_wall1/2 - y_c - delta_covering/2) + ...
    2*F0*(h_wall1/2 - y_c - y0_corner) - ...
    d1_rivet*(delta_wall+2*S_corner) * (h1_rivet/2- y_c)-...
    2*d2_rivet*(delta_covering+S_corner)*(h_wall1/2 - y_c+(delta_covering-S_corner)/2);
tau_p_max = (Q_max * S_above_wall) / (I * delta_wall); % in MPa
tau_0_kp = (4.8 * E * delta_wall^2) / (h1_rivet^2); % in MPa
tau_m = sigma_p / sqrt(3); % in MPa
if tau_0_kp>tau_m
tau_star = sigma_star / sqrt(3); % in MPa
tau_kp = tau_star*tau_0_kp/(tau_0_kp + tau_star - tau_m); % in MPa
eta_tao_wall= tau_kp / tau_p_max;
else
  eta_tao_wall= tau_0_kp / tau_p_max;  
end
S_above_rivet= 0+...
    b0*delta_covering*(h_wall1/2 - y_c - delta_covering/2) + ...
    2*F0*(h_wall1/2 - y_c - y0_corner) - ...
    d1_rivet*(0+2*S_corner) * (h1_rivet/2- y_c)-...
    2*d2_rivet*(delta_covering+S_corner)*(h_wall1/2 - y_c+(delta_covering-S_corner)/2);
P_r1 = (abs(Q_max) * S_above_rivet) / I * t1; %铆钉和墙
P_lcp = (pi * d1_rivet^2) / 4 * (tao_B_D16AT);
eta_shear = (2 * P_lcp) / P_r1;
P_r2=P_cp2;%铆钉和蒙皮
P_2cp = (pi * d2_rivet^2) /4*(tao_B_D16AT);
eta_2 = P_2cp / P_r2;
%disp(['Force on rivet 1 (P_r1): ' num2str(P_r1) ' N']);
%弯曲
sigma_p_cm = P_r1 / (d1_rivet * delta_wall); %墙
safety_factor_b = 1.3; % Safety factor for material stress
sigma_cm_allow = safety_factor_b * sigma_b; % in MPa
eta_wall = sigma_cm_allow / sigma_p_cm;
sigma_p_cm_flange = P_r2 / (d2_rivet * delta_covering); %蒙皮
eta_flange = sigma_cm_allow / sigma_p_cm_flange;
%% 3.1.1 罐体参数
f=1.2;
R_H=2450;%mm
R=1650;%mm
R_hatch=425/2;%mm
p0=0.18;g=9.81;
rho_UDMH=1140;
h = R_H - sqrt(R_H^2 - R^2);%mm
h=.001*h;%m
c=3*h/8;
N_work=140e3;Q_work=90e3;M_work=330e6;
k_sw=0.85;sigma_B=320;sigma_p=120;l_mainstay=2.4e3;%mm
t=60;V=554.6;H=3;q=46059;nx=3.5;
p_ne = p0 + rho_UDMH * g * nx * H*1e-6; % Operational internal pressure内部运行压力
p_maxe = p0 + rho_UDMH * g * nx* (H + h)*1e-6; % Max operational pressure
p_top=p_maxe;
%连接部校验
delta_Shell= ceil((f * p_ne * R) / (k_sw * sigma_B));%mm
sigma_11_joint_min=f*(N_work/(2*pi*R*delta_Shell)-M_work/(pi*(R)^2*delta_Shell));%经向应力
sigma_11_joint_max=f*(N_work/(2*pi*R*delta_Shell)+M_work/(pi*(R)^2*delta_Shell));
tao_max=f*Q_work/(pi*R*delta_Shell);%切向应力
delta_bottom = ceil((f * p_maxe * R_H) / (2*k_sw * sigma_B));
delta_upper_bot = ceil((f * p0 * R_H) / (2*k_sw * sigma_B));
% 罐体参数计算
theta_0 = asind(R / R_H);
if theta_0<=60
    k = 0.6;
else
    k=0.7;
end
l = k * sqrt(R*delta_Shell); 
l_0 = k * sqrt(R_H*delta_bottom); 
alpha_0=theta_0-180*l_0/pi/R_H;
C=R_H*cosd(theta_0)-l;
Omega_1 = -0.5 * C^2 * tand(alpha_0); 
Omega_2 = 0.5 * l^2 *tand(theta_0)+ 0.5 *R_H*l_0 - 0.5 * C^2 * (tand(theta_0) - tand(alpha_0)); 
Omega = Omega_1 + Omega_2;
N_prime = f * p_maxe * Omega;
F_lower_bound = abs(N_prime) /sigma_B - delta_Shell * l - delta_bottom * l_0;
F_brochure=F_lower_bound;
b=sqrt(6*F_brochure/atand(theta_0));
a=2*F_brochure/b;
%% 3.2 罐体稳定性
E = 6.8 * 10^4;
% 法向应力
k0=0.605-0.545*(1-exp(-sqrt(R/delta_Shell)/16));
alpha_kp = (p_ne * R^2) / (E * delta_Shell^2);
kp = (1 + 0.21 * alpha_kp*(R/delta_Shell)^(0.6)) / (1 + 3 * alpha_kp);
km = (N_work*R-2.5*M_work)/(N_work*R-2*M_work);
E_k(1)=E; E_c(1)=E;
ki(1)=sqrt(E_k(1)*E_c(1))/E;
k1(1)= k0*kp*km*ki(1);
sigma_kp(1) = k1(1) * (E * delta_Shell) / R;% Critical stress
sigma2 = p_ne * R/delta_Shell;
y(1)=sigma_kp(1)/sigma2;
sigma_i(1) = sigma2 * sqrt(1 + y(1) + y(1)^2);
[epsilon_1_sigma,i_sigma,count_sigma,sigma_kp,~]=shell1(sigma_i(1),sigma_p,k0,kp,km,delta_Shell,R,sigma2,sigma_kp(1),0);
sigma_compressed=sigma_11_joint_max;
eta_normal=sigma_kp(end)/sigma_compressed
%切向应力
P_KP = 0.92 * E *delta_Shell^2/l_mainstay/R * sqrt(delta_Shell / R) ;
k_p = sqrt(1 + (p_ne / P_KP)); 
k_i(1)=1;
tau_OKP =0.78 * E *delta_Shell/R * power(delta_Shell*R/l_mainstay^2,1/4) ;
tau_KP_1(1) = k_p*k_i*tau_OKP;
sigma_1_=N_work/(2*pi*R*delta_Shell);
sigma_i_(1)= sqrt((sigma_1_)^2 + (sigma2)^2 - sigma_1_*sigma2+ 3*(tau_KP_1(1))^2);
[epsilon_1_tao,i_tao,count_tao,~,tau_KP_1]=shell1(sigma_i_(1),sigma_p,1,k_p,1,delta_Shell,R,sigma2,tau_KP_1(1),sigma_1_);
% disp(['Lambda_i: ', num2str(lambda_i)]);
tao_max=abs(sigma_11_joint_min);
eta_tangential=tau_KP_1(end)/tao_max
%% 4.2 非密封隔间参数
E = 7.2 * 10^4; a=0.6;f=1.3;n_c=4;
R=1500;L=4800;F_crossbar=800;%mm
sigma_b = 440; tao_b = sigma_b*a;
sigma_02 = 270;tao_02 = sigma_02*a;
sigma_p = 190; tao_p = sigma_p*a;
ai=[-3814 -1907 -244
    614 1075 2872
    85 178 432];
ai_p=ai*f;%KN
%见6.13 0.8 1 1.2 1.5 1.8 2 2.5 3 3.5 4 5
delta_skin= 4 * max(ai_p(3,:)*1e3) / (pi * R * sigma_b);
delta_skin=1.2
N_equivalent=ai_p(1,:)+2*abs(ai_p(3,:))/(R*1e-3);
N_equivalent_max=max(N_equivalent);
F_c= N_equivalent_max*1e3/ n_c/sigma_b
%问题1：查表，表在哪里呀？？
n_beam = 39; %需要改
B=20;%需要改
S=2;%需要改
F_beam=126.1;%需要改
I_beam=20120;%需要改
y0_beam=14.88;%需要改
H_beam=14.88;%需要改
b1=B-S/2;
b = 2 * pi * R /(n_c + n_beam);
sigma_kr_covering = 3.6 *E/ (b/delta_skin)^2 + 0.15 * E * delta_skin/R; 
tau_kr_covering = 5 * E / (b/delta_skin)^2 + 0.1 * E * delta_skin/R; 
k = 0.385; 
sigma_kp0_topical = k * E /(b1/S)^2;
if sigma_kp0_topical>sigma_p
sigma_ast = 1.2 * sigma_02; 
sigma_kp_topical = sigma_ast - (sigma_ast - sigma_p) * sqrt(sigma_p / sigma_kp0_topical);
end
b_practical_covering= b * sqrt(sigma_kr_covering/sigma_kp_topical); 
F = F_beam + b_practical_covering * delta_skin;
S_x_prime = b_practical_covering * delta_skin*(y0_beam+delta_skin/2);
c = S_x_prime/F; 
I_x_prime = I_beam + b_practical_covering*delta_skin*(y0_beam + delta/2)^2;
I_x = I_x_prime - F * c^2;
c_coef = 2; 
l = L/(n_c+ 1);
sigma_kp0_general= c_coef * pi^2 * E * I_x /l^2 / F; 
if sigma_kp0_general>sigma_p
sigma_kp_general = sigma_ast - (sigma_ast - sigma_p) * sigma_p / sigma_kp0_general;
end
sigma_kp_beam=min(sigma_kp_topical,sigma_kp_general);
%% 4.3 计算危险截面法向和切向应力
y_0= -(R^2 *ai_p(1,:)) ./ (2 * ai_p(3,:));
for i=1:3
if y_0(i)>0
b_npi(i)=b/2;
else
b_npi(i)=b;
end
end
Phi=1;
%这里的面积和惯性矩是真难算,你需要好好想想
Fi_belt=[F_beam F_c];
Fi=Fi_belt+b_npi*delta_skin;
F_sum=2*Fi*Phi;

Sz=2*Fi*Phi.*yi;Sz=0;
Jz=2*Fi*Phi.*yi.^2;
y_c=Sz/F;y_c=0;

A=(ai_p(3,:)-y_c*ai_p(1,:))./Jz;
B=ai_p(1,:)/F-A*y_c;
y0=-B./A;
%% 4.4 许用应力计算
alpha_i_deg = 57.876; %需要改
tau13 = 5.235; %需要改
R_tau_i = 0.031;%需要改
R_sigma_i=0.99;%需要改
if l/b>2
    xi = 600 * (delta_skin/ R);
else
    xi = 300 *l/b* (delta_skin/ R);  
end
R_tau_13=0.031;%需要改
tau_kp_0 = tau_kr_covering;
tau_kp13 = R_tau_13*tau_kp_0;
omega_13 = tanh*((0.5+xi)*log(5.235 * R_tau_i));
sigma_x13 = omega_13*tau13*cotd(alpha_i_deg);
sigma_theta13 = omega_13*tau13*tand(alpha_i_deg);
b_i_bar_13 = 0.5 * R_tau_i * (1 - omega_13) *b;
F_13_star =F_beam+b_i_bar_13*delta_skin;
sigma_prime_13 = -(omega_13*tau13*delta_skin*R*cotd(alpha_i_deg)) / F_13_star;

q13 = (xi*tau13*b*delta_skin* tand(alpha_i_deg)) / (2 * R);
M_max_13 = (q13 * l^2)/8;
sigma_r13 = -183.64; %需要改
phi13 = 1;
sigma_13_0=phi13*sigma_r13;
sigma_kr13 = R_sigma_i *sigma_kr_covering;
b_pro_13 = b * R_sigma_i*sqrt(sigma_kr13/abs(sigma_13_0));
a0 = b_pro_13*delta_skin*(y0 + delta_skin/2)/(b_pro_13*delta_skin+F_beam);
a1 = y0-a0;
a2 = H_beam-a1;
I_i =I_beam+b_pro_13*delta_skin^3/12 + b_pro_13 *delta_skin*(a1 + delta/2)^2;
sigma_ast1 = -M_max_13 * a1 / I_i;
sigma_ast2 = M_max_13 * a2 / I_i;
sigma_str131 =sigma_13_0+sigma_prime_13+sigma_ast1;
sigma_str132 =sigma_13_0+sigma_prime_13+sigma_ast2;

%% 4.5 确定负载最重的受力元件（钢绞线、钢梁、蒙皮板、铆钉）的安全系数
sigma_eqv_13 = sqrt(sigma_x13^2 - sigma_x13 * sigma_theta13 + sigma_theta13^2 + 3 * tau13^2);
t=25;d=2.5;
k_zakl = (t-d)/d; 
eta_covering= k_zakl * sigma_b / sigma_eqv_13;
eta_stab =sigma_kp_general/abs(sigma_13_0+sigma_prime_13);
eta_str1 =sigma_kp_topical/abs(sigma_str131);
eta_str2 =sigma_b/abs(sigma_str132);
P1 = sigma_x13 *delta_skin* t;
P2 = tau13 *delta_skin* t;
P = sqrt(P1^2 + P2^2);
tau_sr=sigma_b/sqrt(3);
P_sr_str = tau_sr * pi * (d/2)^2;
eta_sr_obsh = P_sr_str / P;

tau12=5.393;%改
sigma_theta12=0;%改,妈的，真的要算
P1_str = (tau13 - tau12)*delta_skin*t;
P2_str = (sigma_theta13- sigma_theta12)*delta_skin*t;
P_str = sqrt(P1_str^2 + P2_str^2);
eta_sr_str = P_sr_str / P_str;

% saveAllFigures("K:\Matlab\code\mechaincs\launch_vehicle\load\fig")