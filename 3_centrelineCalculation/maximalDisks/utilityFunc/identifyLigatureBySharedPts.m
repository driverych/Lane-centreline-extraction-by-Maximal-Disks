


function lgtData = identifyLigatureBySharedPts(circlesConnected,laneInfo,lanePoints)

% Extract left points and segments
numPoints_L = laneInfo.leftPoints.number;
leftPoints = lanePoints(1:numPoints_L,:);
numPoints_R = laneInfo.rightPoints.number;
rightPoints = lanePoints(numPoints_L+1:numPoints_L+numPoints_R,:);

% The fields of the circlesConnected matrix
fld_coord_ptTgt_1 = 5:6;
fld_coord_ptTgt_2 = 8:9;
fld_coord_ptBase = 11:12;

% Initialise
lgtData = [];

% Build the base segment according to its start point
% An example of relations between point index and segment index
%        P_1      P_2      P_3
%         *--------*--------*--------> border(forward direction)
%            -S1-     -S2-     -S3-


for idxElem_L = 1:numPoints_L
    
    % The shared point by circles
    sharedPt = leftPoints(idxElem_L,2:3);
    
    % Select the circles with the selected point as the base point
    idxsCirs_elemIsBasePoint = find(ismember(circlesConnected(:,fld_coord_ptBase), sharedPt, 'rows'));
    cirs_elemIsBasePoint = circlesConnected(idxsCirs_elemIsBasePoint,:);
    % Select the circles with the selected point as the tgt_1 point
    idxsCirs_elemIsTgt_1_Point = find(ismember(circlesConnected(:,fld_coord_ptTgt_1), sharedPt, 'rows'));
    cirs_elemIsTgt_1_Point = circlesConnected(idxsCirs_elemIsTgt_1_Point,:);
    % Select the circles with the selected point as the tgt_2 point
    idxsCirs_elemIsTgt_2_Point = find(ismember(circlesConnected(:,fld_coord_ptTgt_2), sharedPt, 'rows'));
    cirs_elemIsTgt_2_Point = circlesConnected(idxsCirs_elemIsTgt_2_Point,:);
    
    % Assemble the circles according to the point and segment seperately
    circles_elemIsPoint = [cirs_elemIsBasePoint;cirs_elemIsTgt_1_Point;cirs_elemIsTgt_2_Point]; 
    idxCircles_elemIsPoint = [idxsCirs_elemIsBasePoint;...
                              idxsCirs_elemIsTgt_1_Point;...
                              idxsCirs_elemIsTgt_2_Point]; 
    % The number of circles
    numCirs_elemIsPoint = size(circles_elemIsPoint,1);
    % A ligature needs at least two circles
    if numCirs_elemIsPoint > 1
        % Store the ligature information
        rowLocn_lgt = [min(idxCircles_elemIsPoint),max(idxCircles_elemIsPoint)];
        lgtData = [lgtData;[rowLocn_lgt,sharedPt]];
    end
    
end

for idxElem_R = 1:numPoints_R
    
    % The shared point by circles
    sharedPt = rightPoints(idxElem_R,2:3);
    
    % Select the circles with the selected point as the base point
    idxsCirs_elemIsBasePoint = find(ismember(circlesConnected(:,fld_coord_ptBase), sharedPt, 'rows'));
    cirs_elemIsBasePoint = circlesConnected(idxsCirs_elemIsBasePoint,:);
    % Select the circles with the selected point as the tgt_1 point
    idxsCirs_elemIsTgt_1_Point = find(ismember(circlesConnected(:,fld_coord_ptTgt_1), sharedPt, 'rows'));
    cirs_elemIsTgt_1_Point = circlesConnected(idxsCirs_elemIsTgt_1_Point,:);
    % Select the circles with the selected point as the tgt_2 point
    idxsCirs_elemIsTgt_2_Point = find(ismember(circlesConnected(:,fld_coord_ptTgt_2), sharedPt, 'rows'));
    cirs_elemIsTgt_2_Point = circlesConnected(idxsCirs_elemIsTgt_2_Point,:);
    
    % Assemble the circles according to the point and segment seperately
    circles_elemIsPoint = [cirs_elemIsBasePoint;cirs_elemIsTgt_1_Point;cirs_elemIsTgt_2_Point]; 
    idxCircles_elemIsPoint = [idxsCirs_elemIsBasePoint;...
                              idxsCirs_elemIsTgt_1_Point;...
                              idxsCirs_elemIsTgt_2_Point]; 
    % The number of circles
    numCirs_elemIsPoint = size(circles_elemIsPoint,1);
    % A ligature needs at least two circles
    if numCirs_elemIsPoint > 1
        % Store the ligature information
        rowLocn_lgt = [min(idxCircles_elemIsPoint),max(idxCircles_elemIsPoint)];
        lgtData = [lgtData;[rowLocn_lgt,sharedPt]];
    end
    
end
    % Sort the row location of the ligature
    lgtData = sortrows(lgtData,1,'ascend');
    
    % Extract the first column
    rowLocn_currStrt = lgtData(2:end,1);
    rowLocn_prevEnd = lgtData(1:end-1,2);
    
    % Difference
    diff = rowLocn_currStrt - rowLocn_prevEnd;
    diff = [1;diff]; % keep the first ligature anyway
    
    % The start point of the current ligature should be bigger than the end
    % point of the previous ligature
    toExclude = diff<0;
    
    % Update the ligature
    lgtData(toExclude,:) = [];

end