% extractInscribedCircles_caseTwo_typeOne
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 2: The circle is tangent to 2 segments and passes by one extreme 
%             point, which is not on neither of the 2 segments. The 2
%             segments could be on the same side of the lane, or 1 segment
%             and the point could be on the same side.
%     Type 1: two segments are both on the target border and
%             the point is on the base border
% 
% Syntax:  [circleInfo,cntrCircles] = findInscribedCircles_caseTwo...
%                (segPair,segParam_Sta,passedPoint,isLeftBase,lanePoints,circleInfo,cntrCircles)
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

function [circleInfo,cntrCircles] = extractInscribedCircles_caseTwo_typeTwo...
                (segPair,segParam_Sta,passedPoint_Tgt_1,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)

% return % issue here             
% Log if the selected element is a point or not        
isPoint_Tgt_1 = 1;
isPoint_Tgt_2 = 0;
isPoint_Base = 0;

% One base point and two targer segments will be involved
segTgt_1 = segPair(1,1:4); 
segTgt_2 = segPair(2,1:4); 
segBase = segPair(3,1:4);
idxPoint_Tgt_1 = passedPoint_Tgt_1(1,3);
idxSeg_Tgt_2 = segPair(2,5);
idxSeg_Base = segPair(3,5);

% The segment function
segTgt_1_Sta = segParam_Sta(1,:); 
segTgt_2_Sta = segParam_Sta(2,:);
segBase_Sta = segParam_Sta(3,:);

% If the passedPoint_Tgt_1 is on the extension of the segTgt_2 and segBase
isPtOnSegTgtExt_2 = isPointOnSegmentExtension_byLength(passedPoint_Tgt_1,segTgt_2);
isPtOnSegBaseExt = isPointOnSegmentExtension_byLength(passedPoint_Tgt_1,segBase);
if isPtOnSegTgtExt_2 || isPtOnSegBaseExt
    return
end

% * * * Plot the elements for test * * *
% figure;
% x = [segTgt_1(1,1),segTgt_1(1,3)];
% y = [segTgt_1(1,2),segTgt_1(1,4)];
% plot(x,y,'r--')
% hold on;
% segTgt_2 = segPair(2,1:4); 
% x = [segTgt_2(1,1),segTgt_2(1,3)];
% y = [segTgt_2(1,2),segTgt_2(1,4)];
% plot(x,y,'r')
% segBase = segPair(3,1:4); 
% x = [segBase(1,1),segBase(1,3)];
% y = [segBase(1,2),segBase(1,4)];
% plot(x,y,'b')
% scatter(passedPoint_Tgt_1(1,1),passedPoint_Tgt_1(1,2),20,"filled","r")

% Calculate the circle centre
subClass = 2;
[CC_2_cand,radius_2_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent2LinesAndPassing1OfflinePoint(passedPoint_Tgt_1(1,1:2),segTgt_2_Sta,segBase_Sta,subClass);    

% If no circles are found in Case 2, skip
if isempty(CC_2_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_2_cand); 
    for idx_circle = 1:numCircle_cand
        
        % Judge if the radius exceeds a specific value
        if radius_2_cand(idx_circle) > 6
            continue
        end
        
%         % Identify if the circle centre is inbetween lane borders
%         is2SegsOpposite = 0;
%         isBetweenBorders = ...
%             isBetween2Borders(segTgt_1,segTgt_2,CC_2_cand(idx_circle,:),isLeftBase,is2SegsOpposite);
%         if isBetweenBorders == 0
%             continue
%         end
%         
        % Identify whether the projection is on the target_2 segment
        isProjOnTgt_2 = isProjectionOnSegment(CC_2_cand(idx_circle,:),segTgt_2,segTgt_2_Sta);
        if isProjOnTgt_2 == 0
            continue
        end

        % Identify whether the projection is on the base segment
        isProjOnBase = isProjectionOnSegment(CC_2_cand(idx_circle,:),segBase,segBase_Sta);
        if isProjOnBase == 0
            continue
        end        
        
        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_2_cand(idx_circle,:),radius_2_cand(idx_circle),lanePoints,...
            leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments...
            (CC_2_cand(idx_circle,:),radius_2_cand(idx_circle),lanePoints,...
             idxPoint_Tgt_1,idxSeg_Tgt_2,idxSeg_Base,isLeft_Base);
        end
        
        if Flag_interferingBorderSeg == 1
            continue
        end 
        
        
        % No projection on base segment is needed, instead the on-segment
        % point is stored
        circleType = 22;
        circleInfo_temp = [CC_2_cand(idx_circle,1),CC_2_cand(idx_circle,2),radius_2_cand(idx_circle),...
                           idxPoint_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxSeg_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxSeg_Base,proj_CC2Base(idx_circle,1),proj_CC2Base(idx_circle,2),...
                           isLeft_Base,circleType...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];   
        cntrCircles = cntrCircles + 1;
        
        % * * * Plot the circle for test * * *
%         circleCenter(1,1) = CC_2_cand(idx_circle,1);
%         circleCenter(1,2) = CC_2_cand(idx_circle,2);
%         radius = radius_2_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#0c406d');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Tgt_2(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_2(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]); 
%         % plotSingleCircle(passedPoint,8,'#000000','#D95319');

        
    end               
end              



end