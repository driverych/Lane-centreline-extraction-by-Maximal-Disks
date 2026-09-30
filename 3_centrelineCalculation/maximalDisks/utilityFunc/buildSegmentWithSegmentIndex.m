% buildSegmentWithSegmentIndex
%   - Build a line segment according to the segment index 
% 
% Syntax:  [seg,segParam_Sta] = buildSegmentWithSegmentIndex(isLeft,idxSeg,lanePoints)
%
% Input:
%    isLeft - A discriminant indicating if the segment is on the left
%             border
%    idxSeg - The index of the segment
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
%        P_1      P_2      P_3
%         *--------*--------*--------> border(forward direction)
%            -S1-     -S2-     -S3-



function [seg,segParam_Sta] = buildSegmentWithSegmentIndex(isLeft,idxSeg,lanePoints)

if isLeft == 1 % Build a left segment
    % Extract left point coordinate from lanePoints
    idx_segL_start = idxSeg;
    segL_start = lanePoints(find(lanePoints(:,1) == idx_segL_start),2:3);
    idx_segL_end = idxSeg + 1;
    segL_end = lanePoints(find(lanePoints(:,1) == idx_segL_end),2:3);    

    % Construct the segment with the start and end points
    segL = [segL_start,segL_end];
    seg = [segL,idxSeg];
    segL_Sta = standardFormEquFrom2Points(segL_start,segL_end);
    segParam_Sta = segL_Sta;
else % Build a right segment
    % The right start and end point index in lanePoints
    % All index info in the right border is negtive numbers
    idx_segR_start = idxSeg; % A negative number will be used below
    segR_start = lanePoints(find(lanePoints(:,1) == -idx_segR_start),2:3);
    idx_segR_end = idxSeg + 1;
    segR_end = lanePoints(find(lanePoints(:,1) == -idx_segR_end),2:3);
    
    % Construct the segment with the start and end points
    segR = [segR_start,segR_end];
    seg = [segR,-idxSeg];
    segR_Sta = standardFormEquFrom2Points(segR_start,segR_end);
    segParam_Sta = segR_Sta;       
end
    
end