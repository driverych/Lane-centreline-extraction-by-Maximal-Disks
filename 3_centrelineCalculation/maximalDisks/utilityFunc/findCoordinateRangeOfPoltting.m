% Find the coordinate range of the plotting

function [x_min,x_max,y_min,y_max] = findCoordinateRangeOfPoltting(laneList,origin)

% The x and y of the left border
x_L = [laneList.leftBoundary.Points(:).UTM_x] - origin.x;
y_L = [laneList.leftBoundary.Points(:).UTM_y] - origin.y;

% The x and y of the right border
x_R = [laneList.rightBoundary.Points(:).UTM_x] - origin.x;
y_R = [laneList.rightBoundary.Points(:).UTM_y] - origin.y;

% Assemble x and y
x = [x_L';x_R'];
y = [y_L';y_R'];

% Find the range
x_min = min(x);
x_max = max(x);

y_min = min(y);
y_max = max(y);

% The step 
step = 5; % in meter

% Calculate the range
if x_min<0
    x_min = floor(x_min/step)*step;
else
    x_min = floor(x_min/step)*step;
end

if x_max<0
    x_max = ceil(x_max/step)*step;
else
    x_max = ceil(x_max/step)*step;
end

if y_min<0
    y_min = floor(y_min/step)*step;
else
    y_min = floor(y_min/step)*step;
end

if y_max<0
    y_max = ceil(y_max/step)*step;
else
    y_max = ceil(y_max/step)*step;
end


end