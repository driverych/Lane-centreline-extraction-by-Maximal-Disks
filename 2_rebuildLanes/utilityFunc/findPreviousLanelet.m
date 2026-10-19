% findPreviousLanelet - Find the left and right boundaries whose 
%                       end points's ID is the same as the start
%                       points's of the current lanelet. And return 
%                       the lanelet ID who owns that left and right 
%                       boundaries. If no previous lanelet is found, 
%                       return the ID of the current initial lanelet ID.
%
% Syntax:  
%    [lanelet_out,prevLanelet] = findPreviousLanelet(lanelet_in,lanelet_inloop)
%
% Input:
%    lanelet_in - the lanelet struct
%    lanelet_inloop - the imported single lanelet, of which a previous
%                     lanelet is to be found
%
% Output:
%    lanelet_out - the lanelet struct
%    prevLanelet - the found previous lanelet
%
% Other m-files required: getLeftStartPointID.m getRightStartPointID.m
%                         getLeftEndPointID.m   getRightEndPointID.m
% Subfunctions: getLeftStartPointID, getRightStartPointID
%               getLeftEndPointID, getRightEndPointID
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% cand -> candidate
% prev -> previous
% num -> number
% idx -> index
% id -> identification
% s -> start
% e -> end

function [lanelet_out,prevLanelet] = ...
    findPreviousLanelet(lanelet_in,lanelet_inloop)

    % Initialize the information of the inloop lanelet
    idx_Lanelet_inloop = lanelet_inloop.idx;
    ID_sPoint_left_inloop = lanelet_inloop.ID_sPoint_left;
    ID_sPoint_right_inloop = lanelet_inloop.ID_sPoint_right;
    
    % Initialize the outputs: if no previous lanelet is found, then the
    % input will become the ouptput directly
    prevLanelet = lanelet_inloop;
    lanelet_out = lanelet_in;
    
    numLanelets = numel(lanelet_in);
    % the candidate lanelet is the potential previous lanelet
    for idx_candLanelet = 1:numLanelets
        
        % Find its endpoint of a candidate lanelet
        ID_sPoint_left_cand = getLeftStartPointID(lanelet_in,idx_candLanelet);
        ID_sPoint_right_cand = getRightStartPointID(lanelet_in,idx_candLanelet);        
        ID_ePoint_left_cand = getLeftEndPointID(lanelet_in,idx_candLanelet);
        ID_ePoint_right_cand = getRightEndPointID(lanelet_in,idx_candLanelet);
        % Judge if the candidate lanelet is actually a previous lanelet
        if lanelet_in(idx_Lanelet_inloop).isOneWay == 1
            %------------------------------------> L driving direction
            %----------------> L ----------------> L
            %  >>> candidate        >>> inloop
            %----------------> R ----------------> R
            %------------------------------------> R driving direction
            isLeftLinked = (ID_ePoint_left_cand == ID_sPoint_left_inloop);
            isRightLinked = (ID_ePoint_right_cand == ID_sPoint_right_inloop);
            
            % Store the candidate lanelet ID as the previous lanelet ID 
            % if both left and right are linked
            if isLeftLinked && isRightLinked
                % A lanelet has only one previous lanelet, but could have
                % serveral succeeding lanelets
                prevLanelet.ID = lanelet_in(idx_candLanelet).ID;
                prevLanelet.idx = idx_candLanelet; 
                prevLanelet.ID_sPoint_left = ...
                    getLeftStartPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_sPoint_right = ...
                    getRightStartPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_left = ...
                    getLeftEndPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_right = ...
                    getRightEndPointID(lanelet_in,prevLanelet.idx); 

                % The previous lanelet is the parent of the inloop lanelet
                lanelet_out(idx_Lanelet_inloop).Parents.ID = prevLanelet.ID;
                lanelet_out(idx_Lanelet_inloop).Parents.index = prevLanelet.idx;
                
                % Its previous lanelet has been found
                break
            end
            
        else  % The expanded lanelet is bidirectional in this case
            
            % lanelets' R is different from roads' R. lanelets' R is from
            % candidate lanelet but roads' R is from inloop lanelet.  
            % When a new candidate lanelet is imported, road is the reference  
            % (Align the border with the road direction) 
            
            %------------------------------------> L assumed driving direction
            %----------------> L ----------------> L
            %  >>> candidate       >>> inloop
            %----------------> R ----------------> R
            %------------------------------------> R assumed driving direction
            isLeftLinked = (ID_ePoint_left_cand == ID_sPoint_left_inloop);
            isRightLinked = (ID_ePoint_right_cand == ID_sPoint_right_inloop);
            
            %------------------------------------> L assumed driving direction
            %<---------------- R ----------------> L
            %   candidate <<<      >>> inloop
            %<---------------- L ----------------> R
            %------------------------------------> R assumed driving direction
            isCandR_InloopLLinked = (ID_sPoint_right_cand == ID_sPoint_left_inloop);
            isCandL_InloopRLinked = (ID_sPoint_left_cand == ID_sPoint_right_inloop);

%             % Align the lanelet direction with referrence to the road direction,
%             % so the following two scenarios will not show up.
% 
%             %----------------> L <---------------- R 
%             %  >>> inloop          candidate <<< 
%             %----------------> R <---------------- L 
%             %<------------------------------------ assumed driving direction
%             isInloopL_CandRLinked = (ID_endPoint_left_inloop == ID_endPoint_right_candidate);
%             isInloopR_CandLLinked = (ID_endPoint_right_inloop == ID_endPoint_left_candidate);
% 
%             %----------------> L ----------------> L 
%             %  >>> inloop         candidate >>>
%             %----------------> R ----------------> R 
%             %<------------------------------------ assumed driving direction
%             isInloopL_CandLLinked = (ID_endPoint_left_inloop == ID_startPoint_left_candidate);
%             isInloopR_CandRLinked = (ID_endPoint_right_inloop == ID_startPoint_right_candidate);

            if (isLeftLinked && isRightLinked)
                % Update information of the previous lanelet
                prevLanelet.ID = lanelet_in(idx_candLanelet).ID;
                prevLanelet.idx = idx_candLanelet;
                prevLanelet.ID_sPoint_left = ...
                    getLeftStartPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_sPoint_right = ...
                    getRightStartPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_left = ...
                    getLeftEndPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_right = ...
                    getRightEndPointID(lanelet_in,prevLanelet.idx); 
                % Update the lanelet
                lanelet_out(idx_Lanelet_inloop).Parents.ID = prevLanelet.ID;
                lanelet_out(idx_Lanelet_inloop).Parents.index = prevLanelet.idx;
                break
            end
            
            if (isCandR_InloopLLinked && isCandL_InloopRLinked)
                % Update information of the previous lanelet
                prevLanelet.ID = lanelet_in(idx_candLanelet).ID;
                prevLanelet.idx = idx_candLanelet;
                % Align the lanelet borders according to the road direction
                prevLanelet.ID_sPoint_left = ...
                    getRightEndPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_sPoint_right = ...
                    getLeftEndPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_left = ...
                    getRightStartPointID(lanelet_in,prevLanelet.idx);
                prevLanelet.ID_ePoint_right = ...
                    getLeftStartPointID(lanelet_in,prevLanelet.idx);
                % Update the lanelet
                lanelet_out(idx_Lanelet_inloop).Parents.ID = prevLanelet.ID;
                lanelet_out(idx_Lanelet_inloop).Parents.index = prevLanelet.idx;
                break
            end
      
        end
  
     end
end


% The necessirity of two borders' information is uesd is demonstrated as
% follows

%<---------------- R 
%  <<< adjacent 
%----------------> L
%  >>> inloop          
%----------------> R 

