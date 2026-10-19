% plotLanelets_withInversion - Plot the lanelet struct,with inversion.
%
% Syntax:  
%    plotLanelets_withInversion(lanelet,cntrLanelet)
%
% Input:
%    lanelet - the lanelet struct
%    num_lanelets - the lanelet number
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: originalLanelet.mat(optional)
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index

function plotLanelets_withInversion(lanelet,num_lanelets)
    
for idxLanelet = 1:num_lanelets
    % If a lanelet is empty, skip plotting.
    if isempty(lanelet(idxLanelet).leftBoundary)
        continue;
    end
    % Initialize point container
    numPoints_Left = lanelet(idxLanelet).leftBoundary.numPoints;
    numPoints_Right = lanelet(idxLanelet).rightBoundary.numPoints;
    Left_UTM_x = [];Left_UTM_y = [];
    Left_UTM_x_inverted = [];Left_UTM_y_inverted = [];
    Right_UTM_x = [];Right_UTM_y = [];
    Right_UTM_x_inverted = [];Right_UTM_y_inverted = [];
    Center_UTM_x = [];Center_UTM_y = [];

    for idxLeft = 1:numPoints_Left
        Left_UTM_x(idxLeft) = lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_x;
        Left_UTM_y(idxLeft) = lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_y;
        Left_UTM_x_inverted(idxLeft) = ...
            lanelet(idxLanelet).leftBoundary.points(numPoints_Left - idxLeft + 1).UTM_x;
        Left_UTM_y_inverted(idxLeft) = ...
            lanelet(idxLanelet).leftBoundary.points(numPoints_Left - idxLeft + 1).UTM_y;
    end

    for idxRight = 1:numPoints_Right
        Right_UTM_x(idxRight) = lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_x;
        Right_UTM_y(idxRight) = lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_y;
        Right_UTM_x_inverted(idxRight) = ...
            lanelet(idxLanelet).rightBoundary.points(numPoints_Right - idxRight + 1).UTM_x;
        Right_UTM_y_inverted(idxRight) = ...
            lanelet(idxLanelet).rightBoundary.points(numPoints_Right - idxRight + 1).UTM_y;
    end
    % Flip and invert the boundaries
    % The inversion policies are different between oneway and twoway road
    if lanelet(idxLanelet).isOneWay == 1
        % Invert the left boundary
        if lanelet(idxLanelet).leftBoundary.toBeInverted == 1
            leftBoundary_X = Left_UTM_x_inverted;
            leftBoundary_Y = Left_UTM_y_inverted;
            Flip_left = 0;
            Invert_left = 1;
        else
            leftBoundary_X = Left_UTM_x;
            leftBoundary_Y = Left_UTM_y;
            Flip_left = 0;
            Invert_left = 0;
        end
        
        % Invert the right boundary
        if lanelet(idxLanelet).rightBoundary.toBeInverted == 1
            rightBoundary_X = Right_UTM_x_inverted;
            rightBoundary_Y = Right_UTM_y_inverted;
            Flip_right = 0;
            Invert_right = 1;
        else
            rightBoundary_X = Right_UTM_x;
            rightBoundary_Y = Right_UTM_y;
            Flip_right = 0;
            Invert_right = 0;
        end
    else % isOneWay == 0
        if lanelet(idxLanelet).toBeFlipped == 0
            if lanelet(idxLanelet).leftBoundary.toBeInverted == 0
                leftBoundary_X = Left_UTM_x;
                leftBoundary_Y = Left_UTM_y;
                Flip_left = 0;
                Invert_left = 0;
            else
                leftBoundary_X = Left_UTM_x_inverted;
                leftBoundary_Y = Left_UTM_y_inverted;
                Flip_left = 0;
                Invert_left = 1;
            end

            if lanelet(idxLanelet).rightBoundary.toBeInverted == 0
                rightBoundary_X = Right_UTM_x;
                rightBoundary_Y = Right_UTM_y;
                Flip_right = 0;
                Invert_right = 0;
            else
                fprintf('An unexpected scenario occurs and the lanelet ID is d%\n',idxLanelet);                
                rightBoundary_X = Right_UTM_x_inverted;
                rightBoundary_Y = Right_UTM_y_inverted;
                Flip_right = 0;
                Invert_right = 1;
            end
        else % The left and right boundaries should be swapped/flipped
            if lanelet(idxLanelet).leftBoundary.toBeInverted == 1
                % Invert the left boundary then swap it with the right
                rightBoundary_X = Left_UTM_x_inverted;
                rightBoundary_Y = Left_UTM_y_inverted;
                % Flip_right here tells if the plotted right boundary is
                % swapped the left. Actually, it is the left boundary in 
                % original lanelet struct.
                Flip_right = 1;
                % If the toBeFlipped == 1,Invert_right means the left
                % boundary,which is swapped with the right,is inverted.
                Invert_right = 1;
            else
                rightBoundary_X = Left_UTM_x;
                rightBoundary_Y = Left_UTM_y;
                Flip_right = 1;
                Invert_right = 0;
            end

            if lanelet(idxLanelet).rightBoundary.toBeInverted == 1
                % Invert the right boundary then swap it with the left
                leftBoundary_X = Right_UTM_x_inverted;
                leftBoundary_Y = Right_UTM_y_inverted;
                Flip_left = 1;
                Invert_left = 1;
            else
                leftBoundary_X = Right_UTM_x;
                leftBoundary_Y = Right_UTM_y;
                Flip_left = 1;
                Invert_left = 0;
            end
        end
    end

    axis equal;
    title(['Lanelet number is ',num2str(num_lanelets)]); 
    % Plot left boundary: with identification of if it is inverted
    if Invert_left == 1
        plot(leftBoundary_X,leftBoundary_Y,':b','LineWidth',1);
        hold on;
    else
        plot(leftBoundary_X,leftBoundary_Y,'--b','LineWidth',1);
        hold on;
    end
    % Plot the direction of the border: start from 'o' to 'x' like an arrow
    if Flip_left == 1
        plot(leftBoundary_X(1),leftBoundary_Y(1),'ob','MarkerSize',7)
        hold on;
        plot(leftBoundary_X(numPoints_Right),leftBoundary_Y(numPoints_Right),'xb','MarkerSize',4);
        hold on;
    else
        plot(leftBoundary_X(1),leftBoundary_Y(1),'ob','MarkerSize',7)
        hold on;
        plot(leftBoundary_X(numPoints_Left),leftBoundary_Y(numPoints_Left),'xb','MarkerSize',4);
        hold on;
    end

    % Plot right boundary: with identification of if it is inverted
    if Invert_right == 1
        plot(rightBoundary_X,rightBoundary_Y,':r','LineWidth',1);
        hold on;
    else
        plot(rightBoundary_X,rightBoundary_Y,'--r','LineWidth',1);
        hold on;
    end
    % Plot the direction of the border: start from 'o' to 'x' like an arrow
    if Flip_right == 1
        plot(rightBoundary_X(1),rightBoundary_Y(1),'or','MarkerSize',7)
        hold on;
        plot(rightBoundary_X(numPoints_Left),rightBoundary_Y(numPoints_Left),'xr','MarkerSize',4);
        hold on;
    else
        plot(rightBoundary_X(1),rightBoundary_Y(1),'or','MarkerSize',7)
        hold on;
        plot(rightBoundary_X(numPoints_Right),rightBoundary_Y(numPoints_Right),'xr','MarkerSize',4);
        hold on;
    end
end

end