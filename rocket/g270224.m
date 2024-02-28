clc;clear;close all
e = 2.634e-3;
mu = 398600; %  km^3/s^2
i = acos((2 * pi * T) / (Tr * c));
c = -((2 * pi)^(7/3)) / ((1 - e^2)^(7/6) * (T_r^5 * mu^3)^(1/3));

%% camera
b = 6e-3; % 元素的尺寸
n = 0.5; % 用于识别被摄物体的元素对数量
H = 300e3; % 轨道高度
D = 27000; % 元素数量
gamma = 0; % 摄影倾角

f = (n * 2 * b) / D*H; % ОЭТК的焦距
l = N * b; % ИСЗ-линеика的长度
B = l / (f * H); % 捕获条带的宽度
alpha = 2 * atan(B / (2 * H)); 
kT3 =2.25;  %????
DT3 = kT3 * l;
kD = 1.2; kf=1.7;
D_OETK = kD * DT3; 
L_OETK = f / kf;
%%%?????
gamma = alpha / 2; 
theta_kr = gamma + alpha / 2;
theta = 0; % Угол тангажа
% ????
L = H * sqrt(1 + (tan(g))^2 + tan(theta)^2);
D1 = b * H / (cos(theta_kr) * f * cos(gamma_kr)^2);

H_new = D * f * cos(gamma_kr)^2 / b;

B2 = ...; % полоса захвата на надире, задайте значение или формулу расчета

O = 2 * tan(gamma_kr) * H_new + 1 / (f * cos(gamma_kr)^2);

mu = 3.986e+14; % гравитационная постоянная Земли (м^3/с^2)
Rz = 6371e+3; % средний радиус Земли (м)
T = 2 * pi * sqrt((Rz + H_new)^3 / mu); % период орбиты (с)

Tc = ...; % продолжительность суток (с)
N = Tc / T; % число витков (количество оборотов в сутки)

%% lidar  laser激光




