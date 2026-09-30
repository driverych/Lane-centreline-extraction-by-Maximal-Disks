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
    findInscribedCircle_passing3Points(basePoint,point_segTgt_1,point_segTgt_2)

    % Initiate the line equation
    par_baseTgt1_Sta = ...
        standardFormEquFrom2Points(basePoint,point_segTgt_1);
%     par_baseTgt1_sI = standForm2sIForm(par_baseTgt1_Sta);
    
    par_baseTgt2_Sta = ...
        standardFormEquFrom2Points(basePoint,point_segTgt_2);
%     par_baseTgt2_sI = standForm2sIForm(par_baseTgt2_Sta);    
    
    % Find the centrepoint of two borders
    x_midPoint_baseTgt1 = (basePoint(1,1) + point_segTgt_1(1,1))/2;
    y_midPoint_baseTgt1 = (basePoint(1,2) + point_segTgt_1(1,2))/2;
    midPoint_baseTgt1 = [x_midPoint_baseTgt1,y_midPoint_baseTgt1];
    
    x_midPoint_baseTgt2 = (basePoint(1,1) + point_segTgt_2(1,1))/2;
    y_midPoint_baseTgt2 = (basePoint(1,2) + point_segTgt_2(1,2))/2;
    midPoint_baseTgt2 = [x_midPoint_baseTgt2,y_midPoint_baseTgt2];    
    
    % Find the perpendicular lines of two segments
    par_perpen2BaseTgt1_Sta = perpendicularLineFromPointAndLine_Sta(midPoint_baseTgt1,par_baseTgt1_Sta);
    par_perpen2BaseTgt1_sI = standForm2sIForm(par_perpen2BaseTgt1_Sta);
    par_perpen2BaseTgt2_Sta = perpendicularLineFromPointAndLine_Sta(midPoint_baseTgt2,par_baseTgt2_Sta);
    par_perpen2BaseTgt2_sI = standForm2sIForm(par_perpen2BaseTgt2_Sta);

    % Find the circle centre
    p_circleCenter = intersectionFrom2Lines(par_perpen2BaseTgt1_sI,par_perpen2BaseTgt2_sI);
    % The two methods to calcualte the radius are the same but there is a
    % little difference between two reults,with 99.99% similarity
    radius = distancePoint2Point(p_circleCenter,basePoint);
    proj_CC2Tgt_1 = point_segTgt_1;
    proj_CC2Tgt_2 = point_segTgt_2;
    proj_CC2Base = basePoint;
    
    % * * * Plot the circle for test * * *
%     plotSingleCircle(p_circleCenter,radius,'#000000','#EDB120');
%     hold on; axis equal;      
%     line([p_circleCenter(1,1),proj_CC2Tgt_1(1,1)],[p_circleCenter(1,2),proj_CC2Tgt_1(1,2)]);
%     line([p_circleCenter(1,1),proj_CC2Tgt_2(1,1)],[p_circleCenter(1,2),proj_CC2Tgt_2(1,2)]);   
%     line([p_circleCenter(1,1),proj_CC2Base(1,1)],[p_circleCenter(1,2),proj_CC2Base(1,2)]);  
%     plot(basePoint(1,1),basePoint(1,2),'ro');
%     hold on
%     plot(point_segTgt_1(1,1),point_segTgt_1(1,2),'ro');
%     plot(point_segTgt_2(1,1),point_segTgt_2(1,2),'ro');
    

%     basePoint = [0 1];point_segTgt_1 = [0 10];point_segTgt_2 = [1 0];
%     [p_circleCenter,radius,proj_CC2Tgt_1,proj_CC2Tgt_2,proj_CC2Base] = ...
%     findInscribedCircle_passing3Points(basePoint,point_segTgt_1,point_segTgt_2);
%     

end