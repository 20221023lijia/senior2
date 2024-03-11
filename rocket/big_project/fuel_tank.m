clc;clear all ;close all;dbclear all
%% 2 基本参数确定  https://en.wikipedia.org/wiki/Long_March_2E
f=1.3;
H_stage2=14.223;D_stage2=3.35;%1 2 1 2  仪器舱 氧化剂 级间段 燃料
R_H=2.5;
R=D_stage2/2;R_hatch=425/2;l=0.75;H=2000;
p0=0.35;g=9.81;
rho_UDMH=793;beta=1.3e-4;
M_booster=4*40.754;
M_propellants=4*37.754;
M_PH=M_booster-M_propellants/2-M_propellants/4/2;

h = R_H - sqrt(R_H^2 - R^2);
V_ellipses=2*pi*R^2*h/3;
m_ellipses=rho_UDMH*V_ellipses;
c=3*h/8;

m_fuel=27.5;
m_perigee=1.9+9.2;
N_work=-302798.9;Q_work=103725.9;M_work=-728239.2;
k_sw=0.8;sigma_B=320;
t=60;V=554.6;H=12.3;q=46059;nx=2.34;rho_0=1.225;
rho=rho_0*exp(-beta*H);W=70;
V = sqrt(2 * q / rho);
alpha = atan2(W, V);
% 计算升力和阻力
H_fairing_sum=10.5;D_fairing=4.2;
H_fairing=[H_fairing_sum-1130-5400  5400 1130 ];
Y_conic=2*alpha*q*D_fairing^2*pi/4;

lambda_force=[H_fairing(2)/D_fairing  H_stage2*(1+2+1+2/2)/6/2/D_stage2];
%氧化剂和燃料进行整合？？？我有问题，这样绝对是错的
%??????????????????????????????????????
D_force=[D_fairing D_stage2];
Y_cylinder =1.5*lambda_force*alpha^2*q.*D_force.^2*pi/4;
Y=[Y_conic Y_cylinder];
Y_sum=sum(Y);
beta_X=0;D_max=max(D_fairing,D_stage2);
X=-2*(beta_X^2+alpha^2/2)*q*D_max^2*pi/2;

P=4*740.4;%KN
ny=(Y+P*0)/M_PH/g;
Q_bottom= m_ellipses*g*ny;
M_bottom= -Q_bottom * c;
l_Y=[H_stage2+H_fairing_sum-H_fairing(1)*2/3  H_stage2+H_fairing_sum-H_fairing(1)-H_fairing(2)/2   H_stage2*(1+2+1+2/2)/6/2];
M_Y=Y.*l_Y;
M=M_bottom+sum(M_Y);

Px=-pi*p0*R^2-nx*g*m_fuel;%这里公式我给改了????????
P_NH=-nx*g*m_perigee;
N_design=X+Px+P_NH;
M_design=M;
Q_design=Y_sum+Q_bottom;
%% 3 设计强度计算
H=H_stage2*2/6-h*(1+1/6);
p_ne = p0 + rho_UDMH * g * nx * H*1e-6; % Operational internal pressure内部运行压力
p_maxe = p0 + rho * g * nx* (H + h)*1e-6; % Max operational pressure
p_top=p_maxe;
delta_Shell= ceil((f * p_ne * R) / (k_sw * sigma_B)*1e3);%mm
delta_bottom = ceil((f * p_maxe * R_H) / (2*k_sw * sigma_B)*1e3);
delta_top = ceil((f * p_top * R) / (2*k_sw * sigma_B)*1e3);
% 底部强度校验
sigma_11_bot= (f * p_maxe*R_H) / (2 * delta_bottom)*1e3;
sigma_22_bot=sigma_11_bot;
sigma_ekv_bot = sqrt(sigma_11_bot^2 - sigma_11_bot * sigma_22_bot + sigma_22_bot^2); % Equivalent stress
eta_bot = (k_sw * sigma_B) / sigma_ekv_bot
%连接部校验
sigma_22_joint= (f * p_ne*R) / (delta_Shell)*1e3;
sigma_11_joint_min=f*(N_work/(2*pi*R*1e3*delta_Shell)-M_work/(pi*(R*1e3)^2*delta_Shell));
sigma_11_joint_max=f*(N_work/(2*pi*R*1e3*delta_Shell)+M_work/(pi*(R*1e3)^2*delta_Shell));
tao_max=f*Q_work/(pi*R*1e3*delta_Shell);
sigma_11_joint=[sigma_11_joint_max sigma_11_joint_min f*(N_work/(2*pi*R*1e3*delta_Shell))];
tao_max_joint=[0 0 tao_max];
sigma_ekv_joint=sqrt(sigma_11_joint.^2 - sigma_11_joint * sigma_22_joint + sigma_22_joint^2+3*tao_max_joint.^2); % Equivalent stress
eta_joint = (k_sw * sigma_B) / max(sigma_ekv_joint)

%% 3.2 横截面积计算
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
%问题三，手册在哪？？？
sigma_prime = N_prime / (F_brochure + delta_Shell * l + delta_bottom * l_0);
eta_brace= k_sw * sigma_B / abs(sigma_prime)

F_flangeless=f*p0*R*1e3*R_hatch/2/sigma_B;













