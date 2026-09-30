% projectPoint2Line - Calculate projection point from a point to a line.
%                     Line equation is in standard form:A*x + B*y + C = 0
%
% Line equation: 
%   Two-point form:       
%       (y - y1)/(y2 - y1) = (x - x1)/(x2 - x1)
%       (y2 - y1)x - (x2 - x1)y + y1(x2 - x1) - x1(y2 - y1) = 0
%   Stand form:
%       Ax + By + C = 0
%   Slope-intercept form: 
%       y = kx + b
%
% Syntax:  
%    point_projection = projectPoint2Line(point,linePar)
%
% Input:
%    point - the point coordinate, [x,y]
%    linePar - the line equation in stand form: Ax + By + C = 0
%
% Output:
%    point_projection - the found projection point
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter

function point_projection = projectPoint2Line(point,linePar)

x = point(1);y = point(2);
A = linePar(1); B = linePar(2); C = linePar(3); 

if A ~= 0
    x_projection = ((B/A)*x-y-C/B)/(B/A+A/B);
    y_projection = (B/A)*x_projection - (B/A)*x + y;
else
    x_projection = x;
    y_projection = -C/B;
end

point_projection = [x_projection,y_projection];

end