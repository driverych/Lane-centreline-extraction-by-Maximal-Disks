% extractInscribedCircles_caseSix
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 6: The circle is tangent to 2 segments and passes by one extreme 
%             point, which is on one of the segments
% 
% Syntax:  [circleInfo,cntrCircles] = extractInscribedCircles_caseSix...
%          (segPair,segParam_Sta,touchingPoint,isBaseLeft,lanePoints,circleInfo,cntrCircles)
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

function [circleInfo,cntrCircles] = extractInscribedCircles_caseSix...
    (segPair,segParam_Sta,touchingPoint_Tgt_1,isLeft_Base,lanePoints,...
     circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)

% return
% Log if the selected element is a point or not        
isPoint_Tgt_1 = 0;
isPoint_Tgt_2 = 0;
isPoint_Base = 0;

% In case 1,the base and target_1 segment are involved
segTgt_1 = segPair(1,1:4); 
segBase = segPair(3,1:4); 
idxSeg_Tgt_1 = touchingPoint_Tgt_1(1,3);
idxSeg_Tgt_2 = 0; % This segment is not involved
idxSeg_Base = segPair(3,5);

% The segment function
segTgt_1_Sta = segParam_Sta(1,:);
segBase_Sta = segParam_Sta(3,:);

% % * * * Plot the elements for test * * *
% figure;
% segTgt_1 = segPair(1,1:4); 
% x = [segTgt_1(1,1),segTgt_1(1,3)];
% y = [segTgt_1(1,2),segTgt_1(1,4)];
% plot(x,y,'r')
% hold on;
% segTgt_2 = segPair(2,1:4); 
% x = [segTgt_2(1,1),segTgt_2(1,3)];
% y = [segTgt_2(1,2),segTgt_2(1,4)];
% plot(x,y,'r--')
% segBase = segPair(3,1:4); 
% x = [segBase(1,1),segBase(1,3)];
% y = [segBase(1,2),segBase(1,4)];
% plot(x,y,'b')
% scatter(touchingPoint_Tgt_1(1,1),touchingPoint_Tgt_1(1,2),20,"filled","r")

% Calculate the circle centre
[CC_6_cand,radius_6_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent2LinesAndPassing1OnlinePoint...
    (segTgt_1_Sta,segBase_Sta,touchingPoint_Tgt_1(1,1:2),segPair,isLeft_Base);

if isempty(CC_6_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_6_cand); 
    for idx_circle = 1:numCircle_cand
        
        % Judge if the radius exceeds a specific value
        if radius_6_cand(idx_circle) > 6
            continue
        end

        % Check if the projection line segment is equal to circle raidus in
        % length
        % TODO: added for supplement the drawbacks of isProjOnBaseSeg: the
        % project point is not on the segment but the discirminate is true
        dist_Porj2Seg = distancePoint2Line(CC_6_cand(idx_circle,:),segBase_Sta);
        if abs(dist_Porj2Seg - radius_6_cand(idx_circle)) > 0.01
            continue
        end
        
        % Identify whether the projection is on the base segment
        isProjOnBaseSeg = isProjectionOnSegment(CC_6_cand(idx_circle,:),segBase,segBase_Sta);
        if isProjOnBaseSeg == 0
            continue
        end

%         % Identify if the circle centre is inbetween lane borders
%         is2SegsOpposite = 1;
%         isBetweenBorders = ...
%             isBetween2Borders(segTgt_1,segBase,CC_6_cand(idx_circle,:),isLeft_Base,is2SegsOpposite);
%         if isBetweenBorders == 0
%             continue
%         end
        

        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_6_cand(idx_circle,:),radius_6_cand(idx_circle),lanePoints,...
            leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments...
            (CC_6_cand(idx_circle,:),radius_6_cand(idx_circle),lanePoints,...
             idxSeg_Tgt_1,idxSeg_Tgt_1,idxSeg_Base,isLeft_Base);
        end

        if Flag_interferingBorderSeg == 1
            continue
        end 

        % Store circle information
        circleType = 60;
        circleInfo_temp = [CC_6_cand(idx_circle,1),CC_6_cand(idx_circle,2),radius_6_cand(idx_circle),...
                           idxSeg_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxSeg_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxSeg_Base,proj_CC2Base(idx_circle,1),proj_CC2Base(idx_circle,2),...
                           isLeft_Base,circleType...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];
        cntrCircles = cntrCircles + 1;

        % * * * Plot the circle for test * * *
        % TODO
%         circleCenter(1,1) = CC_6_cand(idx_circle,1);
%         circleCenter(1,2) = CC_6_cand(idx_circle,2);
%         radius = radius_6_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#0c406d');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]);
    end
end

end