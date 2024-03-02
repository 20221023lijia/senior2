function err(X_bottom,N,x)
err=abs(X_bottom-N)/abs(X_bottom);
fprintf('%s =%.6f\n',x,err)
end