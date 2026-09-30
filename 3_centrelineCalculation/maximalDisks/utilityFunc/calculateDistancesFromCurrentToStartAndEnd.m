% calculateDistancesFromCurrentToStartAndEnd
%   - Calculate the distance of the current point to its start and end
%     points
% 
% Syntax:  [dist_curr2start,dist_curr2end,accumulatedLgth] = ...
%           calculateDistancesFromCurrentToStartAndEnd(cntrPoint,lgth_Segs,lgth_Border,accumulatedLgth)
%
% Input:
%    cntrPoint - The row number of the point in point matrix
%    lgth_Segs - The matrix storing the lengths of all segments
%    lgth_Border - The length of the whole border
%    accumulatedLgth - The accumulated length from the former point to its
%                      start
%
% Output:
%    dist_curr2start - The distance from the current to its start point
%    dist_curr2end - The distance from the current to its end point
%    accumulatedLgth - The accumulated length from the current point to its
%                      start
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% accum -> accumulated
% curr -> current
% dist -> distance
% lgth -> length
% cntr -> counter
% seg -> segment

function [dist_curr2start,dist_curr2end,accumLgth] = ...
    calculateDistancesFromCurrentToStartAndEnd(cntrPoint,lgth_Segs,lgth_Border,accumLgth)

if cntrPoint == 1
    currSegLgth = 0;
else
    currSegLgth = lgth_Segs(cntrPoint-1,1);
end
accumLgth = accumLgth + currSegLgth;
dist_curr2start = accumLgth;
dist_curr2end = lgth_Border - accumLgth;

end