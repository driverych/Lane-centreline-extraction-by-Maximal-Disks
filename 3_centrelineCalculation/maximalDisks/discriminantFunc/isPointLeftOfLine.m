% isPointLeftOfLine - Judge if a point is on the left of a line
%
% Syntax:  
%    pointIsLeftOfLine_flag = isPointLeftOfLine(point,linePoints)
%
% Input:
%    point - the point to be judged
%    linePoints - the extreme points of the line
%
% Output:
%    pointIsLeftOfLine_flag - the flag indicates if the point if left of
%                             the line
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation: none

% The used method:
% Take an example: C(0,2)is out of a line, which starts with A(1,0) and
% ends up with B(-1,0)
% If (B.x-A.x)*(C.y-A.y)-(B.y-A.y)*(C.x-A.x)>0
% Then C is left of line AB
% Else C is right of line AB
% -------------------> L
%         * (x_centrePoint,y_centrePoint_1)
% -------------------> R
function pointIsLeftOfLine_flag = isPointLeftOfLine(point,linePoints)

x_start = linePoints(1);y_start = linePoints(2);
x_end = linePoints(3);y_end = linePoints(4);
x_point = point(1);y_point = point(2);
calcualtion = (x_end - x_start)*(y_point - y_start) - (y_end - y_start)*(x_point - x_start);

if calcualtion > 0
    pointIsLeftOfLine_flag = 1;
else
    pointIsLeftOfLine_flag = 0;
end

end