% connectCircleCentres
%   - Sequence the centre points while runing through all left border segments
%   - First, find all circles with the chosen segment as the base segment.
%     This is how all circles are demonstrated in the designing stage.
%   - If the chosen segment is not the base segment of the found circles,
%     then find all circles with their touching points in the chosen
%     segment. The touching point is the projection point from the circle
%     centre to the line segment. And the linking line defined by circle
%     centre and the touching point is perpendicular to the chosen segment.
%     Normally, the chosen segment is the target_1 segment. But in some
%     cases, it is the target_2 segment.
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCircleCentres(lanePoints,laneInfo,circleInfo)
%
% Input:
%    lanePoints - A matlab martix storing both left and right border points.
%                 Its field is [index,x,y]
%    laneInfo - A matlab struct storing info of point numbers
%    circleInfo - A matlab matrix to store circle info
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions: pointPairing
%
% MAT-files required: none
%
% Abbreviation:
% lgt -> ligature
% seg -> segment
% num -> number
% tgt -> target
% fld -> field
% idx -> index
% cir -> circl
% R -> right
% L -> left

function [circlesConnected,numCircles] = ...
        connectCircleCentresByPointAndSegmentInfo(lanePoints,laneInfo,circleInfo)

% Extract left points and segments
numPoints_L = laneInfo.leftPoints.number;
leftPoints = lanePoints(1:numPoints_L,:);
numPoints_R = laneInfo.rightPoints.number;
rightPoints = lanePoints(numPoints_L+1:numPoints_L+numPoints_R,:);

% The fields of the circleInfo matrix
fld_idx_segTgt_1 = 4;
fld_idx_pointTgt_1 = fld_idx_segTgt_1;
fld_idx_segBase = 10;
fld_idx_pointBase = fld_idx_segBase;
fld_isLeft_Base = 13;
fld_circleType = 14;
fld_isPoint_Tgt_1 = 15;
fld_isPoint_Base = 17;

% Extract the circles accroding to if the left border is the base segment 
% or not while finding the circles
isLeft_Base = 1;
idxsCirs_baseIsOnLeft = (circleInfo(:,fld_isLeft_Base)==isLeft_Base);
cirs_baseIsOnLeft = circleInfo(idxsCirs_baseIsOnLeft,:);

idxsCirs_baseIsOnRight = (circleInfo(:,fld_isLeft_Base)~=isLeft_Base);
cirs_baseIsOnRight = circleInfo(idxsCirs_baseIsOnRight,:);

% Initialise
numCircles = 0; circlesConnected = [];

% Build the base segment according to its start point
% An example of relations between point index and segment index
%        P_1      P_2      P_3
%         *--------*--------*--------> border(forward direction)
%            -S1-     -S2-     -S3-

for idxElem_L = 1:numPoints_L
    
    % Select the circles with the selected point as the base point
    % Search by element index and element type
    idxsCirs_elemIsBasePoint = (cirs_baseIsOnLeft(:,fld_idx_pointBase)==idxElem_L ...
        & cirs_baseIsOnLeft(:,fld_isPoint_Base)==1);
    cirs_elemIsBasePoint = cirs_baseIsOnLeft(idxsCirs_elemIsBasePoint,:);
    % Select the circles with the selected point as the tgt_1 point
    idxsCirs_elemIsTgt_1_Point = (cirs_baseIsOnRight(:,fld_idx_pointTgt_1)==idxElem_L ...
        & cirs_baseIsOnRight(:,fld_isPoint_Tgt_1)==1);
    cirs_elemIsTgt_1_Point = cirs_baseIsOnRight(idxsCirs_elemIsTgt_1_Point,:);
    
    idxSeg = idxElem_L;
    % The relation between the point index and the segment index is 
    % illustrated above
    % Select the circles with the selected segment as the base segment
    idxsCirs_elemIsBaseSeg = (cirs_baseIsOnLeft(:,fld_idx_segBase)==idxSeg ...
        & cirs_baseIsOnLeft(:,fld_isPoint_Base)==0);
    cirs_elemIsBaseSeg = cirs_baseIsOnLeft(idxsCirs_elemIsBaseSeg,:);
    % Select the circles with the selected segment as the tgt_1 segment
    idxsCirs_elemIsTgt_1_Seg = (cirs_baseIsOnRight(:,fld_idx_segTgt_1)==idxSeg ...
        & cirs_baseIsOnRight(:,fld_isPoint_Tgt_1)==0);
    cirs_elemIsTgt_1_Seg = cirs_baseIsOnRight(idxsCirs_elemIsTgt_1_Seg,:);

    % Assemble the circles according to the point and segment seperately
    circles_elemIsPoint = [cirs_elemIsBasePoint;cirs_elemIsTgt_1_Point];  
    circles_elemIsSegment = [cirs_elemIsBaseSeg;cirs_elemIsTgt_1_Seg];  

    % Bulid the segment in the forward direction
    if idxElem_L < numPoints_L
        startPoint = leftPoints(idxElem_L,2:3);
        endPoint = leftPoints(idxElem_L+1,2:3);
        % The current left segment
        segL = [startPoint,endPoint];
    end
    
    % Connect the points by the base point
    if isempty(circles_elemIsPoint) ~= 1
        [circlesConnected,numCircles] = connectCirclesByPoint...
            (circles_elemIsPoint,numCircles,circlesConnected);
    end
    
    if idxElem_L < numPoints_L
        % Connect the points by the base segment
        if isempty(circles_elemIsSegment) ~= 1
            [circlesConnected,numCircles] = connectCirclesBySegment...
                (segL,circles_elemIsSegment,numCircles,circlesConnected);
        end    
    end
    
end

% Extract the entrance segment (left borber to right border)
CC_first = circlesConnected(1,1:2);
extr_pts = [leftPoints(1,2:3),rightPoints(1,2:3)];
CCIsLeftOfExtr_flag = isPointLeftOfLine(CC_first,extr_pts);
par_Sta_extr = standardFormEquFrom2Points(leftPoints(1,2:3),rightPoints(1,2:3)); 
dist_first2extr = distancePoint2Line(CC_first,par_Sta_extr); 
if dist_first2extr < 0.2
    CCIsLeftOfExtr_flag = 1; 
end
while CCIsLeftOfExtr_flag == 0
    % Delete the point
    circlesConnected(1,:) = [];
    numCircles = numCircles - 1;
    % Extract the first point
    CC_first = circlesConnected(1,1:2);
    extr_pts = [leftPoints(1,2:3),rightPoints(1,2:3)];
    CCIsLeftOfExtr_flag = isPointLeftOfLine(CC_first,extr_pts);
end
% plot for testing
% x_start = leftPoints(1,2);
% y_start = leftPoints(1,3);
% x_end = rightPoints(1,2);
% y_end = rightPoints(1,3);
% u = x_end - x_start;
% v = y_end - y_start;
% quiver(x_start,y_start,u,v);
% scatter(CC_first(1,1),CC_first(1,2),6);

% Extract the exit segment (left borber to right border)
CC_last = circlesConnected(end,1:2);
exit_pts = [leftPoints(end,2:3),rightPoints(end,2:3)];
CCIsLeftOfExit_flag = isPointLeftOfLine(CC_last,exit_pts);
par_Sta_exit = standardFormEquFrom2Points(leftPoints(end,2:3),rightPoints(end,2:3)); 
dist_end2exit = distancePoint2Line(CC_last,par_Sta_exit); 
if dist_end2exit < 0.2
    CCIsLeftOfExit_flag = 0; 
end
while CCIsLeftOfExit_flag == 1
    % Delete the point
    circlesConnected(end,:) = [];
    numCircles = numCircles - 1;  
    % Extract the last point
    CC_last = circlesConnected(end,1:2);
    exit_pts = [leftPoints(end,2:3),rightPoints(end,2:3)];
    CCIsLeftOfExit_flag = isPointLeftOfLine(CC_last,exit_pts);
end

end
