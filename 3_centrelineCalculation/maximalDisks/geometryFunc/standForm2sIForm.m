% standForm2sIForm - convert standard form funciton to slope intercept function
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
%    par_sI = standForm2pSForm(par_Sta)
%
% Input:
%    par_Sta - the parameters in stand equation form
%
% Output:
%    par_sI - the equation parameters in 'y = kx + b '
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% par -> parameter
% sI -> slope intercept

function par_sI = standForm2sIForm(par_Sta)

A = par_Sta(1); B = par_Sta(2); C = par_Sta(3); 

% Before 20240414
% if B ~= 0
%     k = -A/B;
%     b = -C/B;
% end
% par_sI = [k,b];


% After 20240414
if B ~= 0
    k = -A/B;
    b = -C/B;
else % The line is perpendicular to the x axis.
    k = sign(A)*(-1)*inf;
    b = sign(C)*(-1)*inf; 
end
par_sI = [k,b];
    
end