% matchPointsByRangeAndKnnSearching
%   - Match points from two opposite lane borders. A range searching is
%     firstly performed. But, due to sparse distribution of points, failure
%     of point matching happens from time to time. To make sure each points
%     could match at least two points on the opposite border, K-nearest
%     neighbor searching is performed if less than two point pairs are
%     found. One benefit of KNN searching is that it could guarantee
%     effective point matching while not enlarging the radius in range
%     searching, which usually causes low efficiency and reduntant
%     matching.
% 
% Syntax:  [pointPairs_CConL,pointPairs_CConR,ponitPairField] = ...
%                   matchPointsByRangeAndKnnSearching(lanePoints,laneInfo)
%
% Input:
%    lanePoints - A matlab martix storing both left and right border points.
%                 Its field is [index,x,y]
%    laneInfo - A matlab struct storing info of point numbers
%
% Output:
%    pointPairs_CConL/R - A matlab matrix to store point pairs info, the
%                         field is [idx_leftPoint,idx_rightPoint,coord_leftPoint,coord_rightPoint]
%    ponitPairField - A matlab struct to store the field info of the point
%                     pair matrix
%
% Subfunctions: pointPairing
%
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% cont -> continous
% srch -> search
% lgth -> length
% rng -> range
% num -> number
% idx -> index
% NN -> nearest neighbor
% CC -> circle centre
% R -> right
% L -> left

function [pointPairs_CConL,pointPairs_CConR,flds] = ...
    matchPointsByRangeAndKnnSearching(lanePoints,laneInfo,flds,...
                                      leftTree,rightTree,params,filterPointPairsByAccumDist)

% The distance metric should be aligned with the KdTree
% distMetric = 'euclidean';
% distMetric = 'chebychev';

% The radius of range searching
params.rngSrch.radius = 20; 
% The number of the nearest neighbors points
params.knnSrch.numNN = 6;

% Left border points are the base and right border points are the target
isLeftBase = 1;
[pointPairs_CConL,~] = pointPairing(lanePoints,laneInfo,flds,isLeftBase,...
                                    leftTree,rightTree,params,filterPointPairsByAccumDist);

% Right border points are the base and left border points are the target
isLeftBase = 0;
[pointPairs_CConR,~] = pointPairing(lanePoints,laneInfo,flds,isLeftBase,...
                                    leftTree,rightTree,params,filterPointPairsByAccumDist);

% The field info
flds.pointPair.idx_L = 1; flds.pointPair.idx_R = 2;
flds.pointPair.x_L = 3; flds.pointPair.y_L = 4;
flds.pointPair.x_R = 5; flds.pointPair.y_R = 6;

end