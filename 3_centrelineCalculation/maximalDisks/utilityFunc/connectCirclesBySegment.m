% connectCirclesPassingMiddlePoint
%   - Sort the circles by distance from the projection point to the start
%     point
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCirclesBySegment(segL,circles_mid,numCircles,circlesConnected)
%
% Input:
%    segL - The chosen left segment
%    circles_mid - A matlab matrix of all circles touch the segment in the
%                  middle
%    numCircles - The number of cirlces
%    circlesConnected - A matlab matrix to store circle info in sequence
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions:
%
% MAT-files required: none
%
% Main steps:
%  - Extract the projection point, at which the circles touch the segment
%  - Calculate the distance from the projection point to the start point
%  - Sort the circles by the distance
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
            connectCirclesBySegment(segL,circles_mid,numCircles,circlesConnected)

% The field info of circles
fld_projPointOnTgt_1 = 5:6;
fld_projPointOnBase = 11:12;
fld_isBaseLeft = 13;

% Initialise
numCircles_middle = size(circles_mid,1); 
distValues = zeros(numCircles_middle,1);
startPoint = segL(1:2);

%--------------------------------------------------------------------------
%---------             extract the projection point              ----------
%--------------------------------------------------------------------------
for idxCircle_middle = 1:numCircles_middle
    
    isBaseLeft = circles_mid(idxCircle_middle,fld_isBaseLeft);
    
    if isBaseLeft == 1
        projPoint = circles_mid(idxCircle_middle,fld_projPointOnBase);
    else
        projPoint = circles_mid(idxCircle_middle,fld_projPointOnTgt_1);
    end
    %----------------------------------------------------------------------
    %-------  calculate the distance from projection to the start  --------
    %----------------------------------------------------------------------
    distValues(idxCircle_middle,1) = distancePoint2Point(projPoint,startPoint);
end

%--------------------------------------------------------------------------
%---------             sort the circles by distance              ----------
%--------------------------------------------------------------------------
[~,idx_CC_ascend] = sort(distValues,'ascend');
circlesConnected_temp = circles_mid(idx_CC_ascend,:);

circlesConnected = [circlesConnected;circlesConnected_temp];
numCircles = numCircles + numCircles_middle;

end