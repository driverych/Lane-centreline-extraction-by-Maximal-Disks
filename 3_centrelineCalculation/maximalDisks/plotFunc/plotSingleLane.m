% plotLanes - Plot both borders of a single lane
%
% Syntax:  
%    plotSingleLane(lane,origin,cntrFig)
%
% Input:
%    lane - a lane struct, composed of the left and right boundaries
%    origin - the origin of the map
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
% fig -> figure
% idx -> index
% num -> number

function plotSingleLane(lane,origin,hdlFig)

% The origin of the plotted map
xOrigin = origin.x; 
yOrigin = origin.y;

% Initiate the left and right border arrays
numPoints_left = numel(lane.leftBoundary.Points);
numPoints_right = numel(lane.rightBoundary.Points);
x_left = zeros(numPoints_left,1);
y_left = zeros(numPoints_left,1);
x_right = zeros(numPoints_right,1);
y_right = zeros(numPoints_right,1);

% The left border
for idxPoint_left = 1:numPoints_left
    x_left(idxPoint_left) = ...
        lane.leftBoundary.Points(idxPoint_left).UTM_x - xOrigin;
    y_left(idxPoint_left) = ...
        lane.leftBoundary.Points(idxPoint_left).UTM_y - yOrigin;
end

% The right border
for idxPoint_right = 1:numPoints_right
    x_right(idxPoint_right) = ...
        lane.rightBoundary.Points(idxPoint_right).UTM_x - xOrigin;
    y_right(idxPoint_right) = ...
        lane.rightBoundary.Points(idxPoint_right).UTM_y - yOrigin;
end

% Plot the two borders
figure(hdlFig);
plot(x_left,y_left,'-','LineWidth',1,'Color','b','Marker','.','MarkerSize',8);
hold on
plot(x_right,y_right,'-','LineWidth',1,'Color','r','Marker','.','MarkerSize',8);
axis equal
    
end