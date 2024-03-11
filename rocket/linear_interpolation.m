function F=linear_interpolation(H)  %520-540之间的数据手动计算
% sln1.多自变量插值
% H_0_interp = linspace(min(H_0), max(H_0), 1000);
% H_ = interp1(H_0, H__, H_0_interp, 'linear');%线性插值
%notice1.
% % %曲线拟合要求横坐标唯一，采样点唯一 
% % pp = spline(H_,F_cp);%样条拟合
% H_interp = linspace(min(H__), max(H__), 1000);
% % F_interp = ppval(pp, H_interp);% % 样条插值

H_0=[310 320 330:10:380 390:10:520 540:10:590 ...
    600 610 ...
    620:10:640 650:10:690 700];
H__=[52 53 55:60 62:75 76:81 ...
    82 96 ...
    97:99 101:105 107 ];
H_ = interp1(H_0, H__, H, 'linear');
F_cp=[ .1774 .2207 .2729 .3356 .4105 .4997 .6056 .7309  .8786 1.052 1.256 1.493 1.771 2.093 2.467 2.9 3.401 3.978 4.461  5.404 6.277 7.278  9.723 11.21 12.89 14.81 16.98 19.44 ... 
    22.23 25.31 ...
    28.8 32.52 36.7 41.33 46.47 52.13 58.32 65.17 72.7 ] ;
F_interp = interp1(H__, F_cp, H_, 'linear');
F=F_interp;
end
