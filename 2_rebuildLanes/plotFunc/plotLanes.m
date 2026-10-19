% plotLanes - Plot the separate consecutive lanes with aligned Lanelets
%
% Syntax:  
%    plotLanes(laneList,cntrFig)
%
% Input:
%    laneList - the lane struct
%    cntrFig - the counter of the plotted figures
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index
% id -> identification

function cntrFig = plotLanes(laneList,cntrFig,mapPath,origin)

num_lanes = numel(laneList);
for idx_lane = 1:num_lanes
    cntrFig = cntrFig + 1;
    figure(cntrFig);
    numPointsLeft = numel(laneList(idx_lane).leftBoundary.Points);
    numPointsRight = numel(laneList(idx_lane).rightBoundary.Points);

    for idx_leftPoint = 1:numPointsLeft
        Left_UTM_x(idx_leftPoint) = ...
            laneList(idx_lane).leftBoundary.Points(idx_leftPoint).UTM_x - origin.x;
        Left_UTM_y(idx_leftPoint) = ...
            laneList(idx_lane).leftBoundary.Points(idx_leftPoint).UTM_y - origin.y;
    end

    axis equal
    hold on
    plot(Left_UTM_x,Left_UTM_y,'-ob','LineWidth',1.5);
    plot(Left_UTM_x(1),Left_UTM_y(1),'*b','MarkerSize',7)
    plot(Left_UTM_x(numPointsLeft),Left_UTM_y(numPointsLeft),'xb','MarkerSize',4);  


    for idx_rightPoint = 1:numPointsRight
        Right_UTM_x(idx_rightPoint) = ...
            laneList(idx_lane).rightBoundary.Points(idx_rightPoint).UTM_x - origin.x;
        Right_UTM_y(idx_rightPoint) = ...
            laneList(idx_lane).rightBoundary.Points(idx_rightPoint).UTM_y - origin.y;
    end    

    % The start point is '*' and the end point is 'x'
    plot(Right_UTM_x,Right_UTM_y,'-or','LineWidth',1.5);
    plot(Right_UTM_x(1),Right_UTM_y(1),'*r','MarkerSize',7)
    plot(Right_UTM_x(numPointsRight),Right_UTM_y(numPointsRight),'xr','MarkerSize',4);
    % Empty point position containers
    Left_UTM_x = [];Left_UTM_y = [];
    Right_UTM_x = [];Right_UTM_y = [];
    
    % Plot the original map
    load(mapPath);
    plotTargetMap(lanelet,origin);

end


end