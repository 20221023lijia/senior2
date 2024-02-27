clc;clear;close all
%% 12  不用单位换算
u=[3237 3000 2600]; %m/s
mbh=6.8; m0=307.4; %ton
mbt=[160.8 90.3 22.3];
mb=[182 100 25.4 ];
ml=flip(cumsum(flip(mb),2)+mbh);%作用域在每个元素，按行和累加  % 沿向量的长度方向反转元素顺序
%% 计算Zi (min)
Z=ml./(ml-mbt)
%% 计算特征速度
Vx=u*log(Z)';
%% 有效载荷系数  
p0=(m0+mbh)/mbh;%注意m0不等于m1
for i=1:length(ml)-1
    p(i)=ml(i)/ml(i+1);%每次循环都会会输出所有的P
end
p(3)=p0/p(1)/p(2)  %会输出所有的P
%% 块设计卓越系数
S=Z.*(p-1)./(p-Z)
%% 计算Z和P 
Zs=prod(Z)  %累积相乘cumprod
P=p0;
%% 蒙特卡洛m150224
%% 函数调用非常不方便




