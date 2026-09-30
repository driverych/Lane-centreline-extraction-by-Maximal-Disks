% connectCircleCentres
%   - Sequence the centre points while runing through all left border segments
%   - First, find all circles with the chosen segment as the base segment.
%     This is how all circles are demonstrated in the designing stage.
%   - If the chosen segment is not the base segment of the found circles,
%     then find all circles with their touching points in the chosen
%     segment. The touching point is the projection point from the circle
%     centre to the line segment. And the linking line defined by circle
%     centre and the touching point is perpendicular to the chosen segment.
%     Normally, the chosen segment is the target_1 segment. But in some
%     cases, it is the target_2 segment.
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCircleCentres(lanePoints,laneInfo,circleInfo)
%
% Input:
%    lanePoints - A matlab martix storing both left and right border points.
%                 Its field is [index,x,y]
%    laneInfo - A matlab struct storing info of point numbers
%    circleInfo - A matlab matrix to store circle info
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions: pointPairing
%
% MAT-files required: none
%
% Abbreviation:
% seg -> segment
% num -> number
% tgt -> target
% fld -> field
% idx -> index
% cir -> circl
% R -> right
% L -> left

function [circlesConnected,numCircles] = connectCircleCentres(lanePoints,laneInfo,circleInfo)

% Extract left points and segments
numPoints_L = laneInfo.leftPoints.number;
numSegs_L = numPoints_L - 1;
leftPoints = lanePoints(1:numPoints_L,:);

% The fields of the circleInfo matrix
fld_idx_segTgt_1 = 4;
fld_idx_segTgt_2 = 7;
fld_idx_segBase = 10;
fld_isLeftBase = 13;
fld_circleType = 14;

% Extract the circles accroding to if the left border is the base segment 
% or not while finding the circles
isLeftBase = 1;
idxsCirs_isLeftBase = find(circleInfo(:,fld_isLeftBase)==isLeftBase);
cirs_isLeftBase = circleInfo(idxsCirs_isLeftBase,:);

idxsCirs_isRightBase = find(circleInfo(:,fld_isLeftBase)~=isLeftBase);
cirs_isRightBase = circleInfo(idxsCirs_isRightBase,:);

% Initialise
numCircles = 0; circlesConnected = [];

for idxSeg = 1: numSegs_L
    
    % Select the circles with the selected segments as the base segments
    % 5 (4+1) types
    idxsCirs_segAsBase = ...
        find( (cirs_isLeftBase(:,fld_idx_segBase)==idxSeg) );
%         find( (cirs_isLeftBase(:,fld_idx_segBase)==idxSeg) & (cirs_isRightBase(:,fld_circleType)~=6) & (cirs_isRightBase(:,fld_circleType)~=7) );
    cirs_segAsBase = cirs_isLeftBase(idxsCirs_segAsBase,:);
    
    % select the circles with the target_1 projection points on the
    % selected segments
    % 6 (4+2) types
    idxsCirs_segAsTgt_1 = ...
        find( (cirs_isRightBase(:,fld_idx_segTgt_1)==idxSeg) & (cirs_isRightBase(:,fld_circleType)~=7) );
    cirs_segAsTgt_1 = cirs_isRightBase(idxsCirs_segAsTgt_1,:);
    
    % select the circles with the target_2 projection points on the
    % selected segments
    % 1 type
    idxsCirs_segAsTgt_2 = ...
        find( (cirs_isRightBase(:,fld_idx_segTgt_2)==idxSeg & cirs_isRightBase(:,fld_circleType)==7) );
    cirs_segAsTgt_2 = cirs_isRightBase(idxsCirs_segAsTgt_2,:);    

    % Extract the start and end points of the selected segemnt
    startPoint = leftPoints(idxSeg,2:3);
    endPoint = leftPoints(idxSeg+1,2:3);
    
    % Sort circles by start, middle and end points
    % Sort the circles by the start and end points
    searchOnSeg = 3; % Search on segments in the base type
    [circles_startBase,idxs_startBase] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,startPoint,cirs_segAsBase);
    [circles_endBase,idxs_endBase] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,endPoint,cirs_segAsBase);
    
    searchOnSeg = 1; % Search on segments in the target_1 type
    [circles_startTgt_1,idxs_startTgt_1] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,startPoint,cirs_segAsTgt_1);    
    [circles_endTgt_1,idxs_endTgt_1] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,endPoint,cirs_segAsTgt_1);    

    searchOnSeg = 2; % Search on segments in the target_2 type
    [circles_startTgt_2,idxs_startTgt_2] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,startPoint,cirs_segAsTgt_2);    
    [circles_endTgt_2,idxs_endTgt_2] = ...
        findSpecificPointsFromCircleMatrix(searchOnSeg,endPoint,cirs_segAsTgt_2);     
    
    circles_start = [circles_startBase;circles_startTgt_1;circles_startTgt_2];  
    circles_end = [circles_endBase;circles_endTgt_1;circles_endTgt_2];
    
    % Sort the circles in the middle
    idxs_noMid_base = [idxs_startBase;idxs_endBase];
    cirs_segAsBase(idxs_noMid_base,:) = [];
    circles_midBase = cirs_segAsBase;
    
    idxs_noMid_tgt_1 = [idxs_startTgt_1;idxs_endTgt_1];
    cirs_segAsTgt_1(idxs_noMid_tgt_1,:) = [];
    circles_midTgt_1 = cirs_segAsTgt_1;    

    idxs_noMid_tgt_2 = [idxs_startTgt_2;idxs_endTgt_2];
    cirs_segAsTgt_2(idxs_noMid_tgt_2,:) = [];
    circles_midTgt_2 = cirs_segAsTgt_2;      
    
    circles_mid = [circles_midBase;circles_midTgt_1;circles_midTgt_2];
    
    % The current left segment
    segL = [startPoint,endPoint];
    % Connect the points by the start point
    if isempty(circles_start) ~= 1
        [circlesConnected,numCircles] = ...
            connectCirclesPassingStartPoint(segL,circles_start,numCircles,circlesConnected);
    end
    
    % Connect the points by the middle points
    if isempty(circles_mid) ~= 1
        [circlesConnected,numCircles] = ...
            connectCirclesPassingMiddlePoint(segL,circles_mid,numCircles,circlesConnected);
    end    
    
    % Connect the points by the end point
    if isempty(circles_end) ~= 1
        [circlesConnected,numCircles] = ...
            connectCirclesPassingEndPoint(segL,circles_end,numCircles,circlesConnected);
    end    

end

% Sort circles by segments

    % If the circle centre is calculated with left borders as base segments,
    % select the circles with the selected segments as the base segments.

    % If the circle centre is calculated with right borders as base segments,
    % select the circles with the target_1 projection points on the
    % selected segments
    
    % Judge if the associated points are the start points
        % The angle is from 90 - 270, with the selected segment as the base
        % Bigger the angle is, farther the centre is away from the start
    
    % Judge if the associated points are the end points
        % The angle is from -90 - 90, with the selected segment as the base
        % Smaller the angle is, farther the centre is away from the start
    
    % Judge if the associated points are the middle points





end