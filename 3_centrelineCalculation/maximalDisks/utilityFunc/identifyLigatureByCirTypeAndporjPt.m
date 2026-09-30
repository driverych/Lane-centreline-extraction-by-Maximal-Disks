% The centreline segments composed of two Case 60 with shared passed points
% are identified as ligatures

% lgt -> ligature


function rowLocns_lgt = identifyLigatureByCirTypeAndporjPt(circlesConnected)

% The field of the circle type in the circlesConnected
fld_coord_CC2Tgt_1 = 5:6;
fld_cirType = 14;
% The target circle type:
tgtCirType = 60;

% Append row location information to the circlesConnected
numCirs = size(circlesConnected,1);
% Create an row location index
rowLocns_inCirclesConnected = (1:numCirs)';
% Append row location index information to the circlesConnected
circlesConnected_indexed = [circlesConnected,rowLocns_inCirclesConnected];

% The target circle type is marked with a flag of 1
flag_tgtCirType = (circlesConnected_indexed(:,fld_cirType) == tgtCirType);

% The filtered circle data
circlesConnected_indexed_tgtCirType = circlesConnected_indexed(flag_tgtCirType,:);

% The coordinates of the CC2Tgt_1 point
coords_CC2Tgt_1_tgtCirType = circlesConnected_indexed_tgtCirType(:,fld_coord_CC2Tgt_1);

% Unique CC2Tgt_1 point: projection point
[~, ~, rowLocns_inUniCC2Tgt_1_tgtCirType] = unique(coords_CC2Tgt_1_tgtCirType, 'rows','stable');
counts_UniRowLocns = accumarray(rowLocns_inUniCC2Tgt_1_tgtCirType, 1);
duplicate_indices = find(counts_UniRowLocns > 1);

% 
duplicate_pairs = circlesConnected_indexed_tgtCirType(ismember(rowLocns_inUniCC2Tgt_1_tgtCirType, duplicate_indices), :);

result_indices = duplicate_pairs(:, 18);

rowLocns_lgt = reshape(result_indices, 2, [])';


end