function saveAllFigures(outputFolder)
% saveAllFigures - 保存所有打开的MATLAB图形到指定文件夹
% outputFolder (string) - 图形将被保存到这个文件夹路径
% 获取打开的图形句柄
figures = findobj('Type', 'figure');%bug.先进后出
[~,idx]=sort([figures.Number]);%解决上述bug
figures=figures(idx);
% 不存在则创建
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 检查是否有图形打开
if isempty(figures)
    disp('No figures to save.');
    return;
end
% 遍历所有图形并保存
for i = 1:length(figures)
    figure(figures(i));
    figureName = fullfile(outputFolder, sprintf('Figure_%d.png', i));
    saveas(gcf, figureName, 'png');
end
disp('All figures have been saved successfully.');
end
