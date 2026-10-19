% findMaxNumberOfPoints - Find the max number of points in lanelist borders
% 
% Syntax:  maxNumPoints = findMaxNumberOfPoints(laneList)
%
% Input:
%    laneList - A matlab struct storing the lane points, sorted by left and
%               right borders
%
% Output:
%    maxNumPoints - The max number of the points
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% num -> number
% idx -> index

function maxNumPoints = findMaxNumberOfPoints(laneList)

% The number of lanes
numLanes = numel(laneList);

% Initiate the maxNumPoints
maxNumPoints = 0;

for idxLane = 1:numLanes
    numPoints_L = numel(laneList(idxLane).leftBoundary.Points);
    numPoints_R = numel(laneList(idxLane).rightBoundary.Points);
    
    if numPoints_L > maxNumPoints
        maxNumPoints = numPoints_L;
    end
    
    if numPoints_R > maxNumPoints
        maxNumPoints = numPoints_R;
    end
    
end

end