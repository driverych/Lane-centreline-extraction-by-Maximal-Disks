% extractInscribedCircles_caseFive
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 5: The circle passes 2 points and is tangent to 1 segment, 1
%             point is the extreme point of the segment 
% 
% Syntax:  [circleInfo,cntrCircles] = extractInscribedCircles_caseFive...
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

function [circleInfo,cntrCircles] = extractInscribedCircles_caseFive...
            (segPair,segParam_Sta,touchingPoint_Tgt_1,passedPoint_Base,...
             isLeft_Base,lanePoints,circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)
% return         
% Log if the selected element is a point or not  
isPoint_Tgt_1 = 0;
isPoint_Tgt_2 = 0;
isPoint_Base = 1;

% The circle will be sorted according to the base point or the tgt_1
% segment info. If the touching point is the end point of the segment, it
% will be put at the last of the queue in the sorting
% So the index of the tgt_1 segment is stored.
idxSeg_Tgt_1 = touchingPoint_Tgt_1(1,3);
idxSeg_Tgt_2 = 0; % This segment is not involved 
idxPoint_Base = passedPoint_Base(1,3);

% The segment function of the target segment 1
segTgt_1_Sta = segParam_Sta(1,:);

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
% plot(x,y,'b--')
% scatter(passedPoint_Base(1,1),passedPoint_Base(1,2),20,"filled","b")
% scatter(touchingPoint_Tgt_1(1,1),touchingPoint_Tgt_1(1,2),20,"filled","r")

% Calculate the circle centre
[CC_5_cand,radius_5_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent1LineAndPassing2OffAndOnlinePoints...
    (segTgt_1_Sta,touchingPoint_Tgt_1(1,1:2),passedPoint_Base(1,1:2));

if isempty(CC_5_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_5_cand); 
    for idx_circle = 1:numCircle_cand
        % Judge if the radius exceeds a specific value
        if radius_5_cand(idx_circle) > 6 || isnan(radius_5_cand(idx_circle))
            continue
        end
        
        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_5_cand(idx_circle,:),radius_5_cand(idx_circle),lanePoints,...
             leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments...
            (CC_5_cand(idx_circle,:),radius_5_cand(idx_circle),lanePoints,...
             idxSeg_Tgt_1,idxSeg_Tgt_1,idxPoint_Base,isLeft_Base);
        end
        
        if Flag_interferingBorderSeg == 1
            continue
        end

        % Store circle information
        circleType = 50;
        circleInfo_temp = [CC_5_cand(idx_circle,1),CC_5_cand(idx_circle,2),radius_5_cand(idx_circle),...
                           idxSeg_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxSeg_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxPoint_Base,proj_CC2Base(idx_circle,1),proj_CC2Base(idx_circle,2),...
                           isLeft_Base,circleType,...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];
        cntrCircles = cntrCircles + 1;

        % * * * Plot the circle for test * * *
        % TODO
%         circleCenter(1,1) = CC_5_cand(idx_circle,1);
%         circleCenter(1,2) = CC_5_cand(idx_circle,2);
%         radius = radius_5_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#0c406d');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]);
    end
end


end