clc;clear;close all
%% 已知U,S,Vx,火箭级数，mbh
rand('state',sum(clock));
%每次产生随机数的时候，随机数生成器触发器的状态都会翻转一次。伪随机数，生成时间相关的随机数，和当前时间相关。
%如果计算机运算太快的话，可能会生成相同随机数
%tic
N=50001;pmin=1e10;mbh=6100;H=620;
u=[3237 3000 2600 2600 ];
S=[8  10  8  6];
Vx =11190*sqrt(1-6371/2/(6371+H+1.65));
input=4;
dV=zeros(length(N),input);
for i=1:N   %只要次数够高，最后肯定是实际的最优值
    k=0.8+0.4*rand(1,input-1);%产生一行2列的区间在[0,1]上的随机整数 randi
    dV(i,:)=[k*Vx (input-sum(k))*Vx]/input;
    Z_(i,:)=exp(dV(i,:)./u(1:input));
    P_(i,:)=Z_(i,:).*(S(1:input)-1)./(S(1:input)-Z_(i,:));
    P0_(i)=prod(P_(i,:)); %相当于主函数
    %% 可以添加if条件约束
    if P0_(i)<pmin %求解有效载荷系数最小值(求解火箭结构的质量上限)
        pmin=P0_(i);
        Z_0=Z_(i,:);
        P_0=P_(i,:);
        V_x=dV(i,:);
        P0_0=P0_(i);%记录当前较好的解
        m0=mbh*P0_0;
    end
end
Z_0 %%如果添加\t
P0_0
fprintf('%.2f\t',V_x) 
fprintf('%.2f\n',m0) 
%toc 



