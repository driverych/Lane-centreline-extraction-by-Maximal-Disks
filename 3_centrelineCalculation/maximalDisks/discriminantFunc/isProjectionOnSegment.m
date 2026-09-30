% isProjectionOnSegment - Judge if the point projection is on the segment
%
% Syntax:  
%    outRange = isProjectionOnSegment(point,line)
%
% Input:
%    point - the point to be judged
%    line - the line which the point will be projected to
%
% Output:
%    outRange - if the point is out of the range of the segment
%
% Other m-files required: standardFormEquFrom2Points.m
%                         projectPoint2Line.m
% Subfunctions: standardFormEquFrom2Points, projectPoint2Line
% MAT-files required: none
% Abbreviation:
% par -> parameter
% sta -> standard
% equ -> equation

function isProjOnSeg = isProjectionOnSegment(point,seg,par_seg_Sta)

% The length of the the segment
lenSeg = distancePoint2Point(seg(1:2),seg(3:4));

% Calculate the intersection point
p_proj2Seg = projectPoint2Line(point,par_seg_Sta);

% The distances from projection point to the start and end points of
% segment
dist_proj2segS = distancePoint2Point(p_proj2Seg,seg(1:2));
dist_proj2segE = distancePoint2Point(p_proj2Seg,seg(3:4));

% add/minus a factor
epsilon = 0.01;
isProjOnSeg = (dist_proj2segS+dist_proj2segE) < lenSeg + epsilon;

end