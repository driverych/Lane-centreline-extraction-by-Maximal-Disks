% centrepointOf2Borders - Calculate the centerpoint of two borders
%
% Line equation: 
%   Two-point form:       
%       (y - y1)/(y2 - y1) = (x - x1)/(x2 - x1)
%       (y2 - y1)x - (x2 - x1)y + y1(x2 - x1) - x1(y2 - y1) = 0
%   Stand form:
%       Ax + By + C = 0
%   Slope-intercept form: 
%       y = kx + b
%
% Syntax:  
%    p_c = centrepointOf2Borders(baseLine,targetLine,x_c,isBaseLeft)
%
% Input:
%    baseLine - the base line,[x_Start,y_Start,x_End,y_End,indexSeg]
%    targetLine - the target line,[x_Start,y_Start,x_End,y_End,indexSeg]
%    x_c - x coordinate of the centerpoint
%    isBaseLeft - if the base line is in the left border of the lane
%
% Output:
%    p_c - the position of the centerpoint
%
% Other m-files required: standardFormEquFrom2Points.m
%                         centrepointFrom2Lines.m
%                         isPointLeftOfLine.m
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% seg -> segment
% sta -> stand
% p -> position

function p_c = centrepointOf2Borders(baseLine,par_baseSeg_Sta,targetLine,par_targetSeg_Sta,x_c,isBaseLeft)

% line array: [x_start,y_start,x_end,y_end,indexSeg]
p_c_candidate = centrepointFrom2Lines(par_baseSeg_Sta,par_targetSeg_Sta,x_c);
% Pay attention to the left and right border here
% Two points are found through centrepointFrom2Lines function. One is
% between two lines while the other not.Retain the point that is inbetween
if isBaseLeft == 1
    pointIsLeftOfleftBorder = isPointLeftOfLine(p_c_candidate(1,1:2),baseLine);
    pointIsLeftOfRightBorder = isPointLeftOfLine(p_c_candidate(1,1:2),targetLine);
else
    pointIsLeftOfleftBorder = isPointLeftOfLine(p_c_candidate(1,1:2),targetLine);
    pointIsLeftOfRightBorder = isPointLeftOfLine(p_c_candidate(1,1:2),baseLine);
end

if pointIsLeftOfleftBorder == 0 && pointIsLeftOfRightBorder == 1
    y_c = p_c_candidate(1,2);
elseif pointIsLeftOfleftBorder == 1 && pointIsLeftOfRightBorder == 0
    y_c = p_c_candidate(1,2);
else
    y_c = p_c_candidate(2,2);
end
p_c = [x_c,y_c];
    
end