% buildLanes_DFS - Build lane index paths from initial lanelets with DFS.
%
%  This DFS version is kept parallel to buildLanes.m so the
% table-based implementation can still be used for comparison.
%
% Syntax:
%    [lanelet_out,idxs_lanes] = buildLanes_DFS(lanelet_in,num_initLanelets,idxs_initLanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    num_initLanelets - the number of initial lanelets
%    idxs_initLanelet - all indexes of initial lanelets in the lanelet struct
%
% Output:
%    lanelet_out - the lanelet struct updated with Children information
%    idxs_lanes - a lanelet index table, each row is one DFS path

function [lanelet_out,idxs_lanes] = buildLanes_DFS(lanelet_in,num_initLanelets,idxs_initLanelet)

lanelet_out = lanelet_in;
paths = {};

for idx_initLanelet = 1:num_initLanelets
    idx_firstLanelet = idxs_initLanelet(idx_initLanelet);
    initInvertFlag = 0; %  Keep the same initial direction assumption as buildLanes.m.
    [lanelet_out,paths] = dfsLaneletPath(lanelet_out,idx_firstLanelet,initInvertFlag,idx_firstLanelet,paths);
end

idxs_lanes = convertPathCellToLaneTable(paths); %  Convert DFS paths into the original lane table format.
idxs_lanes = filterLaneData(idxs_lanes);

end

function [lanelet_out,paths] = dfsLaneletPath(lanelet_out,idxCurrLanelet,invertFlag,pathIdx,paths)

[children,lanelet_out] = findSuccessorLaneletsForDFS(lanelet_out,idxCurrLanelet,invertFlag,pathIdx);

if isempty(children)
    paths{end+1,1} = pathIdx; %  A lane path is complete when the current lanelet has no valid DFS successor.
    return
end

for idxChild = 1:numel(children)
    childIdx = children(idxChild).index;
    childInvertFlag = children(idxChild).invertFlag;

    if any(pathIdx == childIdx)
        continue
    end

    pathIdx_next = [pathIdx,childIdx]; %  Extend the current DFS path by one successor.
    [lanelet_out,paths] = dfsLaneletPath(lanelet_out,childIdx,childInvertFlag,pathIdx_next,paths);
end

end

function [children,lanelet_out] = findSuccessorLaneletsForDFS(lanelet_out,idxCurrLanelet,invertFlag,pathIdx)

children = struct('index',{},'ID',{},'invertFlag',{});
cntrChd = 0;

if idxCurrLanelet == 0
    return
end

if invertFlag == 0
    ID_ePoint_left_curr = getLeftEndPointID(lanelet_out,idxCurrLanelet);
    ID_ePoint_right_curr = getRightEndPointID(lanelet_out,idxCurrLanelet);
else
    ID_ePoint_left_curr = getRightStartPointID(lanelet_out,idxCurrLanelet);
    ID_ePoint_right_curr = getLeftStartPointID(lanelet_out,idxCurrLanelet);
end

numLanelet = numel(lanelet_out);
for idx_candLanelet = 1:numLanelet
    if any(pathIdx == idx_candLanelet)
        continue
    end

    ID_sPoint_left_cand = getLeftStartPointID(lanelet_out,idx_candLanelet);
    ID_sPoint_right_cand = getRightStartPointID(lanelet_out,idx_candLanelet);
    ID_ePoint_left_cand = getLeftEndPointID(lanelet_out,idx_candLanelet);
    ID_ePoint_right_cand = getRightEndPointID(lanelet_out,idx_candLanelet);

    isLeftLinked = (ID_ePoint_left_curr == ID_sPoint_left_cand);
    isRightLinked = (ID_ePoint_right_curr == ID_sPoint_right_cand);
    if isLeftLinked && isRightLinked
        cntrChd = cntrChd + 1;
        children(cntrChd).index = idx_candLanelet; %  Store forward successor.
        children(cntrChd).ID = lanelet_out(idx_candLanelet).ID;
        children(cntrChd).invertFlag = 0;
    end

    if lanelet_out(idxCurrLanelet).isOneWay == 0
        isCurrL_CandRLinked = (ID_ePoint_left_curr == ID_ePoint_right_cand);
        isCurrR_CandLLinked = (ID_ePoint_right_curr == ID_ePoint_left_cand);
        if isCurrR_CandLLinked && isCurrL_CandRLinked
            cntrChd = cntrChd + 1;
            children(cntrChd).index = idx_candLanelet; %  Store inverted successor for bidirectional lanelets.
            children(cntrChd).ID = lanelet_out(idx_candLanelet).ID;
            children(cntrChd).invertFlag = 1;
        end
    end
end

if isempty(children)
    lanelet_out(idxCurrLanelet).Children = [];
else
    lanelet_out(idxCurrLanelet).Children = rmfield(children,'invertFlag'); %  Keep Children compatible with the original index/ID fields.
end

end

function idxs_lanes = convertPathCellToLaneTable(paths)

if isempty(paths)
    idxs_lanes = [];
    return
end

numPaths = numel(paths);
maxPathLength = 0;
for idxPath = 1:numPaths
    maxPathLength = max(maxPathLength,numel(paths{idxPath}));
end

idxs_lanes = zeros(numPaths,maxPathLength);
for idxPath = 1:numPaths
    path = paths{idxPath};
    idxs_lanes(idxPath,1:numel(path)) = path; %  Store each DFS lane path as one row.
end

end
