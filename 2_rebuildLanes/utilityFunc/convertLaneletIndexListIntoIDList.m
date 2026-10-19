

function IDs_laneLanelets = convertLaneletIndexListIntoIDList(alignedLanelet,idxs_laneLanelets)

% Get the lane number and the maximal length of the lanes
[maxNum_lanes,maxNum_laneLanelets] = size(idxs_laneLanelets);

% Initialize the indexes container
idxs_laneLanelets_filtered = [];
cntrRow = 0;

% Eliminate rows starting with zero
for idxRow = 1:maxNum_lanes
    firstElem = idxs_laneLanelets(idxRow,1);
    if firstElem == 0
        continue
    else
        cntrRow = cntrRow + 1;
        idxs_laneLanelets_filtered = [idxs_laneLanelets_filtered; idxs_laneLanelets(idxRow,:)];
    end
    
end % for idxRow = 1:maxNum_lanes

% Convert indexes into IDs
IDs_laneLanelets = zeros(cntrRow,maxNum_laneLanelets);
for idxRow = 1:cntrRow
    for idxCol = 1:maxNum_laneLanelets
        idx_lanelet = idxs_laneLanelets_filtered(idxRow,idxCol);
        if idx_lanelet == 0
            continue
        else
            ID_lanelet = alignedLanelet(idx_lanelet).ID;
            IDs_laneLanelets(idxRow,idxCol) = ID_lanelet;
        end
    end
end


end