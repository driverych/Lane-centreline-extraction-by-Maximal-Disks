% findCircleCentre_tangent2LinesAndPassing1point - 
%       Find the centre of a circle which is tangent to 2 lines and passes 
%       by 1 point, with the point out of aforementioned lines.
% 
% Syntax:  [p_centre,num_point] = findCircleCentre_tangent2LinesAndPassing1point(par_Sta_1,par_Sta_2,point)
%
% Input:
%    par_Sta_1 - The parameters of a standform line equation
%    par_Sta_2 - The parameters of a standform line equation
%    point - An array that contains point coordinates
%
% Output:
%    p_centre - An array contains circle centre coordinates
%    num_point - A variable stores how many circles are found.
%
% Other m-files required: intersectConics.m
% Subfunctions: intersectConics
% MAT-files required: none

function [p_centre,num_point] = calculateConicIntersections_given2LinesAnd1Point_specialCase...
        (par_segTgt_1_Sta,par_baseSeg_Sta,touchingPoint_tgt_1,segPair,isBaseLeft)

% Convert the stand form to the slope-intercept form
par_tgtSeg_1_sI = standForm2sIForm(par_segTgt_1_Sta);
par_baseSeg_sI = standForm2sIForm(par_baseSeg_Sta);

% Judge if two segments are parallel
if abs(par_tgtSeg_1_sI(1,1) - par_baseSeg_sI(1,1))<0.0001
    % Find the line perpendicular to the tgtSeg_1 and passing the touching
    % point
    par_circleCenter_Sta = perpendicularLineFromPointAndLine_Sta(touchingPoint_tgt_1,par_segTgt_1_Sta);
    par_circleCenter_sI = standForm2sIForm(par_circleCenter_Sta);
    % Find the intersection point of the above perpendicular line and the
    % base segment
    p_int = intersectionFrom2Lines(par_circleCenter_sI,par_baseSeg_sI);
    % Find the circle centre
    x_centre = 0.5 * (touchingPoint_tgt_1(1,1) + p_int(1,1));
    y_centre = 0.5 * (touchingPoint_tgt_1(1,2) + p_int(1,2));
    p_centre = [x_centre y_centre];
    num_point = 1;
else % In the unparallel case
    % Find the intersection point of two borders
    p_int = intersectionFrom2Lines(par_baseSeg_sI,par_tgtSeg_1_sI);
    % Find the centrepoint of two borders
    tgtSeg_1 = segPair(1,:);
    baseSeg = segPair(3,:);
    x_c = (tgtSeg_1(1,1) + tgtSeg_1(1,3))/2;
    p_c = centrepointOf2Borders(baseSeg,par_baseSeg_Sta,tgtSeg_1,par_segTgt_1_Sta,x_c,isBaseLeft);  
    % Find the bisector line of the base and target_1 segments
    par_bisector_Sta = standardFormEquFrom2Points(p_int,p_c);
    par_bisector_sI = standForm2sIForm(par_bisector_Sta);    
    % Find the line perpendicular to the tgtSeg_1 and passing the touching
    % point
    par_circleCenter_Sta = perpendicularLineFromPointAndLine_Sta(touchingPoint_tgt_1,par_segTgt_1_Sta);
    par_circleCenter_sI = standForm2sIForm(par_circleCenter_Sta);
    % Find the circle centre
    p_centre = intersectionFrom2Lines(par_circleCenter_sI,par_bisector_sI);    
    num_point = 1;
end

end