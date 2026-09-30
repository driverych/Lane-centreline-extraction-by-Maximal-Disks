% extractInscribedCircles_caseOne
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 1: The circle is tangent to 3 segments,2 of which are on the
%             same lane boder.
% 
% Syntax:  [circleInfo,cntrCircles] = extractInscribedCircles_caseOne...
%                (segPair,segParam_Sta,isLeftBase,lanePoints,circleInfo,cntrCircles)
%
% Input:
%    segPair - Rank in row: [projection seg 1; projection seg 2; base seg]
%    segParam_Sta - A matlab matrix storing parameters of segment's
%                   standform equation parameters
%    touchingPoint - The touching point of the circle and the segment
%    isBaseLeft - If the base segment is on the left border
%    lanePoints - Lane points of both left and right borders
%    circleInfo - A matlab struct to store circle information
%    cntrCircles - The number of circles
%
% Output:
%    circleInfo - A matlab struct to store circle information
%    cntrCircles - The number of circles
%
% Subfunctions: findInscribedCircle_tangent2LinesAndPassing1OnlinePoint
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

function [circleInfo,cntrCircles] = extractInscribedCircles_caseOne...
                (segPair,segParam_Sta,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)
% return
% Log if the selected element is a point or not        
isPoint_Tgt_1 = 0;
isPoint_Tgt_2 = 0;
isPoint_Base = 0;

% In case 3,the base,target_1 and target_2 segment are involved
segTgt_1 = segPair(1,1:4); 
segTgt_2 = segPair(2,1:4); 
segBase = segPair(3,1:4); 
idxSeg_Tgt_1 = segPair(1,5);
idxSeg_Tgt_2 = segPair(2,5);
idxSeg_Base = segPair(3,5);

% A bug has been found that there are some cases where the start and end
% points of the segment are the same
if sum(segTgt_1(1,1:2) - segTgt_1(1,3:4)) == 0 || sum(segTgt_2(1,1:2) - segTgt_2(1,3:4)) == 0 || sum(segBase(1,1:2) - segBase(1,3:4)) == 0 
    return
end
 
% The segment function
segTgt_1_Sta = segParam_Sta(1,:);
segTgt_2_Sta = segParam_Sta(2,:);
segBase_Sta = segParam_Sta(3,:);

% % * * * Plot the elements for test * * *
% figure;
% x = [segTgt_1(1,1),segTgt_1(1,3)];
% y = [segTgt_1(1,2),segTgt_1(1,4)];
% plot(x,y,'r-')
% hold on;
% plot(segTgt_1(1,1),segTgt_1(1,2),'k*')
% plot(segTgt_1(1,3),segTgt_1(1,4),'m*')
% 
% x = [segTgt_2(1,1),segTgt_2(1,3)];
% y = [segTgt_2(1,2),segTgt_2(1,4)];
% plot(x,y,'r-')
% plot(segTgt_2(1,1),segTgt_2(1,2),'ko')
% plot(segTgt_2(1,3),segTgt_2(1,4),'mo')
% 
% x = [segBase(1,1),segBase(1,3)];
% y = [segBase(1,2),segBase(1,4)];
% plot(x,y,'b--*')
% 
% disp(segTgt_1)
% disp(segTgt_2)
% disp(segBase)

% Calculate the circle centre
[CC_1_cand,radius_1_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent3Lines(segTgt_1_Sta,segTgt_2_Sta,segBase_Sta);

% A demo data for test of sharp corners
% segTgt_1_Sta = standardFormEquFrom2Points([-4.46654,0.277592],[-2.05609,3.15026]);
% segTgt_2_Sta = standardFormEquFrom2Points([0.688132,5.29365],[3.78544,0.870233]);
% segBase_Sta = standardFormEquFrom2Points([-2.05692,-2.45134],[2.9826,-4.25959]);
% segTgt_1 = [-4.46654,0.277592,-2.05609,3.15026];
% segTgt_2 = [0.688132,5.29365,3.78544,0.870233];
% segBase = [-2.05692,-2.45134,2.9826,-4.25959];
% [CC_1_cand,radius_1_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
%     findInscribedCircle_tangent3Lines(segTgt_1_Sta,segTgt_2_Sta,segBase_Sta);
% 
% for idx_circle = 1:size(CC_1_cand,1)
%     isProjOnTgt_1 = isPointOnSegment_byLength(proj_CC2Tgt_1(idx_circle,1:2),segTgt_1);
%     isProjOnTgt_2 = isPointOnSegment_byLength(proj_CC2Tgt_2(idx_circle,1:2),segTgt_2);
%     isProjOnBase = isPointOnSegment_byLength(proj_CC2Base(idx_circle,:),segBase);
%     plotSingleCircle(CC_1_cand(idx_circle,1:2),radius_1_cand(idx_circle,1),'#000000','k');
% end
% % for lane 34

if isempty(CC_1_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_1_cand); 
    for idx_circle = 1:numCircle_cand
        
        % Judge if the radius exceeds a specific value
        if radius_1_cand(idx_circle) > 6
            continue
        end

        % Identify whether the projection is on the target segment
%         isProjOnTgt_1 = isProjectionOnSegment(CC_1_cand(idx_circle,1:2),segTgt_1,segTgt_1_Sta);
%         isProjOnTgt_1 = isPointOnSegmentOrItsBackwardExtension_byLength(proj_CC2Tgt_1(idx_circle,1:2),segTgt_1);
        isProjOnTgt_1 = isPointOnSegment_byLength(proj_CC2Tgt_1(idx_circle,1:2),segTgt_1);
        if isProjOnTgt_1 == 0 
            continue
        end        
        
%         isProjOnTgt_2 = isProjectionOnSegment(CC_1_cand(idx_circle,1:2),segTgt_2,segTgt_2_Sta);
%         isProjOnTgt_2 = isPointOnSegmentOrItsForwardExtension_byLength(proj_CC2Tgt_2(idx_circle,1:2),segTgt_2);
        isProjOnTgt_2 = isPointOnSegment_byLength(proj_CC2Tgt_2(idx_circle,1:2),segTgt_2);
        if isProjOnTgt_2 == 0 
            continue
        end
        
%         isProjOnBase = isProjectionOnSegment(CC_1_cand(idx_circle,1:2),segBase,segBase_Sta);
        isProjOnBase = isPointOnSegment_byLength(proj_CC2Base(idx_circle,:),segBase);
        if isProjOnBase == 0
            continue
        end

        
        % Identify if the circle centre is inbetween lane borders
%         is2SegsOpposite = 1;
%         isBetweenBorders = ...
%             isBetween2Borders(segBase,segTgt_1,CC_1_cand(idx_circle,:),isLeft_Base,is2SegsOpposite);
%         if isBetweenBorders == 0
%             continue
%         end
        
        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_1_cand(idx_circle,:),radius_1_cand(idx_circle),lanePoints,...
            leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = isCircleInterferringNearbyBorderSegments...
                (CC_1_cand(idx_circle,:),radius_1_cand(idx_circle),lanePoints,...
                 idxSeg_Tgt_1,idxSeg_Tgt_2,idxSeg_Base,isLeft_Base);
        end
        
        if Flag_interferingBorderSeg == 1
            continue
        end        
        
        % Store circle info
        circleType = 10;
        circleInfo_temp = [CC_1_cand(idx_circle,1),CC_1_cand(idx_circle,2),radius_1_cand(idx_circle),...
                           idxSeg_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxSeg_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxSeg_Base,proj_CC2Base(idx_circle,1),proj_CC2Base(idx_circle,2),...
                           isLeft_Base,circleType...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];   
        cntrCircles = cntrCircles + 1;
        
        % * * * Plot the circle for test * * *
        % TODO:
%         circleCenter(1,1) = CC_1_cand(idx_circle,1);
%         circleCenter(1,2) = CC_1_cand(idx_circle,2);
%         radius = radius_1_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#0c406d');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Tgt_2(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_2(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]); 
        
        
    end
end 

end