% findSpecificPointsFromCircleMatrix
%   - Find the points in the circleInfo which is the same as specificPoint
% 
% Syntax:  
%    [samePointInfo,idxs_samePoint] = findSpecificPointsFromCircleMatrix(searchOnSeg,specificPoint,circleInfo)
%
% Input:
%    searchOnSeg - The segment type: base, target_1 and target_2
%    specificPoint - A specific point to compare with
%    circleInfo - A matlab matrix to store circle info
%
% Output:
%    samePointInfo - The same point
%    idxs_samePoint - The index of the same point
%
% Subfunctions: none
%
% MAT-files required: none
%
% Abbreviation:
% coord -> coordinate
% cntr -> counter
% seg -> segment
% tgt -> target
% fld -> field
% idx -> index

function [samePointInfo,idxs_samePoint] = findSpecificPointsFromCircleMatrix(searchOnSeg,specificPoint,circleInfo)

% The fields of the circleInfo matrix
fld_coord_tgt_1 = 5:6;
fld_coord_tgt_2 = 8:9;
fld_coord_base = 11:12;

% Initialise
cntrSamePoint = 0; samePointInfo = []; idxs_samePoint = [];

% Search the specific point on the segment
if searchOnSeg == 3
    % Search the points on the segments of base
    for idxPoint = 1:size(circleInfo,1)
        point2Compare = circleInfo(idxPoint,fld_coord_base);
        if isequal(specificPoint,point2Compare)
            cntrSamePoint = cntrSamePoint + 1;
            samePointInfo = [samePointInfo;circleInfo(idxPoint,:)];
            idxs_samePoint = [idxs_samePoint;idxPoint];
        end
    end
elseif searchOnSeg == 1 
    % Search the points on the segments of target_1 
    for idxPoint = 1:size(circleInfo,1)
        point2Compare = circleInfo(idxPoint,fld_coord_tgt_1);
        if isequal(specificPoint,point2Compare)
            cntrSamePoint = cntrSamePoint + 1;
            samePointInfo = [samePointInfo;circleInfo(idxPoint,:)];
            idxs_samePoint = [idxs_samePoint;idxPoint];
        end
    end
else % searchOnSeg == 2
    % Search the points on the segments of target_2
    for idxPoint = 1:size(circleInfo,1)
        point2Compare = circleInfo(idxPoint,fld_coord_tgt_2);
        if isequal(specificPoint,point2Compare)
            cntrSamePoint = cntrSamePoint + 1;
            samePointInfo = [samePointInfo;circleInfo(idxPoint,:)];
            idxs_samePoint = [idxs_samePoint;idxPoint];
        end
    end
    
end

end