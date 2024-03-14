function [epsilon_1,sigma_i,count,sigma_kp,tau_KP_1]=shell(e,sigma_p,k0,kp,km,delta_Shell,R,sigma2,ee,sigma_1_)
E = 6.8 * 10^4;%MPa
a = 1.4;d = 0.032;b = 0.146;c = 0.0108;ge = 0.779;
sigma_i(1)=e;sigma_kp(1)=ee;
tau_KP_1(1)=ee;
for i=1:1000
    count=i;
    if sigma_i(i)>sigma_p
        if i>1
            epsilon_1(i) = sigma_i(i)*E/ (sigma_p*E_c(i));
        else
            epsilon_1(1) = sigma_i(1)/ sigma_p;
        end
       if epsilon_1(i)>1
            E_k(i+1) = E * ( (b / (epsilon_1(i) - ge)^2) - (2*c / (epsilon_1(i) - ge)^3) + d );
            E_c(i+1) = (E / epsilon_1(i)) * ( (a - b/(epsilon_1(i) - ge) - c/(epsilon_1(i) - ge)^2 + d * epsilon_1(i)) );   
        end
        ki(i+1)=sqrt(E_k(i+1)* E_c(i+1))/E;
        k1(i+1)= k0*kp*km*ki(i+1);
        sigma_kp(i+1) = k1(i+1) * (E * delta_Shell) / R;
        tau_KP_1(i+1) = k1(i+1)*tau_KP_1(i);
        if k0 ==1 && km ==1
            if tau_KP_1(i+1)<tau_KP_1(i)*(1+0.01) && tau_KP_1(i+1)>tau_KP_1(i)*(1-0.01)
                break;
            else
                sigma_i(i+1)= sqrt((sigma_1_)^2 + (sigma2)^2 - sigma_1_*sigma2+ 3*(tau_KP_1(i+1))^2);
            end
        else
            if sigma_kp(i+1)<sigma_kp(i)*(1+0.02) && sigma_kp(i+1)>sigma_kp(i)*(1-0.02)
                break;
            else
                y(i+1)=sigma_kp(i+1)/sigma2;
                sigma_i(i+1) = sigma2 * sqrt(1 + y(i+1) + y(i+1)^2);
            end
        end
        % % Remove zero elements
        % sigma_kp = sigma_kp(sigma_kp ~= 0);
        % tau_KP_1 = tau_KP_1(tau_KP_1 ~= 0);
    end
end