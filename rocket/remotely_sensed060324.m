clc;clear;close all
%% 2.a 键入的时候/为小数点
H_work=520;i_work=97.45;Rz=6371;
H_ref=H_work-35;i_ref=96.6;

Lifespan=5*365;
resolution=4;
%% 2.b 设计质量和体积
m=535.08;rho=550;
V=m/rho;
%% 2.c 工作轨道时间
F=7.278;
C_x=2.2;S=(power(V,1/3))^2*6/4;
seigma=C_x*S/2/m;
t_work=F/seigma;
%% 2.d 工作轨道小3km时间
t_3=0;

%% 2.e 3km轨道下降时间和修正次数
dt=t_work-t_3;
frequency=t_work/t_3;
%% 2.f 速度冲量
ra=Rz+H_work;rpi=Rz+H_work-3;k=1;
dV1=sqrt(k/rpi)*(sqrt(2*ra/(ra+rpi))-1);
dV2=sqrt(k/ra)*(1-sqrt(2*rpi/(ra+rpi)));












