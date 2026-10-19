% Identify duplicated lanes by their left and right border points


% cand -> candidate
% num -> number
% idx -> index


function [laneList,idxs_laneLanelets] = removeDuplicatedLanes(laneList_cand,idxs_laneLanelets_cand)

% Initialize the lane counter
numLanes = 0;
numLaneCands = numel(laneList_cand);

% The maximal number of lanes and number of Lanelets in each lane
[maxNum_lanes,maxNum_laneLanelets] = size(idxs_laneLanelets_cand);
idxs_laneLanelets = zeros(maxNum_lanes,maxNum_laneLanelets);

for idxCand = 1:numLaneCands
    % Put the first candidate lane in the lane list
    % The first will not be identical
    if idxCand == 1
        numLanes = numLanes + 1;
        laneList(numLanes) = laneList_cand(idxCand);
        idxs_laneLanelets(numLanes,:) = idxs_laneLanelets_cand(idxCand,:);
        continue
    end
    
    % Extract a lane from candidate lane list
    leftPoints_cand = [laneList_cand(idxCand).leftBoundary.Points(:).ID];
    rightPoints_cand = [laneList_cand(idxCand).rightBoundary.Points(:).ID];  
    numLeftPoints_cand = size(leftPoints_cand,2);
    numRightPoints_cand = size(rightPoints_cand,2);
    
    % Find if the candidate lane has existed in the lane list
    for idxLane = 1:numLanes
        % Extract a lane from the lane list
        leftPoints = [laneList(idxLane).leftBoundary.Points(:).ID];
        rightPoints = [laneList(idxLane).rightBoundary.Points(:).ID];  
        numLeftPoints = size(leftPoints,2);
        numRightPoints = size(rightPoints,2);
        
        % Initialize the default flag
        isLaneDuplicated = 0;
        
        % Case 1:
        if numLeftPoints == numLeftPoints_cand && numRightPoints == numRightPoints_cand
            % uni-directional lanes
            isLeftSame = isequal(leftPoints,leftPoints_cand);
            isRightSame = isequal(rightPoints,rightPoints_cand);
            if isLeftSame && isRightSame
                isLaneDuplicated = 1;
                break
            end
        end
        
        % Case 2:
        if numLeftPoints == numRightPoints_cand && numRightPoints == numLeftPoints_cand
            % bi-directional lanes
            isLeftSame = isequal(leftPoints,rightPoints_cand);
            isRightSame = isequal(rightPoints,leftPoints_cand);
            if isLeftSame && isRightSame
                isLaneDuplicated = 1;
                break
            end
        end
        
    end % for idxLane = 1:numLanes
    
    if isLaneDuplicated == 0
        numLanes = numLanes + 1;   
        laneList(numLanes) = laneList_cand(idxCand);
        idxs_laneLanelets(numLanes,:) = idxs_laneLanelets_cand(idxCand,:);
    end

end

end
