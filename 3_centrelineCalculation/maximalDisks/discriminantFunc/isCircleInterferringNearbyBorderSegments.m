% isCircleInterferringSegments - Judge if the point has intersection with
%                                the border segment
%
% Syntax:  
%    InterferingFlag = isCircleInterferringSegments(centre,radius,segments)
%
% Input:
%    center - the circle center array
%    radius - the radius of the circle
%    segments - the segment struct
%
% Output:
%    interferingFlag - if the point has intersection with the segments
%
% Other m-files required: none
% Subfunctions: distancePoint2Point.m 
%               standardFormEquFrom2Points.m
%               distancePoint2Line.m
% MAT-files required: distancePoint2Point 
%                     standardFormEquFrom2Points
%                     distancePoint2Line
% Abbreviation:
% par -> parameter
% sta -> standard
% seg -> segment
% d -> distance
% S -> start
% E -> end

function interferingFlag = isCircleInterferringNearbyBorderSegments...
                            (center,radius,lanePoints,idxElem_Tgt_1,...
                             idxElem_Tgt_2,idxElem_Base,isLeft_Base)

% Extract the left and right points
leftPoints = lanePoints(lanePoints(:,1)>0,:);
rightPoints = lanePoints(lanePoints(:,1)<0,:);
numPoints_left = size(leftPoints,1);
numPoints_right = size(rightPoints,1);
                         
% Get the Tgt_1,Tgt_2 and Base element indexes in leftPoints/rightPoints
if isLeft_Base == 1
    % Tgt elements are on the right border
    rowIdx_Tgt_1 = find(rightPoints(:,1) == idxElem_Tgt_1);
    rowIdx_Tgt_2 = find(rightPoints(:,1) == idxElem_Tgt_2);
    % Base element is on the left border
    rowIdx_Base = find(leftPoints(:,1) == idxElem_Base);
else
    % Tgt elements are on the left border
    rowIdx_Tgt_1 = find(leftPoints(:,1) == idxElem_Tgt_1);
    rowIdx_Tgt_2 = find(leftPoints(:,1) == idxElem_Tgt_2);
    % Base element is on the right border
    rowIdx_Base = find(rightPoints(:,1) == idxElem_Base);
end

% Extend the Tgt_1,Tgt_2 and Base elements
segIdx_ext = 30; % default is 2
rowIdx_Tgt_min = rowIdx_Tgt_1 - segIdx_ext;
rowIdx_Tgt_max = rowIdx_Tgt_2 + segIdx_ext;
rowIdx_Base_min = rowIdx_Base - segIdx_ext;
rowIdx_Base_max = rowIdx_Base + segIdx_ext;
if isLeft_Base == 1
    % The Tgt elements are on the right boder
    if rowIdx_Tgt_min < 1
        rowIdx_Tgt_min = 1; % The first right point
    end
    
    if rowIdx_Tgt_max > numPoints_right
        rowIdx_Tgt_max = numPoints_right; % The last right point
    end
    rowIdx_right_min = rowIdx_Tgt_min;
    rowIdx_right_max = rowIdx_Tgt_max;
    
    % The Base elements are on the left boder
    if rowIdx_Base_min < 1
        rowIdx_Base_min = 1; % The first left point
    end
    
    if rowIdx_Base_max > numPoints_left
        rowIdx_Base_max = numPoints_left; % The last left point
    end
    rowIdx_left_min = rowIdx_Base_min;
    rowIdx_left_max = rowIdx_Base_max;
else
    % The Tgt elements are on the left boder
    if rowIdx_Tgt_min < 1
        rowIdx_Tgt_min = 1; % The first left point
    end
    
    if rowIdx_Tgt_max > numPoints_left
        rowIdx_Tgt_max = numPoints_left; % The last left point
    end
    rowIdx_left_min = rowIdx_Tgt_min;
    rowIdx_left_max = rowIdx_Tgt_max;
    
    % The Base elements are on the right boder
    if rowIdx_Base_min < 1
        rowIdx_Base_min = 1; % The first right point
    end
    
    if rowIdx_Base_max > numPoints_right
        rowIdx_Base_max = numPoints_right; % The last right point
    end
    rowIdx_right_min = rowIdx_Base_min;
    rowIdx_right_max = rowIdx_Base_max;
end

% A small positive number： not bigger than this number
epsilon = 0.00001;

% Check if the circle interfers with the left border
for rowIdx_leftPoint = rowIdx_left_min:rowIdx_left_max
    
    % Skip the exit segment
    if rowIdx_leftPoint == numPoints_left 
        continue
    end
    
    % Initiate start and end points
    x_Start = leftPoints(rowIdx_leftPoint,2);
    y_Start = leftPoints(rowIdx_leftPoint,3);
    x_End = leftPoints(rowIdx_leftPoint+1,2);
    y_End = leftPoints(rowIdx_leftPoint+1,3);
    pointS = [x_Start,y_Start];
    pointE = [x_End,y_End];

    d_1 = distancePoint2Point(center,pointS);
    d_2 = distancePoint2Point(center,pointE);
    % If any extreme points are in the circle, circle interferes the segment
    % If the distance is smaller than the radius, the point is inside the
    % circle
    isStartPointInCirlce = (d_1 < radius - epsilon);
    isEndPointInCirlce = (d_2 < radius - epsilon);
    
    if isStartPointInCirlce || isEndPointInCirlce % A point is inside the circle
        interferingFlag = 1;
        break
    else
        % If extreme points are not in the circle, excute the following
        par_seg_sta = standardFormEquFrom2Points(pointS,pointE);
        d_3 = distancePoint2Line(center,par_seg_sta);
        if d_3 >= radius - epsilon
            interferingFlag = 0;
        else
            angle_1 = (center(1) - pointS(1))*(pointE(1) - pointS(1)) + ...
                (center(2) - pointS(2))*(pointE(2) - pointS(2));
            angle_2 = (center(1) - pointE(1))*(pointS(1) - pointE(1)) + ...
                (center(2) - pointE(2))*(pointS(2) - pointE(2));
            % When COS() > 0, the angle is less than 90 degree
            if angle_1 > 0 && angle_2 > 0
                interferingFlag = 1;
                break
            else
                interferingFlag = 0;
            end
        end
    end
end % for rowIdx_leftPoint = rowIdx_left_min:rowIdx_left_max

if interferingFlag == 1
    return
end

% Check if the circle interfers with the right border
for rowIdx_rightPoint = rowIdx_right_min:rowIdx_right_max

    % Skip the exit segment
    if rowIdx_rightPoint == numPoints_right 
        continue
    end
    
    % Initiate start and end points
    x_Start = rightPoints(rowIdx_rightPoint,2);
    y_Start = rightPoints(rowIdx_rightPoint,3);
    x_End = rightPoints(rowIdx_rightPoint+1,2);
    y_End = rightPoints(rowIdx_rightPoint+1,3);
    pointS = [x_Start,y_Start];
    pointE = [x_End,y_End];

    d_1 = distancePoint2Point(center,pointS);
    d_2 = distancePoint2Point(center,pointE);
    % If any extreme points are in the circle, circle interferes the segment
    % If the distance is smaller than the radius, the point is inside the
    % circle
    isStartPointInCirlce = (d_1 < radius - epsilon);
    isEndPointInCirlce = (d_2 < radius - epsilon);
    
    if isStartPointInCirlce || isEndPointInCirlce % A point is inside the circle
        interferingFlag = 1;
        break
    else
        % If extreme points are not in the circle, excute the following
        par_seg_sta = standardFormEquFrom2Points(pointS,pointE);
        d_3 = distancePoint2Line(center,par_seg_sta);
        if d_3 >= radius - epsilon
            interferingFlag = 0;
        else
            angle_1 = (center(1) - pointS(1))*(pointE(1) - pointS(1)) + ...
                (center(2) - pointS(2))*(pointE(2) - pointS(2));
            angle_2 = (center(1) - pointE(1))*(pointS(1) - pointE(1)) + ...
                (center(2) - pointE(2))*(pointS(2) - pointE(2));
            % When COS() > 0, the angle is less than 90 degree
            if angle_1 > 0 && angle_2 > 0
                interferingFlag = 1;
                break
            else
                interferingFlag = 0;
            end
        end
    end
end % for rowIdx_rightPoint = rowIdx_right_min:rowIdx_right_max

end