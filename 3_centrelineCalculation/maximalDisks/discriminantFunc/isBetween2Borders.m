% isBetween2Borders - Judge if the point is between two borders
%
% Syntax:  
%    isBetweenBorders = isBetween2Borders(line_1,line_2,p_circleCenter,isBaseLeft,is2SegsOpposite)
%
% Input:
%    line_1 - the first line (the baseline)
%    line_2 - the second line (the target line)
%    p_circleCenter - coordinate of the circle center
%    isBaseLeft - indicate if the left border is the base segment
%    is2SegsOpposite - indicate if the two segments are opposite to each 
%                      other. If not, they are linked.
%
% Output:
%    isBetweenBorders - if the point is inbetween two borders
%
% Other m-files required: isPointLeftOfLine.m
% Subfunctions: isPointLeftOfLine
% MAT-files required: none
% Abbreviation:
% seg -> segment

function isBetweenBorders = isBetween2Borders(line_1,line_2,p_circleCenter,isBaseLeft,is2SegsOpposite)

% The base and target lines are converted into the left and right lines
if is2SegsOpposite == 1 % Case 1: 
    baseLine = line_1;
    targetLine = line_2;
    if isBaseLeft == 1
        leftBorder = baseLine;
        rightBorder = targetLine;
        centerIsLeftOfLeftBorder = isPointLeftOfLine(p_circleCenter,leftBorder);
        centerIsLeftOfRightBorder = isPointLeftOfLine(p_circleCenter,rightBorder);
        if centerIsLeftOfLeftBorder == 0 && centerIsLeftOfRightBorder == 1
            isBetweenBorders = 1;
        else
            isBetweenBorders = 0;
        end
    else
        leftBorder = targetLine;
        rightBorder = baseLine;
        centerIsLeftOfLeftBorder = isPointLeftOfLine(p_circleCenter,leftBorder);
        centerIsLeftOfRightBorder = isPointLeftOfLine(p_circleCenter,rightBorder);
        if centerIsLeftOfLeftBorder == 0 && centerIsLeftOfRightBorder == 1
            isBetweenBorders = 1;
        else
            isBetweenBorders = 0;
        end
    end
else % is2SegsOpposite ~= 1 % Case 2 and 3
    targetLine_1 = line_1;
    targetLine_2 = line_2;
    if isBaseLeft == 1
        rightBorder_1 = targetLine_1;
        rightBorder_2 = targetLine_2;
        centerIsLeftOfRightBorder_1 = isPointLeftOfLine(p_circleCenter,rightBorder_1);
        centerIsLeftOfRightBorder_2 = isPointLeftOfLine(p_circleCenter,rightBorder_2);
        if centerIsLeftOfRightBorder_1 == 1 && centerIsLeftOfRightBorder_2 == 1
            isBetweenBorders = 1;
        else
            isBetweenBorders = 0;
        end
    else
        leftBorder_1 = targetLine_1;
        leftBorder_2 = targetLine_2;
        centerIsLeftOfLeftBorder_1 = isPointLeftOfLine(p_circleCenter,leftBorder_1);
        centerIsLeftOfLeftBorder_2 = isPointLeftOfLine(p_circleCenter,leftBorder_2);
        if centerIsLeftOfLeftBorder_1 == 0 && centerIsLeftOfLeftBorder_2 == 0
            isBetweenBorders = 1;
        else
            isBetweenBorders = 0;
        end
    end
end

end