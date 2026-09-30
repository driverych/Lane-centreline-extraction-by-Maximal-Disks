% extracteInscribedCircles_caseFour
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%     Case 4: The circle passes 3 extreme points, two of which are on the
%             same lane boder.
% 
% Syntax:  [circleInfo,cntrCircles] = extracteInscribedCircles_caseFour...
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

function [circleInfo,cntrCircles] = extracteInscribedCircles_caseFour...
                (segPair,passedPoint_Base,passedPoint_Tgt_1,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)
% return
% Log if the selected element is a point or not        
isPoint_Tgt_1 = 1;
isPoint_Tgt_2 = 1;
isPoint_Base = 1;

% In case 4,the base,target_1 and target_2 segment are involved
idxPoint_Tgt_1 = passedPoint_Tgt_1(1,3);
idxPoint_Tgt_2 = passedPoint_Tgt_2(1,3);
idxPoint_Base = passedPoint_Base(1,3);

% Calculate the circle centres
[CC_4_cand,radius_4_cand,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_passing3Points(passedPoint_Tgt_1(1,1:2),passedPoint_Tgt_2(1,1:2),passedPoint_Base(1,1:2));

% If no circles are found in Case 4, skip
if isempty(CC_4_cand) == 0
    % Store circle information
    numCircle_cand = numel(radius_4_cand); 
    for idx_circle = 1:numCircle_cand
        
        % Judge if the radius exceeds a specific value
        if radius_4_cand(idx_circle) > 8 || radius_4_cand(idx_circle) == Inf || isnan(radius_4_cand(idx_circle))
            continue
        end
        
        % Identify if the circle interfers with border segments
        if intxnCheckByKNN == 1
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments_knnSearch...
            (CC_4_cand(idx_circle,:),radius_4_cand(idx_circle),lanePoints,...
            leftTree,rightTree,params);
        else
            Flag_interferingBorderSeg = ...
            isCircleInterferringNearbyBorderSegments...
            (CC_4_cand(idx_circle,:),radius_4_cand(idx_circle),lanePoints,...
             idxPoint_Tgt_1,idxPoint_Tgt_2,idxPoint_Base,isLeft_Base);
        end

        if Flag_interferingBorderSeg == 1
            continue
        end
        
        % No projection is calculated, instead on-segment points are stored
        circleType = 40;
        circleInfo_temp = [CC_4_cand(idx_circle,1),CC_4_cand(idx_circle,2),radius_4_cand(idx_circle),...
                           idxPoint_Tgt_1,proj_CC2Tgt_1(idx_circle,1),proj_CC2Tgt_1(idx_circle,2),...
                           idxPoint_Tgt_2,proj_CC2Tgt_2(idx_circle,1),proj_CC2Tgt_2(idx_circle,2),...
                           idxPoint_Base,proj_CC2Base(1),proj_CC2Base(2),...
                           isLeft_Base,circleType...
                           isPoint_Tgt_1,isPoint_Tgt_2,isPoint_Base];
        circleInfo = [circleInfo;circleInfo_temp];   
        cntrCircles = cntrCircles + 1;
        
        % * * * Plot the circle for test * * *
        % TODO
%         circleCenter(1,1) = CC_4_cand(idx_circle,1);
%         circleCenter(1,2) = CC_4_cand(idx_circle,2);
%         radius = radius_4_cand(idx_circle);
%         % plotSingleCircle(circleCenter,radius,'#000000','#0c406d');
%         plotSingleCircle(circleCenter,radius,'#000000','k');
%         hold on; axis equal;
%         line([circleCenter(1,1),proj_CC2Tgt_1(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_1(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Tgt_2(idx_circle,1)],[circleCenter(1,2),proj_CC2Tgt_2(idx_circle,2)]);
%         line([circleCenter(1,1),proj_CC2Base(idx_circle,1)],[circleCenter(1,2),proj_CC2Base(idx_circle,2)]);
%         
%         % * * * Plot the elements for test * * *
%         scatter(passedPoint_Tgt_1(1,1),passedPoint_Tgt_1(1,2),20)
%         scatter(passedPoint_Tgt_2(1,1),passedPoint_Tgt_2(1,2),20)
%         scatter(passedPoint_Base(1,1),passedPoint_Base(1,2),20)
        
        
    end               
end              



end