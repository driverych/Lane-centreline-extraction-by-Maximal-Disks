% centrepointFrom2Lines - Calculate the centrepoint of the given two lines 
%                         and the x coordinate (x_c) of a candidate point.  
%                         The line equation is in standard form.
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
%    position_c = centrepointFrom2Lines(par_1,par_2,x_c)
%
% Input:
%    par_1 - parameters of a line in stand form equation
%    par_2 - parameters of a line in stand form equation
%    x_c - the x coordinate of the centerpoint
%
% Output:
%    position_c - the coordinate of the centerpoint
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter

% Distance from a point (x,y) to the line:
% distance = abs(Ax + By + C)/sqrt(A^2 + B^2)
% quadratic equation in one unknown: a*y^2 + b*y + c = 0
function position_c = centrepointFrom2Lines(par_1,par_2,x_c)

A_1 = par_1(1);B_1 = par_1(2);C_1 = par_1(3);
A_2 = par_2(1);B_2 = par_2(2);C_2 = par_2(3);

E = (A_1^2 + B_1^2)/(A_2^2 + B_2^2);
a = (B_1^2 - E*B_2^2);
b = 2*((A_1*x_c+C_1)*B_1 - E*(A_2*x_c+C_2)*B_2);
c = (A_1*x_c+C_1)^2 - E*(A_2*x_c+C_2)^2;
y_c_1 = (-b-sqrt(b^2-4*a*c))/(2*a);
y_c_2 = (-b+sqrt(b^2-4*a*c))/(2*a);

position_c(1,1:2) = [x_c,y_c_1];
position_c(2,1:2) = [x_c,y_c_2];

end