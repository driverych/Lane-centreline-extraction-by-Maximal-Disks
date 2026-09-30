% exploreMaximalDisksWithABasePoint
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%   - The cases could be devided into 4 cases (5 types totally).
%     Case 5: The circle passes 2 points and is tangent to 1 segment, 1
%             point is the extreme point of the segment. The base point is 
%             the  off-segment point.
%     Case 2: The circle is tangent to 2 segments and passes by one extreme 
%        |    point, which is not on neither of the 2 segments. The 2
%        |    segments could be on the same side of the lane, or 1 segment
%        |    and the point could be on the same side.
%     Type 1: Two segments are both on the target border and the only point 
%             is on the base border   
%              
%     Case 3: The circle  is tangent to 1 segment and passes 2 extreme 
%        |    points. The segment and 1 point could be on the same side of
%        |    the lane, or the 2 point could be on the same side.
%     Type 1: The point on the target border comes earlier than the segment
%        |    on the targer border. The second point is on the base border.
%        |
%        |
%     Type 2: The segment on the target border comes earlier than the point
%             on the targer border. The second point is on the base border.
%                
%     Case 4: The circle passes 3 extreme points, two of which are on the
%             same lane boder.
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

function [circleInfo,cntrCircles] = exploreMaximalDisksWithABasePoint...
                                    (isLeft_Base,isLeft_Tgt,lanePoints,...
                                     pointPairs_baseSegSP2Tgt,fld_idxs_TgtPoint,...
                                     passedPoint_Base,segPair,segParam_Sta,...
                                     circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)

% The maximal target point index in pointPairs
if isLeft_Base == 1
    % The target point is on the right border and its index is negative
    cntrPoint_Tgt_max = max(abs(pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint)));
    cntrPoint_Tgt_min = min(abs(pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint)));
else
    cntrPoint_Tgt_max = max(pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint)); 
    cntrPoint_Tgt_min = min(pointPairs_baseSegSP2Tgt(:,fld_idxs_TgtPoint)); 
end 

% Select the first target point and rebuild the segment backward
for cntrPoint_Tgt_1 = cntrPoint_Tgt_min:cntrPoint_Tgt_max
    % Skip the point with index=1 for no segment will be found in  
    % the backward direction
    if cntrPoint_Tgt_1 == 1 
        continue
    end

    % Construct the target segment(1) matrix and its standard line formulation
    [segTgt_1,segTgt_1_Sta] = ...
        buildSegmentWithPointIndex_backward(isLeft_Tgt,cntrPoint_Tgt_1,lanePoints);
    segPair(1,:) = segTgt_1; segParam_Sta(1,:) = segTgt_1_Sta;  
    % * * * Plot the segment for test * * *
%     plot([segTgt_1(1,1),segTgt_1(1,3)],[segTgt_1(1,2),segTgt_1(1,4)],'m');
%     hold on; axis equal;  

% %----------------------------------------------------------------------
% %---------------------    Two elements only        --------------------
% %----------------------------------------------------------------------
% 
%     %--------------------------------------------------------------
%     %-----                      Case 7                       ------
%     %--------------------------------------------------------------
%     [circleInfo,cntrCircles] = extractInscribedCircles_caseSeven...
%                (segPair,segParam_Sta,passedPoint_Base,...
%                 isLeft_Base,lanePoints,circleInfo,cntrCircles); 
% 
% 
%     %--------------------------------------------------------------
%     %-----                      Case 8                       ------
%     %--------------------------------------------------------------
%     passedPoint_Tgt_1 = [segTgt_1(1:2),segTgt_1(5)];
%     [circleInfo,cntrCircles] = extractInscribedCircles_caseEight...
%                (segPair,segParam_Sta,passedPoint_Tgt_1,passedPoint_Base,...
%                 isLeft_Base,lanePoints,circleInfo,cntrCircles); 
%     passedPoint_Tgt_1 = [];

%----------------------------------------------------------------------
%------------    Two of three elements are combined        ------------
%----------------------------------------------------------------------

    %--------------------------------------------------------------
    %-----                      Case 5                       ------
    %--------------------------------------------------------------
    % Calculate the inscribed circle: 
    % Case 5: The circle passes 2 points and is tangent to 1 segment, 
    %         1 point is the extreme point of the segment.  
    %         The base point is the off-segment point.

    for idxExetremePoint = 1:2
        if idxExetremePoint == 1
            % Start point of the segTgt_1
            % The segment index will be used in circle sorting
            touchingPoint_Tgt_1 = [segTgt_1(1:2),segTgt_1(5)];
        else
            % End point of the segTgt_1
            touchingPoint_Tgt_1 = [segTgt_1(3:4),segTgt_1(5)];
        end
        [circleInfo,cntrCircles] = extractInscribedCircles_caseFive...
               (segPair,segParam_Sta,touchingPoint_Tgt_1,passedPoint_Base,...
                isLeft_Base,lanePoints,circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN); 
        % Empty the touching point container
        touchingPoint_Tgt_1 = [];
    end


%----------------------------------------------------------------------
%------------     All three elements are seperated        -------------
%----------------------------------------------------------------------

    % If there is no further segment in the forward direction of 
    % the border segments, skip
    if cntrPoint_Tgt_1 == cntrPoint_Tgt_max
        continue
    end            

    % Select the second target point and rebuild the segment
    for cntrPoint_Tgt_2 = cntrPoint_Tgt_1+1:cntrPoint_Tgt_max
        % Construct the traget segment(2) matrix and its standard line formulation
        [segTgt_2,segTgt_2_Sta] = ...
            buildSegmentWithPointIndex_backward(isLeft_Tgt,cntrPoint_Tgt_2,lanePoints);
        segPair(2,:) = segTgt_2; segParam_Sta(2,:) = segTgt_2_Sta; 
        % * * * Plot the segment for test * * *
%         plot([segTgt_2(1,1),segTgt_2(1,3)],[segTgt_2(1,2),segTgt_2(1,4)],'y');
%         hold on; axis equal;

        %----------------------------------------------------------
        %---                   Case 2 Type 1                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 2 Type 1: two segments are both on the target border 
        %                and the point is on the base border
        [circleInfo,cntrCircles] = extractInscribedCircles_caseTwo_typeOne...
            (segPair,segParam_Sta,passedPoint_Base,isLeft_Base,lanePoints,...
             circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);

        %----------------------------------------------------------
        %---                   Case 3 Type 1                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 3 Type 1: The point on the target border comes
        %                earlier than the segment on the targer
        %                border. The second point is on the base
        %                border
        % No need to restrict (cntrPoint_Tgt_2 > cntrPoint_Tgt_1 + 1)
        % here
        passedPoint_Tgt_1 = [segTgt_1(1,1:2),segTgt_1(1,5)];
        [circleInfo,cntrCircles] = extractInscribedCircles_caseThree_typeOne...
            (segPair,segParam_Sta,passedPoint_Base,passedPoint_Tgt_1,isLeft_Base,lanePoints,...
             circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
        passedPoint_Tgt_1 = [];

        %----------------------------------------------------------
        %---                   Case 3 Type 2                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 3 Type 2: The segment on the target border comes
        %                earlier than the point on the targer
        %                border. The second point is on the base
        %                border
        % If cntrPoint_Tgt_2 = cntrPoint_Tgt_1 + 1, then it is case 5
        if cntrPoint_Tgt_2 > cntrPoint_Tgt_1 + 1
            passedPoint_Tgt_2 = [segTgt_2(1,1:2),segTgt_2(1,5)]; % To be checked here, passedPoint_Tgt_2 will not reach the last point
            [circleInfo,cntrCircles] = extractInscribedCircles_caseThree_typeTwo...
                (segPair,segParam_Sta,passedPoint_Base,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
            passedPoint_Tgt_2 = [];
        end    

        %----------------------------------------------------------
        %---                      Case 4                       ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 4: The circle passes 3 extreme points, two of which 
        %         are on the same lane boder.
        if isLeft_Base == 1
            passedPoint_Tgt_1 = ...
                [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_1),2:3),-cntrPoint_Tgt_1];
        else
            passedPoint_Tgt_1 = ...
                [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_1),2:3),cntrPoint_Tgt_1];
        end  

        if isLeft_Base == 1
            passedPoint_Tgt_2 = ...
                [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_2),2:3),-cntrPoint_Tgt_2];
        else
            passedPoint_Tgt_2 = ...
                [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_2),2:3),cntrPoint_Tgt_2];
        end 
        [circleInfo,cntrCircles] = extracteInscribedCircles_caseFour...
            (segPair,passedPoint_Base,passedPoint_Tgt_1,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
             circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
        passedPoint_Tgt_1 = [];
        passedPoint_Tgt_2 = [];
        
    end % cntrPoint_Tgt_2 = cntrPoint_Tgt_1+1:cntrPoint_Tgt_max
end % cntrPoint_Tgt_1 = cntrPoint_Tgt_min:cntrPoint_Tgt_max



end