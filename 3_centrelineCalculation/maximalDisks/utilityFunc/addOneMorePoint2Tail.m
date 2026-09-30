% addOneMorePoint2Tail
%   - Add an addition point to the tail of results of ranging search
% 
% Syntax:  [pointPairs,numPairs] = addOneMorePoint2Tail...
%                (maxCntr_tgt,tgtPoints,numPairs,pointPairs,idx_basePoint,coord_basePoint,field,isLeftBase)
%
% Input:
%    maxCntr_tgt - The max row number of the found point in ranging
%                  searching
%    tgtPoints - A matlab matrix storing the index and coordinates of the
%                points on the target border
%    numPairs - The number of found point pairs
%    pointPairs - A matrix storing point pair info
%    idx_basePoint - The index of the base point 
%                    (positive in the left border while negative in teh right border)
%    coord_basePoint - The coordinates of the base point
%    field - the field info of lane points
%    isLeftBase - Indicate if the left border is the base border
%
% Output:
%    pointPairs - A matlab matrix to store point pairs info, the field is:
%                 [idx_leftPoint,idx_rightPoint,coord_leftPoint,coord_rightPoint]
%    numPairs - The number of the found point pairs
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% cntr -> counter
% num -> number
% tgt -> target
% fld -> field
% idx -> index

function [pointPairs,numPairs] = addOneMorePoint2Tail...
                (maxLoc_tgt,tgtPoints,numPairs,pointPairs,idx_basePoint,coord_basePoint,flds,isLeftBase)
% The field information
fld_idx = flds.lanePoints.idx; fld_coords = flds.lanePoints.coords;

% The counter of the to-add point
loc2add_tgt = maxLoc_tgt + 1;
% Add the point
numPairs = numPairs + 1;
idx_tgtPoint = tgtPoints(loc2add_tgt,fld_idx);
coord_tgtPoint = tgtPoints(loc2add_tgt,fld_coords);
if isLeftBase == 1 % left is the base and right is the target
    pointPair_temp = [idx_basePoint,idx_tgtPoint,coord_basePoint,coord_tgtPoint];
else % left is the target and right is the base
    pointPair_temp = [idx_tgtPoint,idx_basePoint,coord_tgtPoint,coord_basePoint];
end
pointPairs = [pointPairs;pointPair_temp];
% * * * Plot the range for test * * *
% plot([coord_basePoint(1,1),coord_tgtPoint(1,1)],[coord_basePoint(1,2),coord_tgtPoint(1,2)],'c');
% drawnow;
% hold on; axis equal;  

end