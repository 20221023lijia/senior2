function writeDataToTxt(H_KA, i, R_obc, N_KA, D_xant, D_yant, filename)
    fid = fopen(filename, 'a');%追加写入，不覆盖
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    
    fprintf(fid,'H_KA=%.2f\n',H_KA);
    fprintf(fid,'i=%.2f\n',i);
    fprintf(fid,'R_obc=%.2f\n',R_obc);
    fprintf(fid,'N_KA=%.2f\n',N_KA);
    fprintf(fid,'D_xant=%.2f\n',D_xant);
    fprintf(fid,'D_yant=%.2f\n',D_yant);
    fprintf(fid,'\n');
    fclose(fid);
end
