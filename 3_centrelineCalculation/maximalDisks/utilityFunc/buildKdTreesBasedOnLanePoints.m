
% buildKdTreesBasedOnLanePoints
%   - Build Kd tree based on point coordinates of both left and right
%     borders
% 
% Syntax:  [leftTree,rightTree] = buildKdTreesBasedOnLanePoints(laneInfo)
%
% Input:
%    lanePoints - The data of the lane points (index and coordinates)
%    laneInfo - The basic lane info (the number of the border points)
%    fld - The field info
%
% Output:
%    KdTree - The created kd tree
%
% Subfunctions: none
%               
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% param -> parameter
% idx -> index
% fld -> field
% L -> left
% R -> right

function [leftTree,rightTree,params] = buildKdTreesBasedOnLanePoints(lanePoints,laneInfo,flds)

% The numbers of points on both borders
numPoints_L = laneInfo.leftPoints.number;
numPoints_R = laneInfo.rightPoints.number;
% Extract the left and right border points
leftPoints = lanePoints(1:numPoints_L,flds.lanePoints.coords);
rightPoints = lanePoints(numPoints_L + 1:numPoints_L + numPoints_R,flds.lanePoints.coords);

% The distance metric
params.KdTree.distMetric = 'euclidean';
% Parameters of the kdTree
params.KdTree.BucketSize = 15;
% Build the tree according to left points
leftTree = buildKdTreeBasedOnPoints(leftPoints,params);
% Build the tree according to right points
rightTree = buildKdTreeBasedOnPoints(rightPoints,params);

end