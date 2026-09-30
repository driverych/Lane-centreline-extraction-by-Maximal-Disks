% intersectionFrom2Lines - Calculate  the intersection point of given 
%                          two lines. The line equation is in 
%                          slope-intercept form.
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
%    point_intersection = intersectionFrom2Lines(par_1,par_2)
%
% Input:
%    par_1 - the parameters of the line equation, in slope-intercept form
%    par_2 - the parameters of the line equation, in slope-intercept form
%
% Output:
%    point_intersection - the intersection point of two lines
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter
% equ -> equation

% The inversection point of two lines y = k_1*x + b_1, y = k_2*x + b_2
% x = (b_2 - b_1)/(k_1 - k_2)
function point_intersection = intersectionFrom2Lines(par_1,par_2)

k_1 = par_1(1);b_1 = par_1(2);
k_2 = par_2(1);b_2 = par_2(2);

if k_1 == k_2
    x_intersection = inf;
    y_intersection = inf;
else
    x_intersection = (b_2 - b_1)/(k_1 - k_2);
    y_intersection = k_1*x_intersection + b_1;
end

point_intersection = [x_intersection,y_intersection];

end