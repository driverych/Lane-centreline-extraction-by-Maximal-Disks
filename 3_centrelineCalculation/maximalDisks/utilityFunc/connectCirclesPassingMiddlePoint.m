% connectCirclesPassingMiddlePoint
%   - Sequence the centre points whose circles pass the start point.
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCirclesPassingMiddlePoint(segL,circles_start,numCircles,circlesConnected)
%
% Input:
%    segL - The chosen left segment
%    circles_start - A matlab matrix of all circles passing by the start
%                    point
%    numCircles - The number of cirlces
%    circlesConnected - A matlab matrix to store circle info in sequence
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions: cosValues
%
% MAT-files required: none
%
% Abbreviation:
% seg -> segment
% num -> number
% cos -> cosine
% fld -> field
% idx -> index
% R -> right
% L -> left

function [circlesConnected,numCircles] = ...
            connectCirclesPassingMiddlePoint(segL,circles_mid,numCircles,circlesConnected)
% 4 cases here: not finished here ......... new cases are added
% The middle points are the target_1 projection point of Case 1 & 2 & 3
% The middle points are the base projection point of Case 3

% The field info of circles
fld_projPointOnTgt_1 = 5:6;
fld_projPointOnBase = 11:12;
fld_caseType = 14;
fld_isBaseLeft = 13;

% Initialise
numCircles_middle = size(circles_mid,1); 
distValues = zeros(numCircles_middle,1);

for idxCircle_middle = 1:numCircles_middle
    
    % There is an issue here actually. Case 5, subtype 3
    % If the case is Case 3 and the base segment is on the left border
    isBaseLeft = circles_mid(idxCircle_middle,fld_isBaseLeft);
    isCase_3 = (circles_mid(idxCircle_middle,fld_caseType) == 3);
    
    if isCase_3 == 1 && isBaseLeft == 1
        projPoint = circles_mid(idxCircle_middle,fld_projPointOnBase);
    else
        projPoint = circles_mid(idxCircle_middle,fld_projPointOnTgt_1);
    end

    startPoint = segL(1:2);
    distValues(idxCircle_middle,1) = distancePoint2Point(projPoint,startPoint);
end

[~,idx_CC_ascend] = sort(distValues,'ascend');
circlesConnected_temp = circles_mid(idx_CC_ascend,:);

circlesConnected = [circlesConnected;circlesConnected_temp];
numCircles = numCircles + numCircles_middle;

end