function plotWithAnnotations(frame_data, y_data, figure_number,  y_label)
    figure(figure_number);
    plot(frame_data, y_data); % 绘制数据
    
    ylabel(y_label); % 设置y轴标签
    xlabel('Frame'); % 假设frame_data代表帧数
    % 初始化一个空数组，用于存储已标注的值
    annotatedValues = [];   
     % 用于记录上一个添加标注的值
    lastAnnotatedValue = inf;
    % 用于调整标注位置
    offset = mean(diff(y_data)) / 10;  % 一个基于数据变化范围的小偏移量
    % 遍历所有数据点
    for i = 1:length(y_data)
        currentValue = y_data(i);
        % 检查当前值是否已经被标注
        if ~ismember(currentValue, annotatedValues)
        % 只有当当前值和上一个添加标注的值不同时才添加标注
            if abs(currentValue - lastAnnotatedValue) > offset
            text(frame_data(i), currentValue, sprintf('%0.2f', currentValue), ...
                'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
                'FontSize', 8);  % 调整字体大小为8
            lastAnnotatedValue = currentValue;            % 将当前值添加到已标注的数组中
            annotatedValues = [annotatedValues, currentValue];
            end
        end
    end
end
