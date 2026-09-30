% findInscribedCircle_tangent1LineAndPassing2OffAndOnlinePoints - 
%       Find a circle which is tangent to 1 line and passes 2 points, one
%       of which is on the line
% 
% Syntax:  [p_circleCenter,radius,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] =
%               findInscribedCircle_tangent1LineAndPassing2OffAndOnlinePoints
%               (pointOrLine_targetSeg_1,pointOrLine_targetSeg_2,pointOrLine_baseSeg,subType)
%
% Input:
%    targetLine_1 - An array that contains start and end point information of
%                   the given target segment
%    targetLine_2 - An array that contains start and end point information of
%                   the given target segment
%    baseLine - An array that contains start and end point information of
%               the given base segment
%
% Output:
%    p_circleCenter - An array contains circle centre coordinates
%    radius - An array stores the cirlce radius.
%
% Other m-files required: none
% Subfunctions: standardFormEquFrom2Points.m 
%               findCircleCentre_tangent3Lines.m
%               distancePoint2Line.m
%               isProjectionOnSegment.m
% MAT-files required: none

function [p_circleCenter,radius,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
            findInscribedCircle_tangent1LineAndPassing2OffAndOnlinePoints...
            (segTgt_1_Sta,touchingPoint,passedPoint)
    
% Calculate the circuit centre
[p_circleCenter_cand,num_circleCand] = ...
    calculateConicIntersections_given1LineAnd2Points_specialCase(touchingPoint,passedPoint,segTgt_1_Sta);

% Output the circles
if num_circleCand == 0
    p_circleCenter = [];radius = [];
    proj_CC2Tgt_1 = [];proj_CC2Tgt_2 = [];proj_CC2Base = []; 
    return
else
    % The circle centre info
    p_circleCenter = p_circleCenter_cand;
    % Initialize the projection info
    proj_CC2Tgt_1 = zeros(num_circleCand,2);
    proj_CC2Tgt_2 = zeros(num_circleCand,2); % keep zeros because of no projection
    proj_CC2Base = zeros(num_circleCand,2);
    radius_cand = zeros(num_circleCand,1);
    for idx_circle = 1:num_circleCand
        % Calculate the radius for candidate circles
        % The two methods to calcualte the radius are the same but there is a    
        % little difference between two reults,with 99.99% similarity
        % radius_candidate(iterator_circle) = distancePoint2Point(p_circleCenter_candidate(iterator_circle,1:2),pointOnCircle);
        radius_cand(idx_circle) = distancePoint2Line(p_circleCenter_cand(idx_circle,1:2),segTgt_1_Sta);
        % Add the projection info
        % Keep segTgt_2 unchanged because of no projection
        proj_CC2Tgt_1(idx_circle,1:2) = touchingPoint;
        proj_CC2Base(idx_circle,1:2) = passedPoint;
    end
    radius = radius_cand;
end    
  
end