function err(X_bottom,N,x)
%if 理论值 实验值 {除的实验值，计算的实验误差}
err=abs(X_bottom-N)/abs(N);
fprintf('%s =%.6f\n',x,err)
end