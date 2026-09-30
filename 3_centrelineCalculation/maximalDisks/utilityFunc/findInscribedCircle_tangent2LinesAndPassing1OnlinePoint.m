% findCircle_tangent2LinesAndPassing1linePoint - 
%       Find a circle which is tangent to 2 opposite lines and 
%       pass by 1 point, with the point lying on one of the aforementioned line.
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
% Other m-files required: none

% Subfunctions: standardFormEquFrom2Points.m 
%               standForm2sIForm.m
%               intersectionFrom2Lines.m
%               centrepointOf2Borders.m
%               perpendicularLineFromPointAndLine_Sta.m
%               distancePoint2Line.m
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% int -> intersection
% sta -> standard
% equ -> equation
% seg -> segment
% sI -> slope intercept

function [p_circleCenter,radius,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
            findInscribedCircle_tangent2LinesAndPassing1OnlinePoint...
            (segTgt_1_Sta,baseSeg_Sta,touchingPoint,segPair,isBaseLeft)

    % Calculate the circuit centre
    [p_circleCenter_cand,num_circleCand] = ...
        calculateConicIntersections_given2LinesAnd1Point_specialCase...
        (segTgt_1_Sta,baseSeg_Sta,touchingPoint,segPair,isBaseLeft);
    
    % Output the circles
    if num_circleCand == 0
        p_circleCenter = [];radius = [];
        proj_CC2Tgt_1 = [];proj_CC2Base = [];
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
            % The two methods to calcualte the radius are the same but there is a    
            % little difference between two reults,with 99.99% similarity
            % radius_candidate(iterator_circle) = distancePoint2Point(p_circleCenter_candidate(iterator_circle,1:2),pointOnCircle);
            radius_cand(idx_circle) = distancePoint2Line(p_circleCenter_cand(idx_circle,1:2),segTgt_1_Sta);
            proj_CC2Tgt_1(idx_circle,1:2) = touchingPoint;
            proj_CC2Base(idx_circle,1:2) = projectPoint2Line(p_circleCenter(idx_circle,1:2),baseSeg_Sta);
        end
        radius = radius_cand;
    end

end