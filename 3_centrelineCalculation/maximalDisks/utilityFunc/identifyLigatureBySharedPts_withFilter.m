function lgtData = identifyLigatureBySharedPts_withFilter(circlesConnected,laneInfo,lanePoints)
% identifyLigatureBySharedPts_withFilter:
%   Identify ligatures formed by consecutive circles sharing one boundary
%   point. Disconnected circle-index groups are processed separately.

% Extract left and right boundary points.
numPoints_L = laneInfo.leftPoints.number;
leftPoints = lanePoints(1:numPoints_L,:);
numPoints_R = laneInfo.rightPoints.number;
rightPoints = lanePoints(numPoints_L+1:numPoints_L+numPoints_R,:);

% The fields of the circlesConnected matrix.
fld_coord_ptTgt_1 = 5:6;
fld_coord_ptTgt_2 = 8:9;
fld_coord_ptBase = 11:12;

% Initialise the ligature container.
lgtData = [];

% Identify ligatures associated with left boundary points.
for idxElem_L = 1:numPoints_L
    sharedPt = leftPoints(idxElem_L,2:3);

    idxsCirs_elemIsBasePoint = find(ismember( ...
        circlesConnected(:,fld_coord_ptBase),sharedPt,'rows'));
    idxsCirs_elemIsTgt_1_Point = find(ismember( ...
        circlesConnected(:,fld_coord_ptTgt_1),sharedPt,'rows'));
    idxsCirs_elemIsTgt_2_Point = find(ismember( ...
        circlesConnected(:,fld_coord_ptTgt_2),sharedPt,'rows'));

    idxCircles_elemIsPoint = [idxsCirs_elemIsBasePoint; ...
                              idxsCirs_elemIsTgt_1_Point; ...
                              idxsCirs_elemIsTgt_2_Point];

    % TODO: Form ligatures only from consecutive circle-index groups.
    lgtData = appendContinuousLigatures( ...
        lgtData,idxCircles_elemIsPoint,sharedPt);
end

% Identify ligatures associated with right boundary points.
for idxElem_R = 1:numPoints_R
    sharedPt = rightPoints(idxElem_R,2:3);

    idxsCirs_elemIsBasePoint = find(ismember( ...
        circlesConnected(:,fld_coord_ptBase),sharedPt,'rows'));
    idxsCirs_elemIsTgt_1_Point = find(ismember( ...
        circlesConnected(:,fld_coord_ptTgt_1),sharedPt,'rows'));
    idxsCirs_elemIsTgt_2_Point = find(ismember( ...
        circlesConnected(:,fld_coord_ptTgt_2),sharedPt,'rows'));

    idxCircles_elemIsPoint = [idxsCirs_elemIsBasePoint; ...
                              idxsCirs_elemIsTgt_1_Point; ...
                              idxsCirs_elemIsTgt_2_Point];

    % TODO: Form ligatures only from consecutive circle-index groups.
    lgtData = appendContinuousLigatures( ...
        lgtData,idxCircles_elemIsPoint,sharedPt);
end

% No ligature remains after filtering disconnected circle indices.
if isempty(lgtData)
    return
end

% Keep the original ordering and overlap-removal behaviour.
lgtData = sortrows(lgtData,1,'ascend');
rowLocn_currStrt = lgtData(2:end,1);
rowLocn_prevEnd = lgtData(1:end-1,2);
idxDifference = rowLocn_currStrt - rowLocn_prevEnd;
idxDifference = [1;idxDifference];
toExclude = idxDifference < 0;
lgtData(toExclude,:) = [];

end


function lgtData = appendContinuousLigatures( ...
    lgtData,circleIndices,sharedPt)
% Append every consecutive circle-index group containing at least two
% circles. A disconnected pair such as [1,77] creates no ligature.

circleIndices = unique(circleIndices(:),'sorted');
if numel(circleIndices) < 2
    return
end

idxBreak = [0;find(diff(circleIndices) > 1);numel(circleIndices)];
for idxGroup = 1:numel(idxBreak)-1
    idxFirst = idxBreak(idxGroup) + 1;
    idxLast = idxBreak(idxGroup+1);
    continuousIndices = circleIndices(idxFirst:idxLast);

    if numel(continuousIndices) < 2
        continue
    end

    rowLocn_lgt = [continuousIndices(1),continuousIndices(end)];
    lgtData = [lgtData;rowLocn_lgt,sharedPt]; %#ok<AGROW>
end

end
