% buildSegmentWithPointIndex_backward
%   - Build a line segment according to the point index in the backward
%     direction of the lane border
% 
% Syntax:  [seg,segParam_Sta] = buildSegmentWithPointIndex_backward(isLeft,idxPoint,lanePoints)
%
% Input:
%    isLeft - A discriminant indicating if the segment is on the left
%             border
%    idxPoint - The index of the point
%    lanePoints - Lane points of both left and right borders
%
% Output:
%    seg - A matlab matrix storing coordinates of the start and end points
%    segParam_Sta - A matlab matrix storing parameters of segment's
%                   standform equation parameters
%
% Subfunctions: standardFormEquFrom2Points
%
% MAT-files required: none
% Abbreviation:
% param -> parameter
% sta -> standard
% seg -> segment
% idx -> index
% R -> right
% L -> left

% An example of relations between point index and segment index

%        p_1      P_2      P_3
%         *--------*--------*--------> border(x direction)
%            -S1-     -S2-     -S3-

% idx_S1 = idx_P1 - 1;

function [seg,segParam_Sta] = buildSegmentWithPointIndex_backward(isLeft,idxPoint,lanePoints)

if isLeft == 1
    idxSeg_L = idxPoint - 1;
    % Extract left point coordinate from lanePoints
    idx_segL_start = idxSeg_L;
    segL_start = lanePoints((lanePoints(:,1) == idx_segL_start),2:3);
    idx_segL_end = idxSeg_L + 1;
    segL_end = lanePoints((lanePoints(:,1) == idx_segL_end),2:3);

    % Construct the segment with the start and end points
    seg = [segL_start,segL_end,idxSeg_L];
    segParam_Sta = standardFormEquFrom2Points(segL_start,segL_end);
else
    idxSeg_R = idxPoint - 1; % A Positive number here - idxPoint
    % The right start and end point index in lanePoints
    idx_segR_start = idxSeg_R;
    segR_start = lanePoints((lanePoints(:,1) == -idx_segR_start),2:3);
    idx_segR_end = idxSeg_R + 1;
    segR_end = lanePoints((lanePoints(:,1) == -idx_segR_end),2:3);

    % Construct the segment with the start and end points
    seg = [segR_start,segR_end,-idxSeg_R]; % The index of the right segment is negtive
    segParam_Sta = standardFormEquFrom2Points(segR_start,segR_end);
end

end