

function plotTargetMap(lanelet,origin)

for idxLanelet = 1:numel(lanelet)
    % Initialize
    x_L = [];y_L = [];
    x_R = [];y_R = [];

    transparency = 0.25;
    color_grey = [0 0 0 transparency];
    
    % Plot the left border
    x_L = [lanelet(idxLanelet).leftBoundary.points(:).UTM_x] - origin.x;
    y_L = [lanelet(idxLanelet).leftBoundary.points(:).UTM_y] - origin.y;
    plot(x_L,y_L,'LineWidth',1,'LineStyle','-','Color',color_grey);
    hold on;    
    
    % Plot the right border
    x_R = [lanelet(idxLanelet).rightBoundary.points(:).UTM_x] - origin.x;
    y_R = [lanelet(idxLanelet).rightBoundary.points(:).UTM_y] - origin.y;
    plot(x_R,y_R,'LineWidth',1,'LineStyle','-','Color',color_grey);    

%     % Plot the left points
%     sz = 50;
%     scatter(x_L,y_L,sz,'b.','LineWidth',1);
%     
%     % Plot the left points
%     scatter(x_R,y_R,sz,'b.','LineWidth',1);

end    

end