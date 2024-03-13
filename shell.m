function [sigma_kp,tau_KP_1]=shell(e,sigma_p,k0,kp,km,delta_Shell,R,sigma2,ee,sigma_1_)
E = 6.8 * 10^4;%Mpa
i=1;
a = 1.4;d = 0.032;b = 0.146;c = 0.0108;ge = 0.779;
sigma_i(1)=e;
tau_KP_1(1)=ee;
% 初始化 sigma_kp 和 tau_KP_1
sigma_kp = zeros(1, 10000);
tau_KP_1 = zeros(1, 10000);
while( sigma_i(i)>sigma_p)
    if i>1
        epsilon_1(i) = sigma_i(i)*E/ (sigma_p*E_c(i));
    else
        epsilon_1(1) = sigma_i(1)/ sigma_p;
    end
    while(epsilon_1(i)>1)
        E_k(i+1) = E * ( (b / (epsilon_1(i) - ge)^2) - (2*c / (epsilon_1(i) - ge)^3) + d );
        E_c(i+1) = (E / epsilon_1(i)) * ( (a - b/(epsilon_1(i) - ge) - c/(epsilon_1(i) - ge)^2 + d * epsilon_1(i)) );
    end
    i=i+1;
    ki(i)=sqrt(E_k(i)/ E_c(i))/E;
    k1(i)= k0*kp*km*ki(i);
    sigma_kp(i) = k1(i) * (E * delta_Shell) / R;
    tau_KP_1(i) = k1(i)*tau_KP_1(i-1);
    if k0 ==1 && km ==1
        if tau_KP_1(i)<tau_KP_1(i-1)*(1+0.01) || tau_KP_1(i)>tau_KP_1(i-1)*(1-0.01)
            break;
        else
            sigma_i(i)= sqrt((sigma_1_)^2 + (sigma2)^2 - sigma_1_*sigma2+ 3*(tau_KP_1(i))^2);
        end
    else
        if sigma_kp(i)<sigma_kp(i-1)*(1+0.02) || sigma_kp(i)>sigma_kp(i-1)*(1-0.02)
            break;
        else
            y(i)=sigma_kp(i)/sigma2;
            sigma_i(i) = sigma2 * sqrt(1 + y(i) + y(i)^2);
        end
    end
    % Truncate sigma_kp and tau_KP_1 to the size of i
    sigma_kp = sigma_kp(1:i);
    tau_KP_1 = tau_KP_1(1:i);
end
end