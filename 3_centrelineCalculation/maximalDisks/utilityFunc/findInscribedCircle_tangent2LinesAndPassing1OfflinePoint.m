% findCircle_tangent2LinesAndPassing1point - 
%       Find a circle which is tangent to 2 lines and passes by 1 point,
%       with the point out of aforementioned lines.
% 
% Syntax:  [p_circleCenter,radius] = findCircle_tangent2LinesAndPassing1linePoint(baseLine,targetLine,pointOnCircle,isBaseLeft)
%
% Input:
%    baseLine - An array that contains start and end point information of
%               the given base segment
%    targetLine - An array that contains start and end point information of
%                 the given target segment
%    pointOnCircle - An array that contains point formation which is passed
%                   by a circle and lies in the baseline.
%    isBaseLeft - This flag indicates if the left border is selcted as the
%                 base border, where base segments are.
%
% Output:
%    p_circleCenter - An array contains circle centre coordinates
%    radius - An array stores the cirlce radius.
%
% Other m-files required:
%     standardFormEquFrom2Points.m 
%     findCircleCentre_tangent2LinesAndPassing1point.m
%     distancePoint2Line.m
%     isProjectionOnSegment.m
% Subfunctions:
%     standardFormEquFrom2Points
%     findCircleCentre_tangent2LinesAndPassing1point
%     distancePoint2Line
%     isProjectionOnSegment.
% MAT-files required: none
% Abbreviation:
% cand -> candidate
% seg -> segment
% idx -> index

function [p_circleCenter,radius,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
                findInscribedCircle_tangent2LinesAndPassing1OfflinePoint...
                (pointOrLine_tgtSeg_1,pointOrLine_tgtSeg_2,pointOrLine_baseSeg,subClass)
            
    % Allocate different parameters to different subclasses        
    if subClass == 1
        linePar_1_Sta = pointOrLine_tgtSeg_1;
        linePar_2_Sta = pointOrLine_tgtSeg_2;
        point_1 = pointOrLine_baseSeg;
    elseif subClass == 2
        point_1 = pointOrLine_tgtSeg_1;
        linePar_1_Sta = pointOrLine_tgtSeg_2;
        linePar_2_Sta = pointOrLine_baseSeg;
    else % subClass = 3
        linePar_1_Sta = pointOrLine_tgtSeg_1;
        point_1 = pointOrLine_tgtSeg_2;
        linePar_2_Sta = pointOrLine_baseSeg;
    end

    % Calculate the circuit centre
    [p_circleCenter_cand,num_circleCand] = ...
        calculateConicIntersections_given2LinesAnd1Point(linePar_1_Sta,linePar_2_Sta,point_1);
    
    % Output the circles
    if num_circleCand == 0
        p_circleCenter = [];radius = [];
        proj_CC2Tgt_1 = [];proj_CC2Tgt_2 = [];
        proj_CC2Base = [];
        return
    else
        % The circle centre info
        p_circleCenter = p_circleCenter_cand;
        % Initialize the projection info
        proj_CC2Tgt_1 = zeros(num_circleCand,2);
        proj_CC2Tgt_2 = zeros(num_circleCand,2);
        proj_CC2Base = zeros(num_circleCand,2);
        radius_cand = zeros(num_circleCand,1);
        for idx_circle = 1:num_circleCand
            % The two methods to calcualte the radius are the same but there is a    
            % little difference between two reults,with 99.99% similarity
            % radius_candidate(iterator_circle) = distancePoint2Point(p_circleCenter_candidate(iterator_circle,1:2),pointOnCircle);
            radius_cand(idx_circle) = distancePoint2Line(p_circleCenter_cand(idx_circle,1:2),linePar_1_Sta);
            % Add the projection info
            if subClass == 1
                proj_CC2Tgt_1(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_tgtSeg_1);
                proj_CC2Tgt_2(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_tgtSeg_2);
                proj_CC2Base(idx_circle,1:2) = pointOrLine_baseSeg;
            elseif subClass == 2
                proj_CC2Tgt_1(idx_circle,1:2) = pointOrLine_tgtSeg_1;
                proj_CC2Tgt_2(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_tgtSeg_2);
                proj_CC2Base(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_baseSeg);
            else
                proj_CC2Tgt_1(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_tgtSeg_1);
                proj_CC2Tgt_2(idx_circle,1:2) = pointOrLine_tgtSeg_2;
                proj_CC2Base(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),pointOrLine_baseSeg);
            end
        end
        radius = radius_cand;
    end

end