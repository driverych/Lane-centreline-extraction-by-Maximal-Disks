% KnnSearchingBasedOnChosenPoint
%   - Find the nearest K neighbors of the given point
% 
% Syntax:  cntrMatrix_KNN = KnnSearchingBasedOnChosenPoint(queryPoint,KdTree,numNN)
%
% Input:
%    queryPoint - The centre point (circle centre of searching)
%    KdTree - The to-be-selected points are stored in KdTree struct
%    numNN - The number of the nearest neighbors
%
% Output:
%    cntrMatrix_KNN - A matlab matrix to store the row numbers of
%                     found pionts, in ascending sequence.
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% NN -> nearest neighbor
% cntr -> counter
% loc -> location


function locsMatrix_KNN = KnnSearchingBasedOnChosenPoint(queryPoint,KdTree,params)

% The parameters of the range search,aligned with that of the KdTree
numNN = params.knnSrch.numNN;
distMetric = params.KdTree.distMetric;
isSorted = 0; % false
% Find the nearest neighbors of the selected left point in the right
% kdTree
[locsMatrix_KNN,~] = ...
    knnsearch(KdTree,queryPoint,'k',numNN,'SortIndices',isSorted,'Distance',distMetric);
locsMatrix_KNN = locsMatrix_KNN';
% Sort the output in ascending
if isempty(locsMatrix_KNN) == 0
    locsMatrix_KNN = sort(locsMatrix_KNN,'ascend');
end 

end