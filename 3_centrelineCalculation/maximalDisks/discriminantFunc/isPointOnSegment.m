% This function is used to decide whether a point is on the line segment
% First,the point-to-line distance is calculated;
% Second,the coordinate range is compared
function pointOnSegment = isPointOnSegment(point,line)
    distTolerance = 0.01;
    par_line_Sta = standardFormEquFrom2Points(line(1:2),line(3:4));
    distPoint2Line = distancePoint2Line(point,par_line_Sta);
    
    if distPoint2Line > distTolerance % Compare the point-to-line dist
        pointOnSegment = 0;
        return
    else
        x_startPoint = line(1);
        x_endPoint = line(3);
        max_Range = max([x_startPoint(1),x_endPoint(1)]);
        min_Range = min([x_startPoint(1),x_endPoint(1)]);
        if point(1) > max_Range || point(1) < min_Range
            pointOnSegment = 0;
        else
            pointOnSegment = 1;
        end
    end
    
end