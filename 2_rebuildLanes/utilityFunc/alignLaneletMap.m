% alignLaneletMap - Align all lanelets according to their toBeFlipped and
%                   toBeInverted flags
%
% Syntax:  
%    alignedLanelet = alignLaneletMap(lanelet)
%
% Input:
%    lanelet - the lanelet struct
%
% Output:
%    alignedLanelet - the aligned lanelet struct
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index
% id -> identification

function alignedLanelet = alignLaneletMap(lanelet)

num_lanelets = numel(lanelet);
for idx_lanelet = 1:num_lanelets
    % Copy lanelet ID and scenario ID
    alignedLanelet(idx_lanelet).ID = lanelet(idx_lanelet).ID;
    alignedLanelet(idx_lanelet).sceID = lanelet(idx_lanelet).sceID;
    % Flip boundaries if necessary
    if lanelet(idx_lanelet).toBeFlipped == 0
        alignedLanelet(idx_lanelet).leftBoundary.ID = lanelet(idx_lanelet).leftBoundary.ID;
        alignedLanelet(idx_lanelet).leftBoundary.numPoints = lanelet(idx_lanelet).leftBoundary.numPoints;
        % Invert boundaries if necessary
        if lanelet(idx_lanelet).leftBoundary.toBeInverted == 0
            alignedLanelet(idx_lanelet).leftBoundary.points = lanelet(idx_lanelet).leftBoundary.points;
        else
            num_leftPoints = lanelet(idx_lanelet).leftBoundary.numPoints;
            for idx_point = 1:num_leftPoints
                alignedLanelet(idx_lanelet).leftBoundary.points(idx_point) = ...
                    lanelet(idx_lanelet).leftBoundary.points(num_leftPoints - idx_point + 1);
            end
        end

        alignedLanelet(idx_lanelet).rightBoundary.ID = lanelet(idx_lanelet).rightBoundary.ID;
        alignedLanelet(idx_lanelet).rightBoundary.numPoints = lanelet(idx_lanelet).rightBoundary.numPoints;        
        if lanelet(idx_lanelet).rightBoundary.toBeInverted == 0
            alignedLanelet(idx_lanelet).rightBoundary.points = lanelet(idx_lanelet).rightBoundary.points;
        else
            num_rightPoints = lanelet(idx_lanelet).rightBoundary.numPoints;
            for idx_point = 1:num_rightPoints
                alignedLanelet(idx_lanelet).rightBoundary.points(idx_point) = ...
                    lanelet(idx_lanelet).rightBoundary.points(num_rightPoints - idx_point + 1);
            end
        end
    else  % Two boundaries should be flipped here
        alignedLanelet(idx_lanelet).leftBoundary.ID = lanelet(idx_lanelet).rightBoundary.ID;
        alignedLanelet(idx_lanelet).leftBoundary.numPoints = lanelet(idx_lanelet).rightBoundary.numPoints;
        if lanelet(idx_lanelet).rightBoundary.toBeInverted == 0
            alignedLanelet(idx_lanelet).leftBoundary.points = lanelet(idx_lanelet).rightBoundary.points;
        else
            num_leftPoints = lanelet(idx_lanelet).rightBoundary.numPoints;
            for idx_point = 1:num_leftPoints
                alignedLanelet(idx_lanelet).leftBoundary.points(idx_point) = ...
                    lanelet(idx_lanelet).rightBoundary.points(num_leftPoints - idx_point + 1);
            end
        end

        alignedLanelet(idx_lanelet).rightBoundary.ID = lanelet(idx_lanelet).leftBoundary.ID;
        alignedLanelet(idx_lanelet).rightBoundary.numPoints = lanelet(idx_lanelet).leftBoundary.numPoints;
        if lanelet(idx_lanelet).leftBoundary.toBeInverted == 0
            alignedLanelet(idx_lanelet).rightBoundary.points = lanelet(idx_lanelet).leftBoundary.points;
        else
            num_rightPoints = lanelet(idx_lanelet).leftBoundary.numPoints;
            for idx_point = 1:num_rightPoints
                alignedLanelet(idx_lanelet).rightBoundary.points(idx_point) = ...
                    lanelet(idx_lanelet).leftBoundary.points(num_rightPoints - idx_point + 1);
            end
        end
    end

    alignedLanelet(idx_lanelet).isOneWay = lanelet(idx_lanelet).isOneWay;
    alignedLanelet(idx_lanelet).isInitial = lanelet(idx_lanelet).isInitial;
    alignedLanelet(idx_lanelet).Parents = lanelet(idx_lanelet).Parents;
    alignedLanelet(idx_lanelet).Children = lanelet(idx_lanelet).Children;
end
    
end