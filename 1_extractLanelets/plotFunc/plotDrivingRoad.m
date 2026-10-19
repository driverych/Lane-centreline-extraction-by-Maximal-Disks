% plotDrivingRoad - Plot the driving road,with inversion.
%
% Syntax:  
%    plotDrivingRoad(lanelet,num_lanelets,origin)
%
% Input:
%    lanelet - the lanelet struct
%    num_lanelets - the lanelet number
%    origin - the origin coordinates
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

function plotDrivingRoad(lanelet,num_lanelets,origin)

    % Plot the origin
    xUtmOrigin = origin.utm_x;
    yUtmOrigin = origin.utm_y;
    plot(xUtmOrigin,yUtmOrigin,'og');
    hold on

    cntrLanelet_drivingRoad = 0;
    for idxLanelet = 1:num_lanelets
        % If a lanelet is empty, skip plotting.
        if isempty(lanelet(idxLanelet).leftBoundary)
            continue;
        end
        % If a lanelet is for walking (two-way), skip plotting.
        if lanelet(idxLanelet).isOneWay == 0
            continue;
        end
        
        cntrLanelet_drivingRoad = cntrLanelet_drivingRoad + 1;
        % Initialize point container
        numPointsLeft = lanelet(idxLanelet).leftBoundary.numPoints;
        numPointsRight = lanelet(idxLanelet).rightBoundary.numPoints;
        Left_UTM_x = [];Left_UTM_y = [];
        Left_UTM_x_inverted = [];Left_UTM_y_inverted = [];
        Right_UTM_x = [];Right_UTM_y = [];
        Right_UTM_x_inverted = [];Right_UTM_y_inverted = [];

        for idxLeft = 1:numPointsLeft
            Left_UTM_x(idxLeft) = lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_x;
            Left_UTM_y(idxLeft) = lanelet(idxLanelet).leftBoundary.points(idxLeft).UTM_y;
            Left_UTM_x_inverted(idxLeft) = ...
                lanelet(idxLanelet).leftBoundary.points(numPointsLeft - idxLeft + 1).UTM_x;
            Left_UTM_y_inverted(idxLeft) = ...
                lanelet(idxLanelet).leftBoundary.points(numPointsLeft - idxLeft + 1).UTM_y;
        end

        for idxRight = 1:numPointsRight
            Right_UTM_x(idxRight) = lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_x;
            Right_UTM_y(idxRight) = lanelet(idxLanelet).rightBoundary.points(idxRight).UTM_y;
            Right_UTM_x_inverted(idxRight) = ...
                lanelet(idxLanelet).rightBoundary.points(numPointsRight - idxRight + 1).UTM_x;
            Right_UTM_y_inverted(idxRight) = ...
                lanelet(idxLanelet).rightBoundary.points(numPointsRight - idxRight + 1).UTM_y;
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
                    fprintf('An unexpected scenario occurs and the lanelet ID is d%\n',num_lanelets);
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
        
        axis equal
        title(['Lanelet number is ',num2str(cntrLanelet_drivingRoad)]); 
        % Plot left boundary: with identification of if it is inverted
        if Invert_left == 1
            plot(leftBoundary_X,leftBoundary_Y,':b');
            hold on
        else
            plot(leftBoundary_X,leftBoundary_Y,'--b');
            hold on
        end
        % Plot the direction of the border: start from 'o' to 'x' like an arrow
        if Flip_left == 1
            plot(leftBoundary_X(1),leftBoundary_Y(1),'ob','MarkerSize',7)
            hold on
            plot(leftBoundary_X(numPointsRight),leftBoundary_Y(numPointsRight),'xb','MarkerSize',4);
            hold on
        else
            plot(leftBoundary_X(1),leftBoundary_Y(1),'ob','MarkerSize',7)
            hold on
            plot(leftBoundary_X(numPointsLeft),leftBoundary_Y(numPointsLeft),'xb','MarkerSize',4);
            hold on
        end

        % Plot right boundary: with identification of if it is inverted
        if Invert_right == 1
            plot(rightBoundary_X,rightBoundary_Y,':r');
            hold on
        else
            plot(rightBoundary_X,rightBoundary_Y,'--r');
            hold on
        end
        % Plot the direction of the border: start from 'o' to 'x' like an arrow
        if Flip_right == 1
            plot(rightBoundary_X(1),rightBoundary_Y(1),'or','MarkerSize',7)
            hold on
            plot(rightBoundary_X(numPointsLeft),rightBoundary_Y(numPointsLeft),'xr','MarkerSize',4);
            hold on
        else
            plot(rightBoundary_X(1),rightBoundary_Y(1),'or','MarkerSize',7)
            hold on
            plot(rightBoundary_X(numPointsRight),rightBoundary_Y(numPointsRight),'xr','MarkerSize',4);
            hold on
        end
        
    end
    
    fprintf('The non-walking lanelet number is %d\n',cntrLanelet_drivingRoad);
    

end