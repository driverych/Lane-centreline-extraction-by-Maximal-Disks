% exploreMaximalDisksThroughPointPairs_allCases
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%   - The cases could be devided into 6 cases.
%     Case 1: The circle is tangent to 3 segments,2 of which are on the
%             same lane boder.
%     Case 2: The circle is tangent to 2 segments and passes by one extreme 
%             point, which is not on neither of the 2 segments. The 2
%             segments could be on the same side of the lane, or 1 segment
%             and the point could be on the same side.
%     Case 3: The circle  is tangent to 1 segment and passes 2 extreme 
%             points. The segment and 1 point could be on the same side of
%             the lane, or the 2 point could be on the same side.
%     Case 4: The circle passes 3 extreme points, two of which are on the
%             same lane boder.
%     Case 5: The circle passes 2 points and is tangent to 1 segment, 1
%             point is the extreme point of the segment 
%     Case 6: The circle is tangent to 2 segments and passes by one extreme 
%             point, which is on one of the segments
%
% Main steps:
%  - Specify the base and target borders
%  - Select one base point and build base segment forward
%  - Set the base point as the passed point
%  - Match the target point with the start point of the base segment
%  - Match the target point with the end point of the base segment
%  - Calculate the MDs while the base element is a point
%  - Calculate the MDs while the base element is a segment
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


% If the point could reach the end
% If the segemtn will be duplicated
% A target segment could be built even though the point reach the end,
% because the segment is built backward

function [circleInfo,cntrCircles] = exploreMaximalDisksThroughPointPairs_sixCases...
            (pointPairs_CConL,pointPairs_CConR,flds,...
             lanePoints,laneInfo,isLeft_Base,...
             circleInfo,cntrCircles,...
             leftTree,rightTree,params,intxnCheckByKNN)
         
% Extract the point numbers in the left and right borders
numPoints_L = laneInfo.leftPoints.number;
numPoints_R = laneInfo.rightPoints.number;

%--------------------------------------------------------------------------
%---------          specify the base and target borders          ----------
%--------------------------------------------------------------------------
% Link the left/right border data to base/target data
if isLeft_Base == 1
    % The field of the point pairs data
    fld_idxs_BasePoint = flds.pointPair.idx_L; 
    fld_idxs_TgtPoint = flds.pointPair.idx_R;
    numPoints_base = numPoints_L;
    isLeft_Tgt = 0;
    % Extract the indexes of the base points in point pair matrix
    idxs_allBasePoints_inPP = pointPairs_CConL(:,fld_idxs_BasePoint);
else
    % The field of the point pairs data
    fld_idxs_BasePoint = flds.pointPair.idx_R; 
    fld_idxs_TgtPoint = flds.pointPair.idx_L;
    numPoints_base = numPoints_R;
    isLeft_Tgt = 1;
    % Extract the indexes of the base points in point pair matrix
    idxs_allBasePoints_inPP = pointPairs_CConR(:,fld_idxs_BasePoint);
end

% Three elements (points or segments) will be involved in the calculation
% A temporary matrix to store the coordinates of the start and end points,
% as well as the segment index: [x_start,y_start,x_end,y_end,segIdx]
% If a segment is not involved in a calculation, it will be filled with
% zeros.
% Rank in row: [target seg 1, target seg 2, base seg]
segPair = zeros(3,5);

% A temporary matrix to store the line parameters in the standard form.
% Rank in row: [target seg 1, target seg 2, base seg]
% target seg 2 is farther to the border start point than the target seg 1
segParam_Sta = zeros(3,3);

% Select only one element in the base border and select two elements 
% in the target border (elements could be points or segments)

% The cntr is always positive while the idx is positive in the left while
% negative in the right
for cntrPoint_base = 1:numPoints_base 

    %----------------------------------------------------------------------
    %---------          build the base segment forward          -----------
    %----------------------------------------------------------------------
    % Build the base segment according to its start point
    % An example of relations between point index and segment index
    %        P_1      P_2      P_3
    %         *--------*--------*--------> border(forward direction)
    %            -S1-     -S2-     -S3-
    % Backward: the reverse direction of the lane
    % Forward: the direction of the lane
    if cntrPoint_base < numPoints_base
        % Build the segment forwards
        [segBase,segBase_Sta] = ...
            buildSegmentWithPointIndex_forward(isLeft_Base,cntrPoint_base,lanePoints);
    else % Reach the last point, build the segment backwards
        [segBase,segBase_Sta] = ...
            buildSegmentWithPointIndex_backward(isLeft_Base,cntrPoint_base,lanePoints);
    end
    segPair(3,:) = segBase; segParam_Sta(3,:) = segBase_Sta; 
    % * * * Plot the segment for test * * *
%     plot([segBase(1,1);segBase(1,3)],[segBase(1,2);segBase(1,4)],'k');   

    %----------------------------------------------------------------------
    %-------         set the base point as the passed point        --------
    %----------------------------------------------------------------------
    % All base points will be reached
    if isLeft_Base == 1
        passedPoint_Base = ...
            [lanePoints((lanePoints(:,1) == cntrPoint_base),2:3),cntrPoint_base];
    else
        passedPoint_Base = ...
            [lanePoints((lanePoints(:,1) == -cntrPoint_base),2:3),-cntrPoint_base];
    end
    % * * * Plot the point for test * * *
%     plot(passedPoint_Base(1),passedPoint_Base(2),'g*');
%     hold on; axis equal;

    %----------------------------------------------------------------------
    %-------                   match target points                 --------
    %----------------------------------------------------------------------
    % Extract point pairs with point index equal to idxPoint_Base. 
    % This will show all matches between the invariable base point and the 
    % variable target points, which means the base points are the same 
    % while the target are not.
    % point pair: [idx_L,idx_R,x_L,y_L,x_R,y_R]
    
    % Match the start point of the base segment
    if isLeft_Base == 1
        idxPoint_baseSegSP = cntrPoint_base;
        idxsRow_baseSegSP_inPP = (idxs_allBasePoints_inPP == idxPoint_baseSegSP);
        % Extract the point-point pairs
        pointPairs_baseSegSP2Tgt = pointPairs_CConL(idxsRow_baseSegSP_inPP,:);
    else
        idxPoint_baseSegSP = -cntrPoint_base;
        idxsRow_baseSegSP_inPP = (idxs_allBasePoints_inPP == idxPoint_baseSegSP); 
        % Extract the point-point pairs
        pointPairs_baseSegSP2Tgt = pointPairs_CConR(idxsRow_baseSegSP_inPP,:);
    end

    % Match the end point of the base segment
    % This info will only be used when the base element is a segment
    if isLeft_Base == 1
        if cntrPoint_base < numPoints_base
            idxPoint_baseSegEP = cntrPoint_base + 1;
        else
            % In the case of reaching the last border point
            idxPoint_baseSegEP = cntrPoint_base;
        end
        idxsPoint_baseE_inPP = (idxs_allBasePoints_inPP == idxPoint_baseSegEP);
        % Extract the point-point pairs
        pointPairs_BaseSegEP2Tgt = pointPairs_CConL(idxsPoint_baseE_inPP,:);
    else
        if cntrPoint_base < numPoints_base
            idxPoint_baseSegEP = -(cntrPoint_base + 1);
        else
            idxPoint_baseSegEP = -cntrPoint_base;
        end
        idxsPoint_baseE_inPP = (idxs_allBasePoints_inPP == idxPoint_baseSegEP);
        % Extract the point-point pairs
        pointPairs_BaseSegEP2Tgt = pointPairs_CConR(idxsPoint_baseE_inPP,:);
    end

    %----------------------------------------------------------------------
    %------------        The base element is a point          -------------
    %----------------------------------------------------------------------
    % Calculate how many clusters in the pointPairs_baseSegSP2Tgt
    [locsDisc,numClusters] = countClustersByIndexContinuity(pointPairs_baseSegSP2Tgt,fld_idxs_TgtPoint);
    
    % Do circle extraction
    if numClusters == 1
        % Find the maximal disks while the base element is a point
        [circleInfo,cntrCircles] = exploreMaximalDisksWithABasePoint...
            (isLeft_Base,isLeft_Tgt,lanePoints,...
             pointPairs_baseSegSP2Tgt,fld_idxs_TgtPoint,...
             passedPoint_Base,segPair,segParam_Sta,...
             circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
    else
        % Initiate the start position
        loc_start = 1;
        for idxCluster = 1:numClusters
            loc_end = locsDisc(idxCluster,1);
            pointPairs_baseSegSP2Tgt_inLoop = pointPairs_baseSegSP2Tgt(loc_start:loc_end,:);
            loc_start = loc_end + 1;
            % Find the maximal disks while the base element is a point
            [circleInfo,cntrCircles] = exploreMaximalDisksWithABasePoint...
                (isLeft_Base,isLeft_Tgt,lanePoints,...
                 pointPairs_baseSegSP2Tgt_inLoop,fld_idxs_TgtPoint,...
                 passedPoint_Base,segPair,segParam_Sta,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
        end % for idxCluster = 1:numClusters
    end % if numClusters == 1
    
    %----------------------------------------------------------------------
    %------------       The base element is a segment         -------------
    %----------------------------------------------------------------------
    % Combine all point pairs (start and end points of the base segment)
    idxsPoint_BaseS2Tgt_inPP = pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint);
    idxsPoint_BaseE2Tgt_inPP = pointPairs_BaseSegEP2Tgt(:,fld_idxs_TgtPoint);
    idxsPoint_Base2Tgt_inPP = unique([idxsPoint_BaseS2Tgt_inPP;idxsPoint_BaseE2Tgt_inPP]);
    
    % Calculate how many clusters in the pointPairs_baseSegSP2Tgt
    [locsDisc,numClusters] = countClustersByIndexContinuity(idxsPoint_Base2Tgt_inPP,1);
    
    % Do circle extraction
    if numClusters == 1
        % Find the maximal disks while the base element is a segment
        [circleInfo,cntrCircles] = exploreMaximalDisksWithABaseSegment...
            (isLeft_Base,isLeft_Tgt,lanePoints,...
             idxsPoint_Base2Tgt_inPP,...
             cntrPoint_base,numPoints_base,segPair,segParam_Sta,...
             circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);    
    else
        % Initiate the start position
        loc_start = 1;
        for idxCluster = 1:numClusters
            loc_end = locsDisc(idxCluster,1);
            idxsPoint_Base2Tgt_inPP_inLoop = idxsPoint_Base2Tgt_inPP(loc_start:loc_end,:);
            loc_start = loc_end + 1;
            % Find the maximal disks while the base element is a segment
            [circleInfo,cntrCircles] = exploreMaximalDisksWithABaseSegment...
                (isLeft_Base,isLeft_Tgt,lanePoints,...
                 idxsPoint_Base2Tgt_inPP_inLoop,...
                 cntrPoint_base,numPoints_base,segPair,segParam_Sta,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN); 
        end % for idxCluster = 1:numClusters
    end % if numClusters == 1
end % for cntrPoint_base = 1:numPoints_base

end