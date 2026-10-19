% plotOriginalLanelets - Plot the original lanelet struct,with no inversion.
%
% Syntax:  
%    plotOriginalLanelets(lanelet,cntrLanelet)
%
% Input:
%    lanelet - the lanelet struct
%    num_lanelets - the lanelet number
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: originalLanelet.mat(optional)
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index

function plotOriginalLanelets(lanelet,num_lanelets,origin)

for idxLanelet = 1:num_lanelets
    % If a lanelet is empty, skip plotting.
    if isempty(lanelet(idxLanelet).leftBoundary)
        continue
    end
    % Initialize
    numPoints_Left = lanelet(idxLanelet).leftBoundary.numPoints;
    numPoints_Right = lanelet(idxLanelet).rightBoundary.numPoints;
    Left_UTM_x = [];Left_UTM_y = [];
    Right_UTM_x = [];Right_UTM_y = [];

    for idxLeft = 1:numPoints_Left
        Left_UTM_x(idxLeft) = ...
            lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_x;
        Left_UTM_y(idxLeft) = ...
            lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_y;
    end
    leftBoundary_X = Left_UTM_x;
    leftBoundary_Y = Left_UTM_y;

    for idxRight = 1:numPoints_Right
        Right_UTM_x(idxRight) = ...
            lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_x;
        Right_UTM_y(idxRight) = ...
            lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_y;
    end
    rightBoundary_X = Right_UTM_x;
    rightBoundary_Y = Right_UTM_y;

    axis equal;
    % Plot left boundary
    plot(leftBoundary_X,leftBoundary_Y,'Color','#5F4BF5','LineStyle','-.','LineWidth',1);
    hold on
    % Plot right boundary
    plot(rightBoundary_X,rightBoundary_Y,'Color','#5F4BF5','LineStyle','-.','LineWidth',1);

end

% Plot the origin
xUtmOrigin = origin.utm_x;
yUtmOrigin = origin.utm_y;
plot(xUtmOrigin,yUtmOrigin,'og');
hold on

end