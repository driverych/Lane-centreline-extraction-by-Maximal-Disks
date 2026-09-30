% calculateBorderLength
%   - Calculate the total length of a border and all seperate segment
%     length in the border
% 
% Syntax:  [lgth_Border,lgth_Segs] = calculateBorderLength(borderPoints)
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

function [lgth_Border,lgth_Segs] = calculateBorderLength(borderPoints)

% Initialize the length
lgth_Border = 0; lgth_Segs = [];

% Accumulate the segment lengths
numPoints = size(borderPoints,1);
numSegs = numPoints - 1;
for idxSeg = 1:numSegs
    pointS = borderPoints(idxSeg,:);
    pointE = borderPoints(idxSeg+1,:);
    lgthSeg = distancePoint2Point(pointS,pointE);
    lgth_Border = lgth_Border + lgthSeg;
    lgth_Segs = [lgth_Segs;lgthSeg];
end
    
end