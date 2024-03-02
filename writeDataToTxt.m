function writeDataToTxt(Y_, Y, c, tube, cz, cz_0, ny, zz, filename)
    % 打开文件用于写入
    fid = fopen(filename, 'w');
    
    % 检查文件是否成功打开
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    
    % 写入数据到文件
    fprintf(fid, 'tabular1.7column2_Y=\n');
    fprintf(fid, '%.2f\n', Y_);
    
    fprintf(fid, 'Y=%.2f\n', Y);
    
    fprintf(fid, 'tabular1.7column3_c=\n');
    fprintf(fid, '%.2f\n', [c, tube/2]);
    
    fprintf(fid, 'da=%.2f\n', cz);
    
    fprintf(fid, 'tabular1.7column4_cz_0=\n');
    fprintf(fid, '%.2f\n', cz_0);
    fprintf(fid, '%.4f\n', ny);
    
    fprintf(fid, 'tabular1.7column5=\n');
    fprintf(fid, '%.2f\n', Y_ .* cz_0);
    
    fprintf(fid, 'Y_sum=%.2f\n', sum(Y_ .* cz_0));
    fprintf(fid, 'zz=%.4f\n', zz);
    
    % 关闭文件
    fclose(fid);
end
