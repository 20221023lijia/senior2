function plot2s(frame_data,y_data, figure_number,  y_label)
figure(figure_number);
figureUnits = 'centimeters';
figureWidth = 30;
figureHeight = 15;

set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);

pos1 = [0.05 0.1 0.3 0.8];
subplot('Position',pos1)
RC=radarChart(y_data' ,'Type','Line');
RC.PropName =  cellstr(num2str(frame_data));
RC.ClassName=y_label;
RC=RC.draw();
RC.legend();
colorList=[78 101 155;
          138 140 191;
          184 168 207;
          231 188 198;
          253 207 158;
          239 164 132;
          182 118 108]./255;
for n=1:RC.ClassNum
     set(RC.PatchHdl(n),'Color',colorList(n,:),'LineWidth',1.8);
end
RC.setThetaTick('LineWidth',2,'Color',[.6,.6,.8]);          % theta轴颜色设置
RC.setRTick('LineWidth',1.5,'Color',[.8,.6,.6]);              % R轴颜色设置
RC.setPropLabel('FontSize',8,'FontName','Times New Roman','Color',[0,0,0])               % 属性标签
RC.setRLabel('FontSize',8,'FontName','Times New Roman','Color',[.8,0,0])

pos2 = [0.43 0.15 0.5 0.7];
subplot('Position',pos2)
plot(frame_data, y_data);
ylabel(y_label);
xlabel('\Phi^\circ');
grid on
end