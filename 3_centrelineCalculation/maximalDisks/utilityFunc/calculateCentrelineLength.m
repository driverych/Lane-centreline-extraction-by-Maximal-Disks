% calculateCentrelineLength
%   - Calculate the total length of a centreline and all seperate segment
%     length in the border
% 
% Syntax:  lgth_Centreline = calculateCentrelineLength(circlesConnected,numCircles)
%
% Input:
%    borderPoints - A matlab martix storing border points coordinates.
%                   Its field is [x,y]
%
% Output:
%    lgth_Border - The length of the whole border
%    lgth_Segs - A matlab matrix to store each segment's length in order
%
% Subfunctions: distancePoint2Point
%
% MAT-files required: none
% Abbreviation:
% lgth -> length
% seg -> segment
% num -> number
% S -> start
% E -> end

function lgth_Centreline = calculateCentrelineLength(circlesConnected,numCircles)

% Initialize the length
lgth_Centreline = 0;

% Accumulate the segment lengths
numSegs = numCircles - 1;
for idxSeg = 1:numSegs
    pointS = circlesConnected(idxSeg,1:2);
    pointE = circlesConnected(idxSeg+1,1:2);
    lgthSeg = distancePoint2Point(pointS,pointE);
    lgth_Centreline = lgth_Centreline + lgthSeg;
end

end