clc;clear;close all
fopen('lidar290224.txt', 'w');%清空之前的内容
de=1.5;
B=40;
T_o=12;%min
e = 2.634e-3;c=3e8;
lamba=0.7;dF=10;f0=0.43;
%mu = 398600; %  km^3/s^2
mu = 3.986e+14; % м^3/с^2
R3 = 6371e+3; %  м
for H_KA=300e3:20e3:700e3
    V0=sqrt(mu/(R3+H_KA));
    beta_ym=deg2rad(45);beta_ym_min=20;beta_ym_max=45;
    gamma = acos((1+H_KA/R3)*sin(beta_ym)); % 摄影倾角
    beta_kp=asin(R3/(R3+H_KA));
    if beta_kp>beta_ym
        disp(1)
    end
    T = 2 * pi * sqrt((R3 + H_KA)^3 / mu); %(с)
    Tc = 86400; % (с)
    N_T = Tc / T;
    L = 2 * pi * R3/N_T;
    i = acosd(-(2 * pi * sqrt(398600)*((R3+H_KA)*1e-3)^(7/2)) / (31556925 * 2.634e10));%[0,pi]
    R_obc=H_KA*(tand(beta_ym_max)-tand(beta_ym_min));
    R_H=R3*cos(beta_ym+gamma)/sin(beta_ym);
    N_KA=ceil(L/R_obc);

    kx = 1.3; kr=1.45;lamba=0.031;
    S_judge=4*kx*kr*V0*R_H*lamba*tand(beta_ym_max)/c;
    shu=ceil(S_judge/(0.75*0.75));%所需设备数量
    S_ant=0.75*0.75*shu;
    if N_KA>10
        D_yant=0.75;
        D_xant=S_ant/D_yant;
    else
        D_yant=1.5;
        D_xant=S_ant/D_yant;
    end
    %     if S_ant>S_judge
    %         D_xant=S_ant/D_yant;
    %     end
    %     S_judge
    tao=1/6e8;
    delta_y_d=c*tao/2/cos(gamma);
    gamma1=gamma;gamma2=gamma1+dF/f0*tan(gamma1);
    gamma_i=(gamma1+gamma2)/2;
    delta_y_l=c/2/(dF*sin(gamma_i)+2*f0*cos(gamma_i)*sin(gamma_i/2));
    T_a=1.2;%????
    delta_x_d=lamba*R_H/2/V0/T_a;
    R_x=lamba*R_H/D_xant;
    R_y=lamba*R_H/D_yant;
    %R_ax=sum(R_y);%数量是多少？
    N=ceil(R_obc/R_y);%向上取整
    delta_x_lidar=kr*D_xant*(N+1)/2;
    delta_y_lidar=delta_x_lidar;

    P_n=9.6e-11;L=2.5;lamba_10=0.031;P=8000;
    G=4*pi*D_xant*D_yant/lamba_10^2;
    seigma_n_0=(4*pi)^3*P_n*L*R_H^4/(lamba_10^2*P*G^2*R_x*R_y);
    seigma_n_0=10*log10(seigma_n_0);
    seigma_0=10*log10(4*pi*delta_x_d*delta_y_d/lamba_10^2);
    N_HH=20;%不定
    delta_r=floor(10*log10(1+1/sqrt(N_HH)*(1+abs(seigma_n_0)/seigma_0)));%向下取整
    writeDataToTxt(H_KA, i, R_obc, N_KA, D_xant, D_yant, 'lidar290224.txt');
end
%% lidar  laser激光




