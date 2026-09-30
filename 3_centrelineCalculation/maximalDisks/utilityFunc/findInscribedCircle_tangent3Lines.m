% findCircle_tangent3Lines - 
%       Find a circle which is tangent to 3 lines.
% 
% Syntax:  [p_circleCenter,radius] = findCircle_tangent3Lines(targetLine_1,targetLine_2,baseLine)
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
function [p_circleCenter,radius,proj_CC2Tat_1,proj_CC2Tgt_2,proj_CC2Base] = ...
    findInscribedCircle_tangent3Lines(tgtSeg_Sta_1,tgtSeg_Sta_2,baseSeg_Sta)

    % Calculate the circuit centre
    [p_circleCenter_cand,num_circleCand] = calculateConicIntersections_given3Lines(tgtSeg_Sta_1,tgtSeg_Sta_2,baseSeg_Sta);
    
    % Output the circles 
    if num_circleCand == 0
        p_circleCenter = [];radius = [];
        proj_CC2Tat_1 = [];proj_CC2Tgt_2 = [];proj_CC2Base = [];
        return
    else
        % The circle centre info
        p_circleCenter = p_circleCenter_cand;
        % Initialize the projection info
        proj_CC2Tat_1 = zeros(num_circleCand,2);
        proj_CC2Tgt_2 = zeros(num_circleCand,2);
        proj_CC2Base = zeros(num_circleCand,2);
        radius_cand = zeros(num_circleCand,1);
        for idx_circle = 1:num_circleCand
            % Calculate the radius for candidate circles
            % The two methods to calcualte the radius are the same but there is a    
            % little difference between two reults,with 99.99% similarity
            % radius_candidate(iterator_circle) = distancePoint2Point(p_circleCenter_candidate(iterator_circle,1:2),pointOnCircle);
            radius_cand(idx_circle) = distancePoint2Line(p_circleCenter_cand(idx_circle,1:2),tgtSeg_Sta_1);
            proj_CC2Tat_1(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),tgtSeg_Sta_1);
            proj_CC2Tgt_2(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),tgtSeg_Sta_2);
            proj_CC2Base(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),baseSeg_Sta);
        end
        radius = radius_cand;
    end

end