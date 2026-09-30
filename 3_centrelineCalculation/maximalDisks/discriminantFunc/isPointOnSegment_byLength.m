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

function isQueryPtOnSeg = isPointOnSegment_byLength(queryPt,tgtSeg)
    
% The length of the the segment
tgtSegLgth = distancePoint2Point(tgtSeg(1,1:2),tgtSeg(1,3:4));    
    
% The distances from the query point to the start and end points of target
% segment
dist_queryPt2segS = distancePoint2Point(queryPt,tgtSeg(1:2));
dist_queryPt2segE = distancePoint2Point(queryPt,tgtSeg(3:4));    
dist_total = dist_queryPt2segS + dist_queryPt2segE;

% add/minus a factor
epsilon = 0.01;
isQueryPtOnSeg = (dist_total < tgtSegLgth + epsilon);

end