% buildConsecutiveLanes - Combine the boundaries of separate lanelets
%                         into consecutive lane borders
%
% Syntax:  
%    laneList = buildConsecutiveLanes(index_laneLaneletsContainer,alignedLanelet)
%
% Input:
%    alignedLanelet - The lanelet struct with boundaries aligned
%    idxContainer_laneLanelets - A list storing indexes of all lane
%                                lanelets.
%
% Output:
%    laneList - the lane struct
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cand -> candidate
% cntr -> counter
% num -> number
% idx -> index
% id -> identification
% s -> start
% e -> end

% A simple example of the idxContainer_laneLanelets
% lanelet_idx lanelet_idx lanelet_idx lanelet_idx lanelet_idx lanelet_idx
%      3          135         58          50          47          43
%      3          135         61         140           8          73
%     116         114         54         121           0           0

function laneList = buildConsecutiveLanes(idxContainer_laneLanelets,alignedLanelet)

% Get the lane number and the maximal length of the lane
[num_lanes,num_laneLanelets] = size(idxContainer_laneLanelets);

% combine borders lane by lane
for idx_lane = 1:num_lanes
    % Initiate idx_lanelet with the lane initial lanelet index
    idx_lanelet = idxContainer_laneLanelets(idx_lane,1);
    % The end phase (row or column) of idxContainer_laneLanelets is filled with zeros
    if idx_lanelet == 0
        break
    end 
    % Initiate the ID_lastPoint_left_inloop. Actually, it should be the
    % last point of the lanelet. But in initialization, the first point of 
    % the initial lanelet is used.
    % This last point will be matched with the first point of another
    % Lanelet to extend the lane.
    ID_lastPoint_left_inloop = alignedLanelet(idx_lanelet).leftBoundary.points(1).ID;
    % Initiate the first points of left and right lane borders
    laneList(idx_lane).leftBoundary.Points(1) = ...
                    alignedLanelet(idx_lanelet).leftBoundary.points(1);
    laneList(idx_lane).rightBoundary.Points(1) = ...
        alignedLanelet(idx_lanelet).rightBoundary.points(1);
    % The point counter of both borders
    cntr_leftPoints = 1;
    cntr_rightPoints = 1;

    for idx_laneLanelet = 1:num_laneLanelets
        % Extract the index (row index in Lanelet struct) of the lanelet 
        idx_lanelet = idxContainer_laneLanelets(idx_lane,idx_laneLanelet);
        if idx_lanelet == 0
            break
        end
        % The point numbers in the extracted Lanelet
        num_leftPoints = alignedLanelet(idx_lanelet).leftBoundary.numPoints;
        num_rightPoints = alignedLanelet(idx_lanelet).rightBoundary.numPoints;
        
        % Only one boundary info is used
        ID_sPoint_left_cand = ...
            alignedLanelet(idx_lanelet).leftBoundary.points(1).ID;
        
        % Set the initial lanelet's direction as the road direction
        %------------------------------------> L assumed driving direction
        %----------------> L ----------------> L
        %  >>> inloop         >>> candidate
        %----------------> R ----------------> R
        %------------------------------------> R assumed driving direction
        
        % Extend the lane borders
        % In the first loop,ID_lastPoint_left_inloop is the start point of
        % the initial lanelet, and ID_sPoint_left_cand is also the start
        % point of the initial lanelet.
        if ID_lastPoint_left_inloop == ID_sPoint_left_cand
            for idx_leftPoints = 2 : num_leftPoints
                cntr_leftPoints = cntr_leftPoints + 1;
                laneList(idx_lane).leftBoundary.Points(cntr_leftPoints) = ...
                    alignedLanelet(idx_lanelet).leftBoundary.points(idx_leftPoints);
            end

            for iterator_rightPoints = 2 : num_rightPoints
                cntr_rightPoints = cntr_rightPoints + 1;
                laneList(idx_lane).rightBoundary.Points(cntr_rightPoints) = ...
                    alignedLanelet(idx_lanelet).rightBoundary.points(iterator_rightPoints);
            end
            ID_lastPoint_left_inloop = ...
                alignedLanelet(idx_lanelet).leftBoundary.points(num_leftPoints).ID;
        end
        
        % Only one boundary info is used
        ID_ePoint_right_cand = ...
            alignedLanelet(idx_lanelet).rightBoundary.points(num_rightPoints).ID;
        
        % Set the initial lanelet's direction as the road direction
        %------------------------------------> L assumed driving direction
        %----------------> L <---------------- R
        %  >>> inloop          >>> candidate
        %----------------> R <---------------- L
        %------------------------------------> R assumed driving direction            
        if ID_lastPoint_left_inloop == ID_ePoint_right_cand
            for idx_leftPoints = 2 : num_rightPoints
                cntr_leftPoints = cntr_leftPoints + 1;
                laneList(idx_lane).leftBoundary.Points(cntr_leftPoints) = ...
                    alignedLanelet(idx_lanelet).rightBoundary.points(num_rightPoints - idx_leftPoints + 1);
            end

            for iterator_rightPoints = 2:num_leftPoints
                cntr_rightPoints = cntr_rightPoints + 1;
                laneList(idx_lane).rightBoundary.Points(cntr_rightPoints) = ...
                    alignedLanelet(idx_lanelet).leftBoundary.points(num_leftPoints - iterator_rightPoints + 1);
            end
            ID_lastPoint_left_inloop = ...
                alignedLanelet(idx_lanelet).rightBoundary.points(1).ID;
        end

    end

end

end