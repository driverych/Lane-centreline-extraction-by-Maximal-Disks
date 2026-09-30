
% Compensate for the ligature

% For case 6, find the start point of the base segment, know the touching
% point on the tgt_1 segment
% Know the start and end circle centre of the ligature
% Extract the base elements of the two circles, if they are different, skip
% If the base segments are the same
% Extract the start point of the base segment, calculate the K1 and K2

% int -> interest
% lgt -> ligature


function circlesConnected_updated = compensateLigature(circlesConnected,rowLocns_lgt,distThold_skipLgt,lanePoints)

% If there is no ligature
if size(rowLocns_lgt,1) == 0
    circlesConnected_updated = circlesConnected;
    return
end

% Initialize the output
circlesConnected_updated = [];
rowPtr_circlesConnected_PrevLgtEnd = 1;

% The number of ligature
numLgts = size(rowLocns_lgt,1);

% The fields
fld.CC = 1:2;
fld.tgtSeg_1Idx = 4;
fld.ProjOnTgtSeg_1 = 5:6;
fld.tgtSeg_2Idx = 7;
fld.ProjOnTgtSeg_2 = 8:9;
fld.baseSegIdx = 10;
fld.ProjOnBaseSeg = 11:12;
fld.cirType = 14;

for idxLgt = 1:numLgts

    % The start and end row location of the ligature
    rowLocn_lgtS = rowLocns_lgt(idxLgt,1);
    rowLocn_lgtE = rowLocns_lgt(idxLgt,2);
    
    % Update the row location pointer
    rowPtr_circlesConnected_CurrLgtStrt = rowLocn_lgtS;
    
    % Store the points before the ligature (include the start point of the ligature)
    circlesConnected_updated = [circlesConnected_updated;circlesConnected(rowPtr_circlesConnected_PrevLgtEnd:rowPtr_circlesConnected_CurrLgtStrt,:)];
    
    % Extract the circle centres
    cirCoord_lgtS = circlesConnected(rowLocn_lgtS,fld.CC);
    cirCoord_lgtE = circlesConnected(rowLocn_lgtE,fld.CC);
    
    % The distance beween two circles
    distSE = distancePoint2Point(cirCoord_lgtS,cirCoord_lgtE);
    
    % Skip if the distance is below a threshold: for efficiency
    if distSE < distThold_skipLgt
        % Update the row location pointer in circlesConnected
        rowPtr_circlesConnected_PrevLgtEnd = rowLocn_lgtE;
        continue
    end
    
    % --------------------------- plot for test ---------------------------
    % Plot the start and end points of the ligature
%     x_start = cirCoord_lgtS(1,1);
%     y_start = cirCoord_lgtS(1,2);
%     u = cirCoord_lgtE(1,1) - x_start;
%     v = cirCoord_lgtE(1,2) - y_start;
%     quiver(x_start,y_start,u,v);
    
    % The number of segments in-between start and end ligature points
    % The ligature is identified by Circle Type 60. There might be some
    % other types of circle, like Circle Type 21, trying to compensate the
    % ligature
    numClSegs = rowLocn_lgtE - rowLocn_lgtS;
    
    % Extract all in-between circles
    for idxClSeg = 1:numClSegs
        
        % The row location of target cirlces in the selected centreline
        % segments: start and end circles
        rowLocn_tgtClSegSpt = rowLocn_lgtS + idxClSeg - 1;
        rowLocn_tgtClSegEpt = rowLocn_lgtS + idxClSeg;
        % The start and end point of the chosen centreline segment
        CC_tgtCirS = circlesConnected(rowLocn_tgtClSegSpt,fld.CC);
        CC_tgtCirE = circlesConnected(rowLocn_tgtClSegEpt,fld.CC);
        % The circle type
        cirType_tgtClSegSpt = circlesConnected(rowLocn_tgtClSegSpt,fld.cirType);
        cirType_tgtClSegEpt = circlesConnected(rowLocn_tgtClSegEpt,fld.cirType);
                
        % Cases need to be treated differently
        if cirType_tgtClSegSpt == 60 && cirType_tgtClSegEpt == 21
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case60and21(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 60 && cirType_tgtClSegEpt == 60
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case60and60(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 21 && cirType_tgtClSegEpt == 60
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case21and60(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 21 && cirType_tgtClSegEpt == 50
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case21and50(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 31 && cirType_tgtClSegEpt == 60
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case31and60(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 21 && cirType_tgtClSegEpt == 21
            % compensate the ligature between case 21 and 21
            circlesConnected_updated = compensateLigature_case21and21(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 60 && cirType_tgtClSegEpt == 50
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case60and50(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 50 && cirType_tgtClSegEpt == 60
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case50and60(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
        if cirType_tgtClSegSpt == 60 && cirType_tgtClSegEpt == 22
            % compensate the ligature between case 60 and 21
            circlesConnected_updated = compensateLigature_case60and22(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
        end
        
%         if cirType_tgtClSegSpt == 50 && cirType_tgtClSegEpt == 31
%             % compensate the ligature between case 60 and 21
%             circlesConnected_updated = compensateLigature_case50and31(circlesConnected_updated,circlesConnected,rowLocn_tgtClSegSpt,rowLocn_tgtClSegEpt,fld,rowLocns_lgt,lanePoints,idxLgt);
%         end

        % Update the row location pointer in circlesConnected
        rowPtr_circlesConnected_PrevLgtEnd = rowLocn_lgtE;
        
    end
    

end % for idxLgt = 1:numLgts

% The row location behind last ligature
rowPtr_circlesConnected_LastLgtEnd = rowLocns_lgt(end,2);
rowPtr_circlesConnected_lastPt = size(circlesConnected,1);
circlesConnected_updated = [circlesConnected_updated;circlesConnected(rowPtr_circlesConnected_LastLgtEnd:rowPtr_circlesConnected_lastPt,:)];


end