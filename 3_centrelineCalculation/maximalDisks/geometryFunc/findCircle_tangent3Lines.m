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
function [p_circleCenter,radius] = ...
    findCircle_tangent3Lines(targetLine_1,targetLine_2,baseLine)
    par_targetSeg_Sta_1 = standardFormEquFrom2Points(targetLine_1(1:2),targetLine_1(3:4));
    par_targetSeg_Sta_2 = standardFormEquFrom2Points(targetLine_2(1:2),targetLine_2(3:4));
    par_baseSeg_Sta_1 = standardFormEquFrom2Points(baseLine(1:2),baseLine(3:4));
    % Calculate the circuit centre
    [p_circleCenter_cand,num_circleCand] = calculateConicIntersections_given3Lines(par_targetSeg_Sta_1,par_targetSeg_Sta_2,par_baseSeg_Sta_1);
    % Calculate the radius for candidate circles
    if num_circleCand == 0
        p_circleCenter = [];radius = [];
        return;
    else
        radius_cand = zeros(num_circleCand,1);
        for idx_circle = 1:num_circleCand
            % The two methods to calcualte the radius are the same but there is a    
            % little difference between two reults,with 99.99% similarity
            % radius_candidate(iterator_circle) = distancePoint2Point(p_circleCenter_candidate(iterator_circle,1:2),pointOnCircle);
            radius_cand(idx_circle) = distancePoint2Line(p_circleCenter_cand(idx_circle,1:2),par_targetSeg_Sta_1);
        end
    end    
    % Output the circles whose projections are on the segments
    cntr_circle = 0;
    idxsCircles = zeros(num_circleCand,1);
    for idx_circle = 1:num_circleCand
        % Identify whether the projection is on the target segment
        outRange_1 = isProjectionOnSegment(p_circleCenter_cand(idx_circle,1:2),targetLine_1);
        outRange_2 = isProjectionOnSegment(p_circleCenter_cand(idx_circle,1:2),targetLine_2);
        outRange_3 = isProjectionOnSegment(p_circleCenter_cand(idx_circle,1:2),baseLine);
        if outRange_1 == 1 || outRange_2 == 1 || outRange_3 == 1
            continue;
        else
            cntr_circle = cntr_circle + 1;
            idxsCircles(cntr_circle) = idx_circle;
        end
    end    
    
    if cntr_circle == 0
        p_circleCenter = [];radius = [];
        return;
    else
        p_circleCenter = zeros(cntr_circle,2);
        radius = zeros(cntr_circle,1);
        for idx_circle = 1:cntr_circle
            p_circleCenter(idx_circle,1:2) = ...
                p_circleCenter_cand(idxsCircles(idx_circle),1:2);
            radius(idx_circle) = radius_cand(idxsCircles(idx_circle));
        end
    end    
end