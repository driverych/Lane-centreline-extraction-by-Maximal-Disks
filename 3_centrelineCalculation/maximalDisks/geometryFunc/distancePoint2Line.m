% distancePoint2Line - Calculate  the distance from a point to a line
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
%    distance = distancePoint2Line(point,par_Sta)
%
% Input:
%    point - the coordinate of the point
%    par_Sta - the parameters of the line standard form information
%
% Output:
%    distance - the distance from the point to the line
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% sta -> standard

function distance = distancePoint2Line(point,par_Sta)
    x = point(1);y = point(2);
    A = par_Sta(1);B = par_Sta(2);C = par_Sta(3);
    distance = abs(A*x + B*y + C)/sqrt(A^2 + B^2);
end