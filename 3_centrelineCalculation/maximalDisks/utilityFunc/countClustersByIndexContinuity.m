% countClustersByIndexContinuity
%   - Count how many clusters are in the point pair by target element index
%
% Input:
%    pointPairs_baseSegSP2Tgt - Point pairs with one base element and
%                               several target elements
%
%    fld_idxs_TgtPoint - The field of the index of the target element
%
% Output:
%    locsDisc - Locations of the discontinity
%    numClusters - The number of discontinuity
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% disc -> discontinous
% cont -> continous
% lgth -> length
% num -> number
% idx -> index
% NN -> nearest neighbor
% CC -> circle centre
% pp -> point pair
% S -> start
% R -> right
% L -> left
% E -> end

% Row   Next    Curr    Diff    Disc
% 1     2       1       1       0
% 2     3       2       1       0
% 3     5       3       2       1
% 4     6       5       1       0
% 5     8       6       2       1
% 6     9       8       1       0
% 7     9       9       0       0

function [locsDisc,numClusters] = countClustersByIndexContinuity(pointPairs_baseSegSP2Tgt,fld_idxs_TgtPoint)

% Index of the target elements in the current positions
idxs_tgt_curr = pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint);
% Index of the target elements in the next positions, the last one is
% duplicated with the last second
idxs_tgt_next = [pointPairs_baseSegSP2Tgt(2:end,fld_idxs_TgtPoint);
                 pointPairs_baseSegSP2Tgt(end,fld_idxs_TgtPoint)];
flagMatrix = abs(idxs_tgt_next) - abs(idxs_tgt_curr);
locsDisc = find(flagMatrix > 1);

if isempty(locsDisc) == 1
    numClusters = 1;
else
    numClusters = size(locsDisc,1) + 1;
    % Add the last data. It also shows discontinuity for it is the end of
    % data
    locsDisc = [locsDisc;size(idxs_tgt_curr,1)];
end

end