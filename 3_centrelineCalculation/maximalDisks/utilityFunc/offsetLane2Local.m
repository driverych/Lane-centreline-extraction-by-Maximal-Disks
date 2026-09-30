% offsetLane - Offset the lane points according to the map origin
% 
% Syntax:  lane_out = offsetLane(lane_in,coordRange)
%
% Input:
%    lane_struct - A matlab struct storing lane border points
%    origin - The local origin
%
% Output:
%    lanePoints_matrix - A matlab matrix storing points info 
%                        (left and right points are concatenated in rows)
%    laneInfo_struct - A matlab struct storing basic lane info
%    fld - fields of the data
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% num -> number
% idx -> index
% r -> right
% l -> left

function [lanePoints_matrix,laneInfo_struct,flds] = offsetLane2Local(lane_struct,origin)

% Offset the left border, the indexes of the left points are positive
numPoints_L = numel(lane_struct.leftBoundary.Points);
idx_leftPoints = ((1:numPoints_L))';
x_leftPoints = [lane_struct.leftBoundary.Points(:).UTM_x]' - origin.x;
y_leftPoints = [lane_struct.leftBoundary.Points(:).UTM_y]' - origin.y;
lanePoints_left = [idx_leftPoints,x_leftPoints,y_leftPoints];

% Offset the right border, the indexes of the right points are negtive
numPoints_R = numel(lane_struct.rightBoundary.Points);
idx_rightPoints = ((1:numPoints_R))'*-1;
x_rightPoints = [lane_struct.rightBoundary.Points(:).UTM_x]' - origin.x;
y_rightPoints = [lane_struct.rightBoundary.Points(:).UTM_y]' - origin.y;
lanePoints_right = [idx_rightPoints,x_rightPoints,y_rightPoints];

% Concatenate for output
lanePoints_matrix = [lanePoints_left;lanePoints_right];
laneInfo_struct.leftPoints.number = numPoints_L;
laneInfo_struct.rightPoints.number = numPoints_R;

% The field of the data
flds.lanePoints.idx = 1; flds.lanePoints.xCoord = 2; flds.lanePoints.yCoord = 3;
flds.lanePoints.coords = 2:3;

end