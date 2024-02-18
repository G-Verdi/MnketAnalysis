function [fh ] = mnket_plot_regressors( design )
%DPRST_PLOT_REGRESSORS Plots PEs of an oberserver characterized by a
%set of parameters, exposed to the given (binary) tone sequence

colors = mnket_define_colors;
myDarkRed = colors.darkred;
myLightGreen = colors.darkgreen;


fh = figure;

subplot(2, 1, 1);
hold on;
plot(design.epsilon3, '.', 'MarkerEdgeColor', myDarkRed, 'MarkerSize', 10);
xlim([-100 length(design.epsilon3)+100]);
ylim([-30 90])
title(['\it',char(949),'_3']);

subplot(2, 1, 2);
hold on;
plot(design.epsilon2, '.', 'MarkerEdgeColor', myLightGreen, 'MarkerSize', 10);
xlim([-100 length(design.epsilon2)+100]);
xlabel('Trials');
ylim([-0.1 1])
title(['abs(\it', char(949), '_2)']);

end

