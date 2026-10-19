% findInitialLanelets - Find all initial lanelets
%
% Syntax:  
%    [lanelet_out,IDs_inits,idxs_inits,cntr_inits] = findInitialLanelets(lanelet_in,twoWay_flag)
%
% Input:
%    lanelet_in - the lanelet struct
%    twoWay_flag - indicate if the lanelet is bidirectional
%
% Output:
%    lanelet_out - the lanelet struct
%    IDs_inits - a container to store all initial lanelets' IDs
%    idxs_inits - a container to store all initial lanelets' indexes
%    cntr_inits - a counter to indicate the number of found initial lanelets
%
% Other m-files required: getLeftStartPointID.m getRightStartPointID.m
%                         getLeftEndPointID.m   getRightEndPointID.m
%                         findPreviousLanelet.m storeInitialLaneletID.m
% Subfunctions: getLeftStartPointID getRightStartPointID
%               getLeftEndPointID   getRightEndPointID
%               findPreviousLanelet storeInitialLaneletID
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% init -> initial
% curr -> current
% prev -> previous
% num -> number
% idx -> index
% id -> identification
% s -> start
% e -> end

% The logic of the method is as following:
% from current lanelet to its previous lanelets, from a previous lanelet
% to its initial lanelet: current(inloop) ----> previous ----> initial
function [lanelet_out,IDs_inits,idxs_inits,cntr_inits] = findInitialLanelet(lanelet_in,skipOneWay)

numLanelets = numel(lanelet_in);
% Initialize the counter of the initial lanelets
cntr_inits = 0;
% Initialize a container to store initial lanelets' IDs and indexes
IDs_inits = zeros(20,1);
idxs_inits = zeros(20,1);

% Find the 'initial lanelet' of the 'current lanelet'
for idx_currLanelet = 1:numLanelets
    
    if lanelet_in(idx_currLanelet).isOneWay == skipOneWay
        continue
    end
    
    % Initialize the isInitial flag of the current lanelet
    lanelet_in(idx_currLanelet).isInitial = 0;
    % Get start and end points' IDs of the current lanelet left and right
    % boundaries
    ID_currLanelet = lanelet_in(idx_currLanelet).ID;
    ID_sPoint_left_curr = getLeftStartPointID(lanelet_in,idx_currLanelet);
    ID_sPoint_right_curr = getRightStartPointID(lanelet_in,idx_currLanelet);
    ID_ePoint_left_curr = getLeftEndPointID(lanelet_in,idx_currLanelet);
    ID_ePoint_right_curr = getRightEndPointID(lanelet_in,idx_currLanelet);

    % Initialize initial lanelet's ID (the assumption is that the current 
    % lanelet is the initial lanelet)
    ID_init = ID_currLanelet;
    idx_init = idx_currLanelet;

    % Initiate inloop lanelet information. Its contents will change during
    % loops (ID and index)
    % The borders have been inverted and flipped
    lanelet_inloop.ID = ID_currLanelet;
    lanelet_inloop.idx = idx_currLanelet;
    lanelet_inloop.ID_sPoint_left = ID_sPoint_left_curr;
    lanelet_inloop.ID_sPoint_right = ID_sPoint_right_curr;
    lanelet_inloop.ID_ePoint_left = ID_ePoint_left_curr;
    lanelet_inloop.ID_ePoint_right = ID_ePoint_right_curr;

    % Find the previous lanelet until it reaches the initial lanelet
    % The max iterator is actually smaller than the number of all lanelets
    for idx_lanelet = 1:numLanelets
        
        % A previous lanelet will be found through this function
        [lanelet_in,prevLanelet] = findPreviousLanelet(lanelet_in,lanelet_inloop);
        % If ID_initLanelet == ID_prevLanlet (no new previous lanelet is found), 
        % then the initial lanelet is found.
        % If ID_initLanelet ~= ID_prevLanlet, an no-initial lanelet is
        % found instead.
        if ID_init == prevLanelet.ID
            [IDs_inits,idxs_inits,cntr_inits] = ... 
                storeInitialLaneletID(IDs_inits,idxs_inits,cntr_inits,ID_init,idx_init);
            lanelet_in(idx_init).isInitial = 1;
            break
        else
            % The found lanelet is not an initial lanelet
            % Update initial lanelet information
            ID_init = prevLanelet.ID; 
            idx_init = prevLanelet.idx;
            % Update inloop lanlet information
            lanelet_inloop.ID = prevLanelet.ID; 
            lanelet_inloop.idx = prevLanelet.idx;
            lanelet_inloop.ID_sPoint_left = prevLanelet.ID_sPoint_left;
            lanelet_inloop.ID_sPoint_right = prevLanelet.ID_sPoint_right;
            lanelet_inloop.ID_ePoint_left = prevLanelet.ID_ePoint_left;
            lanelet_inloop.ID_ePoint_right = prevLanelet.ID_ePoint_right;            
            % Update lanelet information (the found previous lanelet is 
            % not the initial lanelet)
            lanelet_in(prevLanelet.idx).isInitial = 0;
        end

    end 
end

lanelet_out = lanelet_in;

end

