clc;clear;close all
%% 2.a 键入的时候/为小数点
H_work=420;i_work=97.08;Rz=6371;
H_ref=H_work-35;i_ref=96.6;

Lifespan=5*365;
resolution=1.5; 
%% 2.b 设计质量和体积
m=575.01;rho=550;
V=m/rho;
%% 2.c 工作轨道时间
F=1.493;
C_x=2.2;S=(power(V,1/3))^2*6/4;
seigma=C_x*S/2/m;
t_work(1)=F/seigma;
%% 2.f 速度冲量、mass
P_yg0=3;%NS->KNS   ???需不需要换单位呢
mu=398600;
c=1;
ra=Rz+H_work;
m_m(1)=0;m_cm(1)=m;
while(H_work-3*c>H_ref-3 )%并|
rpi=Rz+H_work-3*c;
seigma1(c)=C_x*S/2/m_cm(c);
F(c)=linear_interpolation(H_work-3*c);
t_ref(c)=F(c)/seigma1(c);
dV1(c)=sqrt(mu/rpi)*(sqrt(2*ra/(ra+rpi))-1);
dV2(c)=sqrt(mu/ra)*(1-sqrt(2*rpi/(ra+rpi)));
dV(c)=dV1(c)+dV2(c);
z(c)=exp(dV(c)/P_yg0);%%这个数太小了
m_m(c)=m_cm(c)-m_cm(c)./z(c);
m_cm(c+1)=m_cm(c)-m_m(c);
t_work(c+1)=t_ref(c);
c=c+1;
end
%% 2.e 3km轨道下降时间和修正次数
dt=t_work(1:12)-t_ref;
frequency=t_work(1:12)./dt;
%% 3 total cost(质量成本(单位:kg))
cost_fuel1=46.06;cost_fuel2=228.56;
cost_2=sum(m_m.*frequency);
cost=cost_fuel1+cost_2+cost_fuel2;




