function [epsilon_1,sigma_i,count,sigma_kp,tau_KP_1]=shell1(e,sigma_p,k0,kp,km,delta_Shell,R,sigma2,ee,sigma_1_)
E = 6.8 * 10^4;%MPa
A= 1.2406;B = 0.095603;C=0.0108;D= 0.059312;G = 0.6812;
a=A;b=B;c=0;d=D;ge=G;
%程序中输入的是ABDC
sigma_i(1)=e;sigma_kp(1)=ee;
tau_KP_1(1)=ee;
i=1;    epsilon_1(1) = sigma_i(1)/ sigma_p;
while(sigma_i(i)>sigma_p)
    count(i)=i;
    %陷入死循环的错误代码
%     while(epsilon_1(i)>1)
%         E_k(i+1) = E * ( (b / (epsilon_1(i) - ge)^2) - (2*c / (epsilon_1(i) - ge)^3) + d );
%         E_c(i+1) = (E / epsilon_1(i)) * ( (a - b/(epsilon_1(i) - ge) - c/(epsilon_1(i) - ge)^2 + d * epsilon_1(i)) );
%     end
    while(epsilon_1(i)>1)
        E_k(i+1) = E * ( (b / (epsilon_1(i) - ge)^2) - (2*c / (epsilon_1(i) - ge)^3) + d );
        E_c(i+1) = (E / epsilon_1(i)) * ( (a - b/(epsilon_1(i) - ge) - c/(epsilon_1(i) - ge)^2 + d * epsilon_1(i)) );
%         E_k(i+1) = E * ( B/(epsilon_1(i) - G)^2 + D );
%         E_c(i+1) = (E / epsilon_1(i)) * (A- B/(epsilon_1(i) - G) + D * epsilon_1(i));
        i=i+1;
        ki(i)=sqrt(E_k(i)* E_c(i))/E;
        k1(i)= k0*kp*km*ki(i);
        sigma_kp(i) = k1(i) * (E * delta_Shell) / R;
        tau_KP_1(i) = k1(i)*tau_KP_1(i-1);
        if k0 ==1 && km ==1
            if tau_KP_1(i)<tau_KP_1(i-1)*(1+0.01) && tau_KP_1(i)>tau_KP_1(i-1)*(1-0.01)
                return
            else
                sigma_i(i)= sqrt((sigma_1_)^2 + (sigma2)^2 - sigma_1_*sigma2+ 3*(tau_KP_1(i))^2);
            end
        else
            if sigma_kp(i)<sigma_kp(i-1)*(1+0.02) && sigma_kp(i)>sigma_kp(i-1)*(1-0.02)
                return
            else
                y(i)=sigma_kp(i)/sigma2;
                sigma_i(i) = sigma2 * sqrt(1 + y(i) + y(i)^2);
            end
        end
        epsilon_1(i) = sigma_i(i)*E/ (sigma_p*E_c(i));
    end
    % % Remove zero elements
    % sigma_kp = sigma_kp(sigma_kp ~= 0);
    % tau_KP_1 = tau_KP_1(tau_KP_1 ~= 0);
end
end