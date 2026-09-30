% extractInscribedCircles_caseThree_typeOne
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 3: The circle  is tangent to 1 segment and passes 2 extreme 
%             points. The segment and 1 point could be on the same side of
%             the lane, or the 2 point could be on the same side.
%     Type 3: The segment on the target border comes
%             earlier than the point on the targer
%             border. The second point is on the base
%             border
% 
% Syntax:  [circleInfo,cntrCircles] = extractInscribedCircles_caseThree_typeTwo...
%                (segPair,segParam_Sta,isLeftBase,lanePoints,circleInfo,cntrCircles)
%
% Input:
%    segPair - Rank in row: [projection seg 1; projection seg 2; base seg]
%    segParam_Sta - A matlab matrix storing parameters of segment's
%                   standform equation parameters
%    passedPoint - The passed point of segment by the circle
%    isBaseLeft - If the base segment is on the left border
%    lanePoints - Lane points of both left and right borders
%    circleInfo - A matlab struct to store circle information
%    cntrCircles - The number of circles
%
% Output:
%    circleInfo - A matlab struct to store circle information
%    cntrCircles - The number of circles
%
% Subfunctions: findInscribedCircle_tangent2LinesAndPassing1OfflinePoint
%               isBetween2Borders
%               isProjectionOnSegment
%               isCircleInterferringBorderSegments
%
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% cont -> continous
% lgth -> length
% num -> number
% idx -> index
% NN -> nearest neighbor
% CC -> circle centre
% R -> right
% L -> left

function [circleInfo,cntrCircles] = extractInscribedCircles_caseThree_typeThree...
                (segPair,segParam_Sta,passedPoint_Tgt_1,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)
% Log if the selected element is a point or not  
% return
isPoint_Tgt_1 = 1;
isPoint_Tgt_2 = 1;
isPoint_Base = 0;

% Parse the input
segBase = segPair(3,1:4); 
idxPoint_Tgt_1 = passedPoint_Tgt_1(1,3);
idxPoint_Tgt_2 = passedPoint_Tgt_2(1,3);
idxSeg_Base = segPair(3,5);

% The segment function
baseSeg_Sta = segParam_Sta(3,:);

% Check if the intersection point of segBase and constructed line
% (passedPoint_Tgt_1,passedPoint_Tgt_2) lies on the constructed line
% Find the intersection point by SI line equation
chordSeg_Sta = standardFormEquFrom2Points(passedPoint_Tgt_1,passedPoint_Tgt_2);
chordSeg_sI = standForm2sIForm(chordSeg_Sta);
segBase_sI = standForm2sIForm(baseSeg_Sta);
intxnPt_chordSegWithsegBase = intersectionFrom2Lines(chordSeg_sI,segBase_sI);
chordSeg = [passedPoint_Tgt_1(1,1:2),passedPoint_Tgt_2(1,1:2)];
% If the point is on the chord segment
isIntxnPtOnChordSeg = isPointOnSegment_byLength(intxnPt_chordSegWithsegBase,chordSeg);
if isIntxnPtOnChordSeg % if the intersection point is on the chord, no circles
    return
end

% Calculate the circle centre
subCase = 3;
[CC_3_cand,radius_3_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent1LineAndPassing2OfflinePoints(passedPoint_Tgt_1(1,1:2),passedPoint_Tgt_2(1,1:2),baseSeg_Sta,subCase);

if isempty(CC_3_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_3_cand); 
    for idx_circle = 1:numCircle_cand

        % Judge if the radius exceeds a specific value
        if radius_3_cand(idx_circle) > 6
            continue
        end
        
        % Check if the CC to target point distance is equal to circle raidus 
        % in length
        dist_CC2Pt = distancePoint2Point(CC_3_cand(idx_circle,:),passedPoint_Tgt_1(1,1:2));
        if abs(dist_CC2Pt - radius_3_cand(idx_circle)) > 0.01
            continue
        end
        
        % Identify whether the projection is on the base segment
        isProjOnBase = isProjectionOnSegment(CC_3_cand(idx_circle,1:2),segBase,baseSeg_Sta);
        if isProjOnBase == 0
            continue
        end

        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_3_cand(idx_circle,:),radius_3_cand(idx_circle),lanePoints,...
            leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments...
            (CC_3_cand(idx_circle,:),radius_3_cand(idx_circle),lanePoints,...
             idxPoint_Tgt_1,idxPoint_Tgt_2,idxSeg_Base,isLeft_Base);
        end
        
        if Flag_interferingBorderSeg == 1
            continue
        end 

        % Store the circles
        circleType = 33;
        circleInfo_temp = [CC_3_cand(idx_circle,1),CC_3_cand(idx_circle,2),radius_3_cand(idx_circle),...
                           idxPoint_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxPoint_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxSeg_Base,proj_CC2Base(idx_circle,1),proj_CC2Base(idx_circle,2),...
                           isLeft_Base,circleType...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];   
        cntrCircles = cntrCircles + 1;

        % * * * Plot the circle for test * * *
%         circleCenter(1,1) = CC_3_cand(idx_circle,1);
%         circleCenter(1,2) = CC_3_cand(idx_circle,2);
%         radius = radius_3_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#EDB120');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;        
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Tgt_2(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_2(idx_circle,2)]);   
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]); 
    end
end         


end