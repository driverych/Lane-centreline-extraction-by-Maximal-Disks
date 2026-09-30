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

function interferingFlag = isCircleInterferringSegments(center,radius,segments)

% The 0.9999 is a tolerant factor
radius = radius * 0.9999;

% A small positive number
% epsilon = 0.0002;

numSegs = segments.numSegments;
for idx_seg = 1:numSegs
    % Initiate start and end points
    x_Start = segments.segments(idx_seg).x_start;
    y_Start = segments.segments(idx_seg).y_start;
    x_End_ = segments.segments(idx_seg).x_end;
    y_End = segments.segments(idx_seg).y_end;
    pointS = [x_Start,y_Start];
    pointE = [x_End_,y_End];

    d_1 = distancePoint2Point(center,pointS);
    d_2 = distancePoint2Point(center,pointE);
    % If any extreme points are in the circle, circle interferes the segment
    isStartPointInCirlce = (d_1 < radius);
    isEndPointInCirlce = (d_2 < radius);
    
    if isStartPointInCirlce || isEndPointInCirlce
        interferingFlag = 1;
        break
    else
        % If extreme points are not in the circle, excute the following
        par_seg_sta = standardFormEquFrom2Points(pointS,pointE);
        d_3 = distancePoint2Line(center,par_seg_sta);
        if d_3 >= radius
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
end

end