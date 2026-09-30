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
% loc -> location
% seg -> segment
% rs -> range search
% d -> distance
% S -> start
% E -> end


% Build the Kd-tree for the left and right borders
% Select the point in the left border with a range
% Select the point in the right border with a range
% Construct the border segment with the selected border points in both
% direction
% Check the intersection


function interferingFlag = isCircleInterferringNearbyBorderSegments_knnSearch...
                            (center,radius_CC,lanePoints,leftTree,rightTree,params)

% Extract the left and right points
leftPoints = lanePoints(lanePoints(:,1)>0,:);
rightPoints = lanePoints(lanePoints(:,1)<0,:);
numPoints_left = size(leftPoints,1);
numPoints_right = size(rightPoints,1);

% Perform knn search to find the candidate points: default is 3
params.knnSrch.numNN = 3;
% cntrMatrixTgt is the matrix of row number in KdTree
% Search in the left border
locsLeft_rngSrch = ...
    KnnSearchingBasedOnChosenPoint(center(1,1:2),leftTree,params);
% Search in the right border
locsRight_rngSrch = ...
    KnnSearchingBasedOnChosenPoint(center(1,1:2),rightTree,params);                       

% Knn search should be suplimentted


% A small positive number： not bigger than this number
epsilon = 0.00001;

% Check if the circle interfers with the left border
for idx_leftPoint = 1:params.knnSrch.numNN
    
    loc_leftPoint = locsLeft_rngSrch(idx_leftPoint,1);
    % Build the segment in forward and backward directions seperately
    for idxLoop = 1:2
        if idxLoop == 1 % Build segment backward
            if loc_leftPoint == 1 % could not build backward
                % Initiate start and end points
                x_Start = leftPoints(loc_leftPoint,2);
                y_Start = leftPoints(loc_leftPoint,3);
                x_End = leftPoints(loc_leftPoint+1,2);
                y_End = leftPoints(loc_leftPoint+1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            else
                % Initiate start and end points
                x_Start = leftPoints(loc_leftPoint,2);
                y_Start = leftPoints(loc_leftPoint,3);
                x_End = leftPoints(loc_leftPoint-1,2);
                y_End = leftPoints(loc_leftPoint-1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            end
        else % Build segment forward
            if loc_leftPoint == numPoints_left % could not build forward
                % Initiate start and end points
                x_Start = leftPoints(loc_leftPoint,2);
                y_Start = leftPoints(loc_leftPoint,3);
                x_End = leftPoints(loc_leftPoint-1,2);
                y_End = leftPoints(loc_leftPoint-1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            else
                % Initiate start and end points
                x_Start = leftPoints(loc_leftPoint,2);
                y_Start = leftPoints(loc_leftPoint,3);
                x_End = leftPoints(loc_leftPoint+1,2);
                y_End = leftPoints(loc_leftPoint+1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            end
        end
        
        % The distance from the centre to the start and end points
        d_1 = distancePoint2Point(center,pointS);
        d_2 = distancePoint2Point(center,pointE);
        % If any extreme points are in the circle, circle interferes the segment
        % If the distance is smaller than the radius, the point is inside the
        % circle
        isStartPointInCirlce = (d_1 < radius_CC - epsilon);
        isEndPointInCirlce = (d_2 < radius_CC - epsilon);

        if isStartPointInCirlce || isEndPointInCirlce % A point is inside the circle
            interferingFlag = 1;
            return
        else
            % If extreme points are not in the circle, excute the following
            par_seg_sta = standardFormEquFrom2Points(pointS,pointE);
            d_3 = distancePoint2Line(center,par_seg_sta);
            if d_3 >= radius_CC - epsilon
                interferingFlag = 0;
            else
                angle_1 = (center(1) - pointS(1))*(pointE(1) - pointS(1)) + ...
                    (center(2) - pointS(2))*(pointE(2) - pointS(2));
                angle_2 = (center(1) - pointE(1))*(pointS(1) - pointE(1)) + ...
                    (center(2) - pointE(2))*(pointS(2) - pointE(2));
                % When COS() > 0, the angle is less than 90 degree
                if angle_1 > 0 && angle_2 > 0
                    interferingFlag = 1;
                    return
                else
                    interferingFlag = 0;
                end
            end
        end % if isStartPointInCirlce || isEndPointInCirlce
 
    end % for idxLoop = 1:2
    
end % for idx_leftPoint = 1:numPointsLeft_rs


% Check if the circle interfers with the right border
for idx_rightPoint = 1:params.knnSrch.numNN
    
    loc_rightPoint = locsRight_rngSrch(idx_rightPoint,1);
    % Build the segment in forward and backward directions seperately
    for idxLoop = 1:2
        if idxLoop == 1 % Build segment backward
            if loc_rightPoint == 1 % could not build backward
                % Initiate start and end points
                x_Start = rightPoints(loc_rightPoint,2);
                y_Start = rightPoints(loc_rightPoint,3);
                x_End = rightPoints(loc_rightPoint+1,2);
                y_End = rightPoints(loc_rightPoint+1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            else
                % Initiate start and end points
                x_Start = rightPoints(loc_rightPoint,2);
                y_Start = rightPoints(loc_rightPoint,3);
                x_End = rightPoints(loc_rightPoint-1,2);
                y_End = rightPoints(loc_rightPoint-1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            end
        else % Build segment forward
            if loc_rightPoint == numPoints_right % could not build forward
                % Initiate start and end points
                x_Start = rightPoints(loc_rightPoint,2);
                y_Start = rightPoints(loc_rightPoint,3);
                x_End = rightPoints(loc_rightPoint-1,2);
                y_End = rightPoints(loc_rightPoint-1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            else
                % Initiate start and end points
                x_Start = rightPoints(loc_rightPoint,2);
                y_Start = rightPoints(loc_rightPoint,3);
                x_End = rightPoints(loc_rightPoint+1,2);
                y_End = rightPoints(loc_rightPoint+1,3);
                pointS = [x_Start,y_Start];
                pointE = [x_End,y_End];
            end
        end
            
        % The distance from the centre to the start and end points
        d_1 = distancePoint2Point(center,pointS);
        d_2 = distancePoint2Point(center,pointE);
        % If any extreme points are in the circle, circle interferes the segment
        % If the distance is smaller than the radius, the point is inside the
        % circle
        isStartPointInCirlce = (d_1 < radius_CC - epsilon);
        isEndPointInCirlce = (d_2 < radius_CC - epsilon);

        if isStartPointInCirlce || isEndPointInCirlce % A point is inside the circle
            interferingFlag = 1;
            return
        else
            % If extreme points are not in the circle, excute the following
            par_seg_sta = standardFormEquFrom2Points(pointS,pointE);
            d_3 = distancePoint2Line(center,par_seg_sta);
            if d_3 >= radius_CC - epsilon
                interferingFlag = 0;
            else
                angle_1 = (center(1) - pointS(1))*(pointE(1) - pointS(1)) + ...
                    (center(2) - pointS(2))*(pointE(2) - pointS(2));
                angle_2 = (center(1) - pointE(1))*(pointS(1) - pointE(1)) + ...
                    (center(2) - pointE(2))*(pointS(2) - pointE(2));
                % When COS() > 0, the angle is less than 90 degree
                if angle_1 > 0 && angle_2 > 0
                    interferingFlag = 1;
                    return
                else
                    interferingFlag = 0;
                end
            end
        end
        
    end % for idxLoop = 1:2
end % for idx_rightPoint = 1:numPointsRight_rs

end