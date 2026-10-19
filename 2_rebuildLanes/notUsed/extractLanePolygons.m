% extractLanePolygons - Establish a polygon with points of a lane
% 
% Syntax:  lanePolygons = extractLanePolygons(laneList)
%
% Input:
%    laneList - A matlab struct storing the lane points, sorted by left and
%               right borders
%
% Output:
%    lanePolygons - A matrix storing the lane polygons in the form of
%                   points coordinates
%
% Other m-files required: none
%
% Subfunctions: findMaxNumberOfPoints
%
% MAT-files required: findMaxNumberOfPoints.m
% Abbreviation:
% num -> number
% idx -> index
% mt -> matrix

function lanePolygons = extractLanePolygons(laneList)

% The number of lanes
numLanes = numel(laneList);
% The length of the longest lane(with most points)
maxNumPoints = findMaxNumberOfPoints(laneList);
% Initiate a matrix to store lane point coordinates
mtLanes = zeros(numLanes,maxNumPoints*2*2);

for idxLane = 1:numLanes

    % Assemble a polygon from the left border
    numPoints_L = numel(laneList(idxLane).leftBoundary.Points);
    for idxPoint = 1:numPoints_L
        mtLanes(idxLane,idxPoint*2-1) = ...
            laneList(idxLane).leftBoundary.Points(idxPoint).UTM_x;
        mtLanes(idxLane,idxPoint*2) = ...
            laneList(idxLane).leftBoundary.Points(idxPoint).UTM_y;
    end
    
    % Append the information of the right border
    numPoints_R = numel(laneList(idxLane).rightBoundary.Points);
    for idxPoint = 1:numPoints_R
        mtLanes(idxLane,numPoints_L*2 + idxPoint*2-1) = ...
            laneList(idxLane).rightBoundary.Points(numPoints_R - idxPoint + 1).UTM_x;
        mtLanes(idxLane,numPoints_L*2 + idxPoint*2) = ...
            laneList(idxLane).rightBoundary.Points(numPoints_R - idxPoint + 1).UTM_y;
    end
    
    % Form a closed loop
    mtLanes(idxLane,(numPoints_L + numPoints_R)*2 + 1) = ...
        laneList(idxLane).leftBoundary.Points(1).UTM_x;
    mtLanes(idxLane,(numPoints_L + numPoints_R)*2 + 2) = ...
        laneList(idxLane).leftBoundary.Points(1).UTM_y;    
    
end

lanePolygons = mtLanes;

end
