function plot2s(frame_data,y_data, figure_number,  y_label)
   figure(figure_number);
   plot(frame_data, y_data); 
   ylabel(y_label); 
   xlabel('\Phi^\circ'); 
   grid on
end