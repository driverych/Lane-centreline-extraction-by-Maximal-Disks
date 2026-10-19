% getRightEndPointID - Get the ID of the endpoint of the right boundary 
%                       in the current lanelet
%
% Syntax:  
%    ID_endPoint_right = getRightEndPointID(lanelet,idx_lanelet)
%
% Input:
%    lanelet - the lanelet struct
%    idx_Lanelet - the current lanelet index
%
% Output:
%    ID_endPoint_right - the ID of the endpoint in the right border
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

function ID_endPoint_right = getRightEndPointID(lanelet,idx_lanelet)

% If the boundary should be flipped or inverted, invert or flip it first
if lanelet(idx_lanelet).toBeFlipped == 1
    % Actually, the current right boundary is the original left
    % boundary of the lanelet in this case, if toBeFlipped == 1
    numPoints_right = lanelet(idx_lanelet).leftBoundary.numPoints;
    % If the original left boundary should be inverted,then invert it 
    if lanelet(idx_lanelet).leftBoundary.toBeInverted == 1
        ID_endPoint_right = lanelet(idx_lanelet).leftBoundary.points(1).ID;
    else
        ID_endPoint_right = ...
            lanelet(idx_lanelet).leftBoundary.points(numPoints_right).ID;
    end
else
    numPoints_right = lanelet(idx_lanelet).rightBoundary.numPoints;
    if lanelet(idx_lanelet).rightBoundary.toBeInverted == 1
        ID_endPoint_right = lanelet(idx_lanelet).rightBoundary.points(1).ID;
    else
        ID_endPoint_right = ...
            lanelet(idx_lanelet).rightBoundary.points(numPoints_right).ID;
    end
end

end