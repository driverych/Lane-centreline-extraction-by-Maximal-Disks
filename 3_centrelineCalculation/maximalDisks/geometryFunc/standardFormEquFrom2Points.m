% standardFormEquFrom2Points - Calculate the line equation in standard form,
%                              give two points.
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
%    par = standardFormEquFrom2Points(point_1,point_2)
%
% Input:
%    point_1 - the first point, [x,y]
%    point_2 - the second point, [x,y]
%
% Output:
%    par - the equation parameters in 'Ax + By + C = 0 '
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter
% equ -> equation

function par = standardFormEquFrom2Points(point_1,point_2)

x_1 = point_1(1);y_1 = point_1(2);
x_2 = point_2(1);y_2 = point_2(2);

A = y_2 - y_1;
B = - (x_2 - x_1);
C = y_1*(x_2 - x_1) - x_1*(y_2 - y_1);

par = [A,B,C];

% Limitation: if B == 0, stand form cannot be converted into Slope-intercept form

end