clear
f0=9.65*10^6;
lamda=0.031;
deltaF=600*10^6;
P=8000;
R3=6.371*10^6;
miu=3.986*10^14;
betaymmax=45;
betaymmin=20;
betaym=45;
for n=1:10
    HKA=250*10^3+n*50*10^3;
    V0=sqrt(miu/(R3+HKA));
    r=R3+HKA;
    gama=acosd((1+HKA/R3)*sind(betaym));
    betakr=asind(R3/(R3+HKA));
    T=2*3.14*(R3+HKA)^1.5/sqrt(miu);
    Tc=86400;
    N=Tc/T;
    L=2*3.14*R3/N;
    ai=2.634*10^10;
    i=acosd(-2*3.14*sqrt(miu/10^9)/(31556925*ai)*((r/10^3)^3.5));
    Robz=HKA*tand(betaymmax)-HKA*tand(betaymmin);
    RH=R3*cosd(betaym+gama)/sind(betaym);
    NKA=ceil(L/Robz);
    kx=1.3;kr=1.45;c=3*10^8;
    sant1=4*kx*kr*V0*RH*lamda*tand(betaymmax)/c;
    N1=ceil(sant1/(0.75*0.75));
    sant=N1*0.75*0.75;
    if (NKA>10)
        Dyant=0.75;
        Dxant=sant/Dyant;
    else 
        Dyant=1.5;
        Dxant=sant/Dyant;
    end
    format shortE %以短格式显示数值，通常为四位小数精度
    x(n,:)=[HKA,i,Robz,NKA,Dxant,Dyant];
end
% xlswrite("gaolaoshi\PCA.xlsx",x,1,'B2');
