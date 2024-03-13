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

%% find better sln
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
err(X_bottom,N(end),'err_N')

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
err(-1e3*(71.96-71.25),P5y,'err_Q5') %现在用的是i-1时刻减i时刻
err(-1e3*(66.98-65.52),P6y_,'err_Q6')%标准值  实验值
err(-1e3*(-798.7+798.8),M5,'err_M5')
err(-1e3*(-899.4+899.8),sum(M6),'err_M6')
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




%% 2.4 桁架表面计算



%% 3.1.1 罐体参数
f=1.2;
R_H=2450;
R=1650;R_hatch=425/2;
p0=0.18;g=9.81;
rho_UDMH=1140;
h = R_H - sqrt(R_H^2 - R^2);
V_ellipses=2*pi*R^2*h/3;
m_ellipses=rho_UDMH*V_ellipses;
c=3*h/8;

N_work=140e3;Q_work=90e3;M_work=330e6;
k_sw=0.85;sigma_B=320;sigma_p=120;l_mainstay=2.4;
t=60;V=554.6;H=3;q=46059;nx=3.5;

p_ne = p0 + rho_UDMH * g * nx * H*1e-6; % Operational internal pressure内部运行压力
p_maxe = p0 + rho * g * nx* (H + h)*1e-6; % Max operational pressure
p_top=p_maxe;
%连接部校验
delta_Shell= ceil((f * p_ne * R*1e3) / (k_sw * sigma_B));%mm

sigma_22_joint= (f * p_ne*R) / (delta_Shell)*1e3;
sigma_11_joint_min=f*(N_work/(2*pi*R*1e3*delta_Shell)-M_work/(pi*(R*1e3)^2*delta_Shell));
sigma_11_joint_max=f*(N_work/(2*pi*R*1e3*delta_Shell)+M_work/(pi*(R*1e3)^2*delta_Shell));
tao_max=f*Q_work/(pi*R*1e3*delta_Shell);
sigma_11_joint=[sigma_11_joint_max sigma_11_joint_min f*(N_work/(2*pi*R*1e3*delta_Shell))];
tao_max_joint=[0 0 tao_max];
sigma_ekv_joint=sqrt(sigma_11_joint.^2 - sigma_11_joint * sigma_22_joint + sigma_22_joint^2+3*tao_max_joint.^2); % Equivalent stress
eta_joint = (k_sw * sigma_B) / max(sigma_ekv_joint)

delta_bottom = ceil((f * p_maxe * R_H*1e3) / (2*k_sw * sigma_B));
% 罐体参数计算
theta_0 = asind(R / R_H);
if theta_0<=60
    k = 0.6;
else
    k=0.7;
end
l = k * sqrt(R*1e3*delta_Shell); 
l_0 = k * sqrt(R_H*1e3*delta_bottom); 
alpha_0=theta_0-180*l_0/pi/R_H;
C=R_H*cosd(theta_0)-l;
Omega_1 = -0.5 * C^2 * tand(alpha_0); 
Omega_2 = 0.5 * l^2 *tand(theta_0)+ 0.5 *R_H*l_0 - 0.5 * C^2 * (tand(theta_0) - tand(alpha_0)); 
Omega = (Omega_1 + Omega_2)*1e6;
N_prime = f * p_maxe * Omega;
F_lower_bound = abs(N_prime) / (k_sw * sigma_B) - delta_Shell * l - delta_bottom * l_0;
F_brochure=F_lower_bound*(1+0.1);
%问题一，这个数据我找不到
b=sqrt(6*F_brochure/atand(theta_0));
a=2*F_brochure/b;
%% 3.2 罐体稳定性
E = 6.8 * 10^4;
% 法向应力
k0= (1 / pi) * (100*delta_Shell / R) ^(3/8);
alpha_kp = (p_ne * R^2) / (E * delta_Shell^2);
kp = (1 + 0.21 * alpha_kp*(R/delta_Shell)^(0.6)) / (1 + 3 * alpha_kp);
km = (N_work*R-2.5*M_work)/(N_work*R-2*M_work);
E_k(1)=E; E_c(1)=E;
ki(1)=sqrt(E_k(1)/ E_c(1))/E;
k1(1)= k0*kp*km*ki(1);
sigma_kp(1) = k1(1) * (E * delta_Shell) / R;% Critical stress
sigma2 = p_ne * R/delta_Shell;
y(1)=sigma_kp(1)/sigma2;
sigma_i(1) = sigma2 * sqrt(1 + y(1) + y(1)^2);
[sigma_kp,~]=shell(sigma_i(1),sigma_p,k0,kp,km,delta_Shell,R,sigma2,0,0);
sigma_compressed=23.87;%% 这个数我找不到！！！
eta_normal=sigma_kp(end)/sigma_compressed
%切向应力
P_KP = 0.92 * E *delta_Shell^2/l_mainstay/R * sqrt(delta_Shell / R) ; % First equation
k_p = sqrt(1 + (p_ne / P_KP)); 
k_i(1)=1;
tau_OKP =0.78 * E *delta_Shell/R * power(delta_Shell*R/l_mainstay^2,1/4) ;
tau_KP_1(1) = k_p*k_i*tau_OKP;
sigma_1_=N_work/(2*pi*R*delta_Shell);
sigma_i_(1)= sqrt((sigma_1_)^2 + (sigma2)^2 - sigma_1_*sigma2+ 3*(tau_KP_1(1))^2);
[~,tau_KP_1]=shell(sigma_i_(1),sigma_p,1,kp,1,delta_Shell,R,sigma2,tau_KP_1(1),sigma_1_);
% disp(['Lambda_i: ', num2str(lambda_i)]);
tao_max=16.114;%% 这个数我找不到！！！
eta_tangential=tau_KP_1(end)/tao_max
%% 4.1 非密封隔间模型图


%% 4.2 非密封隔间参数



%% 4.3 计算危险截面法向和切向应力



%% 4.4 许用应力计算


%% 4.5 确定负载最重的受力元件（钢绞线、钢梁、蒙皮板、铆钉）的安全系数




saveAllFigures("K:\Matlab\code\mechaincs\launch_vehicle\load\fig")
















