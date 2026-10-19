% buildLanes - Build a lanelet table with each row representing a lane. The
%              lane number depends on the table row number and the lane 
%              length depends on the column number of each row.
%
% Syntax:  
%    [lanelet_out,idxs_lanes_out] = buildLanes(lanelet_in,num_initLanelets,idxs_initLanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    num_initLanelets - the number of initial lanelets
%    idxs_initLanelet - all index of initial lanelets in the lanelet struct
%
% Output:
%    lanelet_out - the lanelet struct
%    idxs_lanes_out - a lanelet index table, arranged to store lane info
%
% Other m-files required: findSuccessiveLaneletsOfInitialLanelet.m
%                         buildLanesFromInitLanelet.m
% Subfunctions: findSuccessiveLaneletsOfInitialLanelet
%               buildLanesFromInitLanelet
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% init -> initial lanelet
% num -> number
% idx -> index
% col -> column
% id -> identification


function [lanelet_out,idxs_lanes] = buildLanes(lanelet_in,num_initLanelets,idxs_initLanelet)

% Initiate ID and index containers for lanes
IDs_lanes = zeros(50,20);
idxs_lanes = zeros(50,20);
rowStart = 1;

% Find following lanelets of the initial lanelets
for idx_initLanelet = 1:num_initLanelets
    % Initiate the first lanelet of the lane
    idx_firstLanelet = idxs_initLanelet(idx_initLanelet);
    
    % Build a lanelet table, starting from the initial lanelet
    [lanelet_in,tableInfo,cntrTable_lanelet,idxTable_lanelet,IDTable_lanelet] = ...
        findSuccessiveLaneletsOfInitialLanelet(lanelet_in,idx_firstLanelet);

    % Extend lanes from initial lanelets
    [idxTable_lane,IDTable_lane] = ...
        buildLanesFromInitLanelet(tableInfo,cntrTable_lanelet,idxTable_lanelet,IDTable_lanelet);
    
    % maxCol refers to the maximum length of a lanelet
    % maxRow refers to the maximum lane number
    maxRow = tableInfo.maxRow;
    maxCol = tableInfo.maxCol;
    % Lane container
    for idxRow = 1:maxRow
        for idxCol = 1:maxCol
            IDs_lanes(rowStart + idxRow - 1,idxCol) = ...
                IDTable_lane(idxRow,idxCol);
            idxs_lanes(rowStart + idxRow - 1,idxCol) = ...
                idxTable_lane(idxRow,idxCol);
        end
    end
    rowStart = rowStart + maxRow;
end

% Remove useless data in the lane table
idxs_lanes = filterLaneData(idxs_lanes);

% Update the output of the lanelet
lanelet_out = lanelet_in;


end