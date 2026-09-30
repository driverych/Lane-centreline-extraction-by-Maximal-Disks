% perpendicularLineFromPointAndLine_Sta - calculate the perpendicular line 
%                                         passing a given point. The lines 
%                                         listed here are all in standard
%                                         form.
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
%    par = perpendicularLineFromPointAndLine_Sta(point,linePar)
%
% Input:
%    point - the coordinate of the point
%    linePar - line equation parameters in the standard form
%
% Output:
%    par - perpendicular line equation parameters in the standard form
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter

% line function: Ax + By + C = 0;
% point: (x1,y1)
% perpendicular line function: Bx - Ay + A*y1 -B*x1 = 0
function par = perpendicularLineFromPointAndLine_Sta(point,linePar)

A = linePar(1);B = linePar(2);C = linePar(3);
x_1 = point(1);y_1 = point(2);

if A ~= 0
    A_p = B;
    B_p = -A;
    C_p = A*y_1 - B*x_1;
else
    A_p = 1;
    B_p = 0;
    C_p = -x_1;
end

par = [A_p,B_p,C_p];

end