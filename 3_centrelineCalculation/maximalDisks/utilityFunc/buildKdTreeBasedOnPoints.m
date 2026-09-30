
% buildKdTreeBasedOnPoints
%   - Build Kd tree based on point coordinates
% 
% Syntax:  KdTree = buildKdTreeBasedOnPoints(pointData,fld_coords,param)
%
% Input:
%    pointData - The point data
%    fld_coords - The data field of the coordinates
%    param - The basic parameters of the Kd tree
%
% Output:
%    KdTree - The created kd tree
%
% Subfunctions: none
%               
% MAT-files required: none
% Abbreviation:
% param -> parameter
% dist -> distance
% fld -> field

function KdTree = buildKdTreeBasedOnPoints(pointData,params)

KdTree = KDTreeSearcher(pointData,'Distance',params.KdTree.distMetric,...
                                  'BucketSize',params.KdTree.BucketSize);

end