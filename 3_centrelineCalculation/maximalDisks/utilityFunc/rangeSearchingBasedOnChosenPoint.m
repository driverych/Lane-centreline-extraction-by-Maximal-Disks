% rangeSearchingBasedOnChosenPoint
%   - Find the row numbers of points,which lie in the circle domain of a
%     given point.
% 
% Syntax:  [cntrMatrxi_rangeSearch,numRangeSearch] = ...
%           rangeSearchingBasedOnChosenPoint(queryPoint,KdTree,rangeRadius)
%
% Input:
%    queryPoint - The centre point (circle centre of searching)
%    KdTree - The to-search points are stored in KdTree struct
%    rangeRadius - The radius of searching
%
% Output:
%    cntrMatrxi_rangeSearch - A matlab matrix to store the row numbers of
%                             found pionts, in ascending sequence.
%    numRangeSearch - The number of found points
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% srch -> search
% loc -> location
% rng -> range


function [locsMatrxi_rngSrch,numRngSrch] = ...
    rangeSearchingBasedOnChosenPoint(queryPoint,KdTree,params)

% The parameters of the range search,aligned with that of the KdTree
rngRadius = params.rngSrch.radius;
distMetric = params.KdTree.distMetric;
isSorted = 0; % false
% Find the points with a certain range in the kdtree, relative to
% the selected point
[locs_rngSrch_cell,~] = ...
    rangesearch(KdTree,queryPoint,rngRadius,'SortIndices',isSorted,'Distance',distMetric);
% Convert the cell to an array
locsMatrxi_rngSrch = [locs_rngSrch_cell{1,1}]';
% Sort the output in ascending
if isempty(locsMatrxi_rngSrch) == 0
    locsMatrxi_rngSrch = sort(locsMatrxi_rngSrch,'ascend');
end

% The number of elements found in a range
numRngSrch = size(locsMatrxi_rngSrch,1);

end