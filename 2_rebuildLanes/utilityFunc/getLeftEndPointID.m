% getLeftEndPointID - Get the ID of the endpoint of the left boundary 
%                       in the current lanelet
%
% Syntax:  
%    ID_endPoint_left = getLeftEndPointID(lanelet,idx_lanelet)
%
% Input:
%    lanelet - the lanelet struct
%    idx_Lanelet - the current lanelet index
%
% Output:
%    ID_endPoint_left - the ID of the startpoint in the left border
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% init -> initial
% curr -> current
% num -> number
% idx -> index
% id -> identification
% s -> start
% e -> end

function ID_endPoint_left = getLeftEndPointID(lanelet,idx_lanelet)

% If the boundary should be flipped or inverted, invert or flip it first
if lanelet(idx_lanelet).toBeFlipped == 1
    % Actually, the current left boundary is the original right
    % boundary of the lanelet in this case, if toBeFlipped == 1
    numPoints_left = lanelet(idx_lanelet).rightBoundary.numPoints;
    % If the original right boundary should be inverted,then invert it 
    if lanelet(idx_lanelet).rightBoundary.toBeInverted == 1
        ID_endPoint_left = lanelet(idx_lanelet).rightBoundary.points(1).ID;
    else
        ID_endPoint_left = ...
            lanelet(idx_lanelet).rightBoundary.points(numPoints_left).ID;
    end
else
    numPoints_left = lanelet(idx_lanelet).leftBoundary.numPoints;
    if lanelet(idx_lanelet).leftBoundary.toBeInverted == 1
        ID_endPoint_left = lanelet(idx_lanelet).leftBoundary.points(1).ID;
    else
        ID_endPoint_left = ...
            lanelet(idx_lanelet).leftBoundary.points(numPoints_left).ID;
    end
end

end