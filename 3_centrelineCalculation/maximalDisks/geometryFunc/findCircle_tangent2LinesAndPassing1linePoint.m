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

function [p_circleCenter,radius] = findCircle_tangent2LinesAndPassing1linePoint(baseLine,targetLine,pointOnCircle,isBaseLeft)
    % Initiate the line equation
    par_baseSeg_Sta = ...
        standardFormEquFrom2Points(baseLine(1:2),baseLine(3:4));
    par_baseSeg_sI = standForm2sIForm(par_baseSeg_Sta);
    % Find the intersection point of two borders
    par_targetSeg_Sta = ...
        standardFormEquFrom2Points(targetLine(1:2),targetLine(3:4));
    par_targetSeg_sI = standForm2sIForm(par_targetSeg_Sta);
    p_int = intersectionFrom2Lines(par_baseSeg_sI,par_targetSeg_sI);
    % Find the centrepoint of two borders
    x_c = (targetLine(1) + targetLine(3))/2;
    p_c = centrepointOf2Borders(baseLine,targetLine,x_c,isBaseLeft);
    % Find the bisector line of two borders
    par_bisector_Sta = standardFormEquFrom2Points(p_int,p_c);
    par_bisector_pS = standForm2sIForm(par_bisector_Sta);
    % Find the circle centre
    par_circleCenter_Sta = perpendicularLineFromPointAndLine_Sta(pointOnCircle,par_baseSeg_Sta);
    par_circleCenter_sI = standForm2sIForm(par_circleCenter_Sta);
    p_circleCenter = intersectionFrom2Lines(par_circleCenter_sI,par_bisector_pS);
    % The two methods to calcualte the radius are the same but there is a
    % little difference between two reults,with 99.99% similarity
%     radius = distancePoint2Point(p_circleCenter,pointOnCircle);
    radius = distancePoint2Line(p_circleCenter,par_targetSeg_Sta);

end