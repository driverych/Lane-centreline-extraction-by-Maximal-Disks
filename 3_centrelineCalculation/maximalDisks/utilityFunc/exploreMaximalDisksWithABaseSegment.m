% exploreMaximalDisksWithABaseSegment
%   - Calculate lane centrelines based on Maximal Disks. Point pairs are
%     used to reconstruct segment pairs. 
%   - The cases could be devided into 4 cases (5 types totally).
%     Case 6: The circle is tangent to 2 segments and passes by one extreme 
%             point, which is on one of the segments
%     Case 1: The circle is tangent to 3 segments,2 of which are on the
%             same lane boder.
%     Case 2: The circle is tangent to 2 segments and passes by one extreme 
%        |    point, which is not on neither of the 2 segments. The 2
%        |    segments could be on the same side of the lane, or 1 segment
%        |    and the point could be on the same side.
%     Type 2: One segment and the point are both on the target border.  
%        |     The left segment is on the base border. The index of the 
%        |     segment is smaller than that of the point.           
%     Type 3: One segment and the point are both on the target border. 
%             The left segment is on the base border. The index of the 
%             point is smaller than that of the segment.           
%                
%     Case 3: The circle is tangent to 2 segments and passes by one extreme 
%        |    point, which is not on neither of the 2 segments. The 2
%        |    segments could be on the same side of the lane, or 1 segment
%        |    and the point could be on the same side.
%     Type 3: Two points are on the target border. And the segment is on 
%             the base border.      
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
% intxn -> intersection
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

function [circleInfo,cntrCircles] = exploreMaximalDisksWithABaseSegment...
                                    (isLeft_Base,isLeft_Tgt,lanePoints,...
                                     idxsPoint_Base2Tgt_inPP,...
                                     cntrPoint_base,numPoints_base,segPair,segParam_Sta,...
                                     circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN)

% The maximal target point index in pointPairs
if isLeft_Base == 1
    cntrPoint_Tgt_max = max(abs(idxsPoint_Base2Tgt_inPP));
    cntrPoint_Tgt_min = min(abs(idxsPoint_Base2Tgt_inPP));
else
    cntrPoint_Tgt_max = max(idxsPoint_Base2Tgt_inPP); 
    cntrPoint_Tgt_min = min(idxsPoint_Base2Tgt_inPP); 
end 

% Select the first target point and rebuild the segment
% Backward: the reverse direction of the lane
% Forward: the direction of the lane
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

%----------------------------------------------------------------------
%------------    Two of three elements are combined        ------------
%----------------------------------------------------------------------

    %--------------------------------------------------------------
    %-----                       Case 6                      ------
    %--------------------------------------------------------------
    % Calculate the inscribed circle: 
    % Case 6: The circle is tangent to 2 segments and passes by one  
    %         extreme point, which is on the target segment.  
    if cntrPoint_base < numPoints_base
        for idxExetremePoint = 1:2
            if idxExetremePoint == 1
                % Start point of the segTgt_1
                touchingPoint = [segTgt_1(1:2),segTgt_1(5)];
            else
                % End point of the segTgt_1
                touchingPoint = [segTgt_1(3:4),segTgt_1(5)];
            end
            [circleInfo,cntrCircles] = extractInscribedCircles_caseSix...
                (segPair,segParam_Sta,touchingPoint,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN); 
        end
    end

%----------------------------------------------------------------------
%------------     All three elements are seperated        -------------
%----------------------------------------------------------------------

    % If there is no further segment in the forward direction of 
    % the border segments, skip
    if cntrPoint_Tgt_1 >= cntrPoint_Tgt_max
        continue
    end

    % Select the second target point and rebuild the segment
    for cntrPoint_Tgt_2 = cntrPoint_Tgt_1+1:cntrPoint_Tgt_max
        % Construct the traget segment(2) matrix and its standard line formulation
        if isLeft_Base == 1
            isLeft_Tgt = 0;
        else
            isLeft_Tgt = 1;
        end
        [segTgt_2,segTgt_2_Sta] = ...
            buildSegmentWithPointIndex_backward(isLeft_Tgt,cntrPoint_Tgt_2,lanePoints);
        segPair(2,:) = segTgt_2; segParam_Sta(2,:) = segTgt_2_Sta; 
        % * * * Plot the segment for test * * *
%         plot([segTgt_2(1,1),segTgt_2(1,3)],[segTgt_2(1,2),segTgt_2(1,4)],'y');
%         hold on; axis equal;

        %----------------------------------------------------------
        %---                       Case 1                      ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 1: The circle is tangent to 3 segments,2 of which 
        %         are on the same lane boder.
        if cntrPoint_base < numPoints_base
            [circleInfo,cntrCircles] = extractInscribedCircles_caseOne...
                (segPair,segParam_Sta,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
        end

        %----------------------------------------------------------
        %---                   Case 2 Type 2                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 2 Type 2: One segment and the point are both on the  
        %                target border. The left segment is on the 
        %                base border. The index of the segment is
        %                smaller than that of the point.
        if cntrPoint_base < numPoints_base
            % If cntrPoint_Tgt_2 = cntrPoint_Tgt_1 + 1, it is case 6
            if cntrPoint_Tgt_2 > cntrPoint_Tgt_1 + 1
                if isLeft_Base == 1
                    passedPoint_Tgt_1 = ...
                        [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_1),2:3),-cntrPoint_Tgt_1];
                else
                    passedPoint_Tgt_1 = ...
                        [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_1),2:3),cntrPoint_Tgt_1];
                end

                [circleInfo,cntrCircles] = extractInscribedCircles_caseTwo_typeTwo...
                    (segPair,segParam_Sta,passedPoint_Tgt_1,isLeft_Base,lanePoints,...
                     circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
                passedPoint_Tgt_1 = [];
            end
        end

        %----------------------------------------------------------
        %---                   Case 2 Type 3                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 2 Type 3: One segment and the point are both on the  
        %                target border. The left segment is on the 
        %                base border. The index of the point is
        %                smaller than that of the segment.
        if cntrPoint_base < numPoints_base
            if cntrPoint_Tgt_2 > cntrPoint_Tgt_1 + 1 % To avoild sovler faliure
                if isLeft_Base == 1
                    passedPoint_Tgt_2 = ...
                        [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_2),2:3),-cntrPoint_Tgt_2];
                else
                    passedPoint_Tgt_2 = ...
                        [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_2),2:3),cntrPoint_Tgt_2];
                end
                [circleInfo,cntrCircles] = extractInscribedCircles_caseTwo_typeThree...
                    (segPair,segParam_Sta,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
                     circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
                passedPoint_Tgt_2 = [];
            end
        end

        %----------------------------------------------------------
        %---                   Case 3 Type 3                   ----
        %----------------------------------------------------------
        % Calculate the inscribed circle: 
        % Case 3 Type 3: Two points are on the target border. And
        %                the segment is on the base border. 
        if cntrPoint_base < numPoints_base
            % Select the touching point and find its real index
            if isLeft_Base == 1
                passedPoint_Tgt_1 = ...
                    [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_1),2:3),-cntrPoint_Tgt_1];
                passedPoint_Tgt_2 = ...
                    [lanePoints((lanePoints(:,1) == -cntrPoint_Tgt_2),2:3),-cntrPoint_Tgt_2];
            else
                passedPoint_Tgt_1 = ...
                    [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_1),2:3),cntrPoint_Tgt_1];
                passedPoint_Tgt_2 = ...
                    [lanePoints((lanePoints(:,1) == cntrPoint_Tgt_2),2:3),cntrPoint_Tgt_2];
            end
            [circleInfo,cntrCircles] = extractInscribedCircles_caseThree_typeThree...
                (segPair,segParam_Sta,passedPoint_Tgt_1,passedPoint_Tgt_2,isLeft_Base,lanePoints,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
            passedPoint_Tgt_1 = [];
            passedPoint_Tgt_2 = [];
        end


    end % cntrPoint_Tgt_2 = cntrPoint_Tgt_1+1:cntrPoint_Tgt_max
end % cntrPoint_Tgt_1 = cntrPoint_Tgt_min:cntrPoint_Tgt_max

end