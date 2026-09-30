% Plot the whole map, consisting of Lanelets

function plotMapWithLaneletBoundaries(hdlFig,alignedLanelet,origin)

% Plot in the given figure
figure(hdlFig);

% Set the color of the plotted Lanelet boundaries
transparency = 0.25;
color_grey = [0 0 0 transparency];

% The number of the Lanelets
numLanelets = numel(alignedLanelet);

% Plot the whole map in grey
for idxLanelet = 1:numLanelets
    
    % Plot the left border
    x_L = [alignedLanelet(idxLanelet).leftBoundary.points(:).UTM_x] - origin.x;
    y_L = [alignedLanelet(idxLanelet).leftBoundary.points(:).UTM_y] - origin.y;
    plot(x_L,y_L,'LineWidth',1,'LineStyle','-','Color',color_grey);
    hold on   
    
    % Plot the right border
    x_R = [alignedLanelet(idxLanelet).rightBoundary.points(:).UTM_x] - origin.x;
    y_R = [alignedLanelet(idxLanelet).rightBoundary.points(:).UTM_y] - origin.y;
    plot(x_R,y_R,'LineWidth',1,'LineStyle','-','Color',color_grey); 
    
    % Empty the coordinate container
    x_L = [];y_L = [];
    x_R = [];y_R = [];
    
end % for idxLanelet = 1:numLanelets
    
end