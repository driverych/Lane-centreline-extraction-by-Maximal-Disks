% buildLanes_DFS_noLoop:
%   - Build static Lanelet topology and loop-free lane paths with DFS.
%
% Syntax:
%   - [lanelet_out,idxs_lanes] = buildLanes_DFS_noLoop( ...
%         lanelet_in,num_initLanelets,idxs_initLanelet)
%
% Input:
%    lanelet_in - The Lanelet struct
%    num_initLanelets - The number of initial Lanelets
%    idxs_initLanelet - The indexes of initial Lanelets
%
% Output:
%    lanelet_out - The Lanelet struct with stable topology information
%    idxs_lanes - A Lanelet index table, each row is one loop-free path
%
% Other m-files required: getLeftStartPointID.m
%                         getRightStartPointID.m
%                         getLeftEndPointID.m
%                         getRightEndPointID.m
%                         filterLaneData.m
% Subfunctions: buildStaticLaneletTopology
%               rebuildParentsFromChildren
%               dfsLaneletPathNoLoop
%               findTraversalSuccessorLanelets
%               appendUniqueTraversalChild
%               appendUniqueTopologyChild
%               convertPathCellToLaneTable
% MAT-files required: none

function [lanelet_out,idxs_lanes] = ...
    buildLanes_DFS_noLoop( ...
        lanelet_in,num_initLanelets,idxs_initLanelet)

% Build topology independently of the DFS path state.
lanelet_out = buildStaticLaneletTopology(lanelet_in);
lanelet_out = rebuildParentsFromChildren(lanelet_out);

% Build loop-free lane paths without modifying the static topology.
paths = {};
for idx_initLanelet = 1:num_initLanelets
    idx_firstLanelet = idxs_initLanelet(idx_initLanelet);
    initInvertFlag = 0;
    pathIdx = idx_firstLanelet;
    paths = dfsLaneletPathNoLoop( ...
        lanelet_out,idx_firstLanelet,initInvertFlag,pathIdx,paths);
end

idxs_lanes = convertPathCellToLaneTable(paths);
idxs_lanes = filterLaneData(idxs_lanes);

end

function lanelet_out = buildStaticLaneletTopology(lanelet_in)

lanelet_out = lanelet_in;
numLanelets = numel(lanelet_in);

for idxLanelet = 1:numLanelets
    topologyChildren = struct('index',{},'ID',{});

    children = findTraversalSuccessorLanelets( ...
        lanelet_in,idxLanelet,0);
    for idxChild = 1:numel(children)
        topologyChildren = appendUniqueTopologyChild( ...
            topologyChildren,children(idxChild));
    end

    % A bidirectional Lanelet can be reached in either direction. Store the
    % union in the static topology; the DFS keeps the direction separately.
    if lanelet_in(idxLanelet).isOneWay == 0
        children = findTraversalSuccessorLanelets( ...
            lanelet_in,idxLanelet,1);
        for idxChild = 1:numel(children)
            topologyChildren = appendUniqueTopologyChild( ...
                topologyChildren,children(idxChild));
        end
    end

    lanelet_out(idxLanelet).Children = topologyChildren;
end

end

function lanelet_out = rebuildParentsFromChildren(lanelet_in)

lanelet_out = lanelet_in;
numLanelets = numel(lanelet_out);

for idxLanelet = 1:numLanelets
    lanelet_out(idxLanelet).Parents = [];
end

for idxParent = 1:numLanelets
    children = lanelet_out(idxParent).Children;
    for idxChild = 1:numel(children)
        idxChildLanelet = children(idxChild).index;
        parents = lanelet_out(idxChildLanelet).Parents;

        if isempty(parents) || ...
                any([parents.index] == idxParent) == 0
            idxNewParent = numel(parents) + 1;
            lanelet_out(idxChildLanelet).Parents(idxNewParent).ID = ...
                lanelet_out(idxParent).ID;
            lanelet_out(idxChildLanelet).Parents(idxNewParent).index = ...
                idxParent;
        end
    end
end

end

function paths = dfsLaneletPathNoLoop( ...
    lanelet,idxCurrLanelet,invertFlag,pathIdx,paths)

children = findTraversalSuccessorLanelets( ...
    lanelet,idxCurrLanelet,invertFlag);

if isempty(children) == 0
    childIdxs = [children.index];
    children(ismember(childIdxs,pathIdx)) = [];
end

if isempty(children)
    paths{end + 1,1} = pathIdx;
    return
end

for idxChild = 1:numel(children)
    childIdx = children(idxChild).index;
    childInvertFlag = children(idxChild).invertFlag;
    pathIdx_next = [pathIdx,childIdx];

    paths = dfsLaneletPathNoLoop( ...
        lanelet,childIdx,childInvertFlag,pathIdx_next,paths);
end

end

function children = findTraversalSuccessorLanelets( ...
    lanelet,idxCurrLanelet,invertFlag)

children = struct('index',{},'ID',{},'invertFlag',{});

if idxCurrLanelet == 0
    return
end

if invertFlag == 0
    ID_ePoint_left_curr = ...
        getLeftEndPointID(lanelet,idxCurrLanelet);
    ID_ePoint_right_curr = ...
        getRightEndPointID(lanelet,idxCurrLanelet);
else
    ID_ePoint_left_curr = ...
        getRightStartPointID(lanelet,idxCurrLanelet);
    ID_ePoint_right_curr = ...
        getLeftStartPointID(lanelet,idxCurrLanelet);
end

numLanelets = numel(lanelet);
for idx_candLanelet = 1:numLanelets
    ID_sPoint_left_cand = ...
        getLeftStartPointID(lanelet,idx_candLanelet);
    ID_sPoint_right_cand = ...
        getRightStartPointID(lanelet,idx_candLanelet);
    ID_ePoint_left_cand = ...
        getLeftEndPointID(lanelet,idx_candLanelet);
    ID_ePoint_right_cand = ...
        getRightEndPointID(lanelet,idx_candLanelet);

    isLeftLinked = ...
        (ID_ePoint_left_curr == ID_sPoint_left_cand);
    isRightLinked = ...
        (ID_ePoint_right_curr == ID_sPoint_right_cand);
    if isLeftLinked && isRightLinked
        child.index = idx_candLanelet;
        child.ID = lanelet(idx_candLanelet).ID;
        child.invertFlag = 0;
        children = appendUniqueTraversalChild(children,child);
    end

    % Preserve the bidirectional successor rule of buildLanes_DFS.m.
    if lanelet(idxCurrLanelet).isOneWay == 0
        isCurrL_CandRLinked = ...
            (ID_ePoint_left_curr == ID_ePoint_right_cand);
        isCurrR_CandLLinked = ...
            (ID_ePoint_right_curr == ID_ePoint_left_cand);
        if isCurrR_CandLLinked && isCurrL_CandRLinked
            child.index = idx_candLanelet;
            child.ID = lanelet(idx_candLanelet).ID;
            child.invertFlag = 1;
            children = appendUniqueTraversalChild(children,child);
        end
    end
end

end

function children = appendUniqueTraversalChild(children,child)

if isempty(children)
    children = child;
    return
end

isSameIdx = ([children.index] == child.index);
isSameDirection = ([children.invertFlag] == child.invertFlag);
if any(isSameIdx & isSameDirection) == 0
    children(end + 1) = child;
end

end

function topologyChildren = ...
    appendUniqueTopologyChild(topologyChildren,child)

if isempty(topologyChildren) || ...
        any([topologyChildren.index] == child.index) == 0
    idxNewChild = numel(topologyChildren) + 1;
    topologyChildren(idxNewChild).index = child.index;
    topologyChildren(idxNewChild).ID = child.ID;
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
    idxs_lanes(idxPath,1:numel(path)) = path;
end

end
