% checkBorderOrien - check if the borders of a lanelet should be inverted 
%                    or flipped and store this information into the lanelet struct
%
% Syntax:  
%    lanelet_out = checkBorderOrien(lanelet_in,cntrLanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    cntrLanelet - the lanelet counter
%
% Output:
%    lanelet_out - the lanelet struct
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% elem -> element
% num -> number
% bdy -> boundary
% idx -> index
% id -> identification
% S -> start
% E -> end

% =========================================================================
% The Method used to identify if the border's orientation is correct or not
% =========================================================================

% Cross product is used to judge if a point is left of a oriented line
% Take an example: C(0,2)is out of a line, which starts with A(1,0) and
% ends up with B(-1,0)
% If (B.x-A.x)*(C.y-A.y)-(B.y-A.y)*(C.x-A.x)>0
% Then C is left of line AB
% Else C is right of line AB

% =========================================================================
%                         Graphical Representation
% =========================================================================

%----------------> L
%      >>>
%----------------> R
% L isLeft of R(yes) and R isLeft of L(no)
% No boundaries should be inverted

%----------------> L
%      >>>
%<---------------- R
% L isLeft of R(no) and R isLeft of L(no)
% Right boundary should be inverted

%<---------------- L
%      >>>
%<---------------- R
% L isLeft of R(no) and R isLeft of L(yes)
% Both boundaries should be inverted

%<---------------- L
%      >>>
%----------------> R
% L isLeft of R(yes) and R isLeft of L(yes)
% Left boundary should be inverted


function lanelet_out = checkBorderOrien(lanelet_in,cntrLanelet)

    % Might to be improved here
    numPoints_left = lanelet_in(cntrLanelet).leftBoundary.numPoints;
    x_midLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2)).UTM_x;
    y_midLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2)).UTM_y;
    if numPoints_left > 6
        x_startLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2) - 1).UTM_x;
        y_startLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2) - 1).UTM_y;
        x_endLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2) + 1).UTM_x;
        y_endLeft = lanelet_in(cntrLanelet).leftBoundary.points(ceil(numPoints_left/2) + 1).UTM_y;
    else
        x_startLeft = lanelet_in(cntrLanelet).leftBoundary.points(1).UTM_x;
        y_startLeft = lanelet_in(cntrLanelet).leftBoundary.points(1).UTM_y;
        x_endLeft = lanelet_in(cntrLanelet).leftBoundary.points(numPoints_left).UTM_x;
        y_endLeft = lanelet_in(cntrLanelet).leftBoundary.points(numPoints_left).UTM_y;
    end

    numPoints_right = lanelet_in(cntrLanelet).rightBoundary.numPoints;
    x_midRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2)).UTM_x;
    y_midRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2)).UTM_y;
    if numPoints_right > 6
        x_startRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2) - 1).UTM_x;
        y_startRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2) - 1).UTM_y;
        x_endRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2) + 1).UTM_x;
        y_endRight = lanelet_in(cntrLanelet).rightBoundary.points(ceil(numPoints_right/2) + 1).UTM_y;
    else    
        x_startRight = lanelet_in(cntrLanelet).rightBoundary.points(1).UTM_x;
        y_startRight = lanelet_in(cntrLanelet).rightBoundary.points(1).UTM_y;
        x_endRight = lanelet_in(cntrLanelet).rightBoundary.points(numPoints_right).UTM_x;
        y_endRight = lanelet_in(cntrLanelet).rightBoundary.points(numPoints_right).UTM_y;
    end

    leftIsLeftOfRight = (((x_endRight-x_startRight)*(y_midLeft-y_startRight)-...
        (y_endRight-y_startRight)*(x_midLeft-x_startRight))>0);

    rightIsLeftOfleft = (((x_endLeft-x_startLeft)*(y_midRight-y_startLeft)-...
        (y_endLeft-y_startLeft)*(x_midRight-x_startLeft))>0);

    lanelet_out = lanelet_in;

    if lanelet_in(cntrLanelet).isOneWay == 1
        if (leftIsLeftOfRight==1 && rightIsLeftOfleft==0)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('No boundary should be inverted or flipped\n');
        elseif (leftIsLeftOfRight==0 && rightIsLeftOfleft==0)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('The right boundary should be inverted,without flipping\n');
        elseif (leftIsLeftOfRight==1 && rightIsLeftOfleft==1)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('The left boundary should be inverted,without flipping\n');
        elseif (leftIsLeftOfRight==0 && rightIsLeftOfleft==1)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('Both boundaries should be inverted,without flipping\n');
        else
            fprintf('An unexpected scenario occurs in aligning borders\n');
        end
    elseif lanelet_in(cntrLanelet).isOneWay == 0
        if (leftIsLeftOfRight==1 && rightIsLeftOfleft==0)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('No boundary should be inverted or flipped\n')
        elseif (leftIsLeftOfRight==0 && rightIsLeftOfleft==0)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 1;
            fprintf('The left boundary should be inverted and then both flipped\n');
        elseif (leftIsLeftOfRight==1 && rightIsLeftOfleft==1) 
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 1;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 0;
            fprintf('The left boundary should be inverted,without flipping\n');
        elseif (leftIsLeftOfRight==0 && rightIsLeftOfleft==1)
            lanelet_out(cntrLanelet).leftBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).rightBoundary.toBeInverted = 0;
            lanelet_out(cntrLanelet).toBeFlipped = 1;
            fprintf('Two boundaries should be flipped, without inversion\n');
        else
            fprintf('An unexpected scenario occurs in aligning borders\n');
        end
    else
        fprintf('An unexpected scenario occurs in aligning borders\n');
    end
end

