 % findFollowingLanelet - Find all children of a lanelet (the inloop lanelet)
%
% Syntax:  
%    [idxs_list_out,IDs_list_out,invertFlag_list_out,idxTable_out,ID_Table_out,cntrTable_out,lanelet_out,tableInfo]
%     = findFollowingLanelet(lanelet_in,laneletInLoop,tableInfo,idxChd,idxs_list_in,IDs_list_in,invertFlag_list_in,idxTable_in,ID_Table_in,cntrTable_in)
%
% Input:
%    lanelet_in - the lanelet struct
%    laneletInLoop - a struct for a single lanelet,containing
%                    index,invertFlag and hasChildren flag
%    tableInfo - a struct for table info,containing current row number, 
%                current column number,max row number and max column
%                number
%    idxLanelet - the index of the lanelet in the column
%    idxs_list_in - the same with output
%    IDs_list_in - the same with output
%    invertFlag_list_in - the same with output
%    idxTable_in - the same with output
%    ID_Table_in - the same with output
%    cntrTable_in - the same with output
%
% Output:
%    lanelet_out - the lanelet struct
%    idxs_list_out - A list to store indexes of all children of all candidates
%    IDs_list_out - A list to store IDs of all children of all candidates
%    invertFlag_list_out - A list to store a flag, which indicates if found
%                          children's both boundaries should be inverted 
%                          (this only happens in the two-way lanelet)
%    idxTable_out - A table to store all index information of lanes
%    ID_Table_out - A table to store all ID information of lanes
%    cntrTable_out - A table to store information, which indicates how many 
%                    children has been found of a lanelet
%    lanelet_out - the lanelet struct
%    tableInfo - a struct for table info,containing current row number, 
%                current column number,max row number and max column
%                number
%
% Other m-files required: getLeftStartPointID.m getRightStartPointID.m
%                         getLeftEndPointID.m   getRightEndPointID.m
%                         findPreviousLanelet.m storeInitialLaneletID.m
% Subfunctions: getLeftStartPointID getRightStartPointID
%               getLeftEndPointID   getRightEndPointID
%               findPreviousLanelet storeInitialLaneletID
% MAT-files required: none
% Abbreviation:
% cand -> candidate
% cntr -> counter
% curr -> current
% num -> number
% idx -> index
% chd -> children
% col -> column
% id -> identification
% s -> start
% e -> end


% Examples of a ID table and its corresponding ID list (under updating): 
%
%                                                       Lanelet  newly-found
%                                                       inloop    children
%                                                      (colNum)  (colNum+1)
%                 __________________________________________________________
%                  -1766582    -1766720    -1766681    -1766676   -1766675
% (rowNum) ->                  -1766721    -1766715    -1766677       *
% (maxRow) ->                              -1766722    -1766723       *
%                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%                                                                     |
%                                                                     ∨
%                                                                  ID list
%
% An example of the counter table (under updating):
%                                                     (colNum)
%                  _______________________________________________
% (idxLanelet) ->       2          2           1          2
%                                  1           1          *
%                                              1          *
%                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% FYI: the ID table and the counter table are related


function [idxs_list_out,IDs_list_out,invertFlag_list_out,...
    idxTable_out,ID_Table_out,cntrTable_out,lanelet_out,tableInfo] = ...
        findFollowingLanelet(lanelet_in,laneletInLoop,tableInfo,idxLanelet,...
            idxs_list_in,IDs_list_in,invertFlag_list_in,...
            idxTable_in,ID_Table_in,cntrTable_in)
        
% The row infos between the list and the table are the same because the
% list is one column of the table

% Table/list info
% ATTENTION: The column numbers of the idx/ID table and the counter table
% are different; idx/ID table have one more column than the counter table.
% The tableInfo here is using the column number of the counter table.
rowNum = tableInfo.currRow; % not starting from zero
colNum = tableInfo.currCol;
maxRow = tableInfo.maxRow;

% Lanelet info    
idxLanelet_inloop = laneletInLoop.index;
invertFlag = laneletInLoop.invertFlag;
hasChildren = laneletInLoop.hasChildren;  

% Initiate output
lanelet_out = lanelet_in;
idxs_list_out = idxs_list_in;
IDs_list_out = IDs_list_in;
invertFlag_list_out = invertFlag_list_in;
idxTable_out = idxTable_in;
ID_Table_out = ID_Table_in;
cntrTable_out = cntrTable_in;

% Initiate children counter
% This counter is defined for the inloop lanelet only, which means it
% will be reset to zero at the beginning of this function 
% (it indicates how many children the inloop lanelet has)
cntrChd = 0;

if idxLanelet_inloop == 0
   hasChildren = 0;        
else
    % Extract extreme points of the inloop lanelet
    % If invertFlag == 0, the direction of the inloop lanelet should be
    % inverted
    if invertFlag == 0
        ID_ePoint_left_inloop = getLeftEndPointID(lanelet_in,idxLanelet_inloop);
        ID_ePoint_right_inloop = getRightEndPointID(lanelet_in,idxLanelet_inloop);  
    else
        ID_ePoint_left_inloop = getRightStartPointID(lanelet_in,idxLanelet_inloop);
        ID_ePoint_right_inloop = getLeftStartPointID(lanelet_in,idxLanelet_inloop);
    end

    numLanelet = numel(lanelet_in);
    for idx_candLanelet = 1:numLanelet
        % Extract the extreme points of a candidate lanelet
        ID_sPoint_left_cand = getLeftStartPointID(lanelet_in,idx_candLanelet);
        ID_sPoint_right_cand = getRightStartPointID(lanelet_in,idx_candLanelet);        
        ID_ePoint_left_cand = getLeftEndPointID(lanelet_in,idx_candLanelet);
        ID_ePoint_right_cand = getRightEndPointID(lanelet_in,idx_candLanelet);

        if lanelet_in(idxLanelet_inloop).isOneWay == 1
            %------------------------------------> L driving direction
            %----------------> L ----------------> L
            %   >>> inloop        >>> candidate
            %----------------> R ----------------> R
            %------------------------------------> R driving direction
            isLeftLinked = (ID_ePoint_left_inloop == ID_sPoint_left_cand);
            isRightLinked = (ID_ePoint_right_inloop == ID_sPoint_right_cand);

            if isLeftLinked && isRightLinked
                % A child has been found
                hasChildren = 1;
                cntrChd = cntrChd + 1;
                rowNum = rowNum + 1;
                % Store the ID,index and invertFlag in separate lists
                idxs_list_out(rowNum) = idx_candLanelet;
                IDs_list_out(rowNum) = lanelet_in(idx_candLanelet).ID;
                invertFlag_list_out(rowNum) = 0;
                % Store children information in the lanelet struct
                lanelet_out(idxLanelet_inloop).Children(cntrChd).index = idx_candLanelet;
                lanelet_out(idxLanelet_inloop).Children(cntrChd).ID = lanelet_in(idx_candLanelet).ID;
                % Store index and ID in the table (a new column)
                idxTable_out(rowNum,colNum + 1) = idx_candLanelet;
                ID_Table_out(rowNum,colNum + 1) = lanelet_in(idx_candLanelet).ID;
%                 % Plot the found lanelet
%                 plotSingleLanelet(lanelet_in,idx_candLanelet);
%                 hold on;
            end
        else  % The expanded lanelet is bidirectional in this case

            % lanelets' R is different from roads' R. lanelets' R is from
            % candidate lanelet but roads' R is from inloop lanelet.  
            % When a new candidate lanelet is imported, road is the reference  
            % (Align the border with the road direction) 

            %------------------------------------> L assumed driving direction
            %----------------> L ----------------> L
            %   >>> inloop        >>> candidate
            %----------------> R ----------------> R
            %------------------------------------> R assumed driving direction
            isLeftLinked = (ID_ePoint_left_inloop == ID_sPoint_left_cand);
            isRightLinked = (ID_ePoint_right_inloop == ID_sPoint_right_cand);

            %------------------------------------> L assumed driving direction
            %----------------> L <---------------- R
            %   >>> inloop         <<< candidate
            %----------------> R <---------------- L
            %------------------------------------> R assumed driving direction
            isInloopL_CandRLinked = (ID_ePoint_left_inloop == ID_ePoint_right_cand);
            isInloopR_CandLLinked = (ID_ePoint_right_inloop == ID_ePoint_left_cand);

            if (isLeftLinked && isRightLinked)
                hasChildren = 1;
                cntrChd = cntrChd + 1;
                rowNum = rowNum + 1;
                % Store the ID,index and invertFlag in separate lists
                idxs_list_out(rowNum) = idx_candLanelet;
                IDs_list_out(rowNum) = lanelet_in(idx_candLanelet).ID;
                invertFlag_list_out(rowNum) = 0;
                % Store children information in the lanelet struct
                lanelet_out(idxLanelet_inloop).Children(cntrChd).index = idx_candLanelet;
                lanelet_out(idxLanelet_inloop).Children(cntrChd).ID = lanelet_in(idx_candLanelet).ID;
                % Store index and ID in the table (a new column)
                idxTable_out(rowNum,colNum + 1) = idx_candLanelet;
                ID_Table_out(rowNum,colNum + 1) = lanelet_in(idx_candLanelet).ID;
%                 % Plot the found lanelet
%                 plotSingleLanelet(lanelet_in,idx_candLanelet);
%                 hold on;
            end

            if (isInloopR_CandLLinked && isInloopL_CandRLinked)
                hasChildren = 1;
                cntrChd = cntrChd + 1;
                rowNum = rowNum + 1;
                % Store the ID,index and invertFlag in separate lists
                idxs_list_out(rowNum) = idx_candLanelet;
                IDs_list_out(rowNum) = lanelet_in(idx_candLanelet).ID;
                invertFlag_list_out(rowNum) = 1;
                % Store children information in the lanelet struct
                lanelet_out(idxLanelet_inloop).Children(cntrChd).index = idx_candLanelet;
                lanelet_out(idxLanelet_inloop).Children(cntrChd).ID = lanelet_in(idx_candLanelet).ID;
                % Store index and ID in the table (a new column)
                idxTable_out(rowNum,colNum + 1) = idx_candLanelet;
                ID_Table_out(rowNum,colNum + 1) = lanelet_in(idx_candLanelet).ID;
%                 % Plot the found lanelet
%                 plotSingleLanelet(lanelet_in,idx_candLanelet);
%                 hold on;
            end
        end
    end
end


% No child has been found through the above process
if hasChildren == 0
    % If no following lanelets are found, return the input index and id
    % And in the next loop, the children will be itself
    % Although it has no children, its row is occupied by 0 for
    % further convinience
    cntrChd = cntrChd + 1;
    rowNum = rowNum + 1;

    idxs_list_out(rowNum) = 0;
    IDs_list_out(rowNum) = 0;
    invertFlag_list_out(rowNum) = 0;

    idxTable_out(rowNum,colNum + 1) = 0;
    ID_Table_out(rowNum,colNum + 1) = 0;
end

% The counter list
if hasChildren == 1
    cntrTable_out(idxLanelet,colNum) = cntrChd;
else
    cntrTable_out(idxLanelet,colNum) = 0;
end

% This indicates how many rows has occupied to store children info
if rowNum > maxRow
    tableInfo.maxRow = rowNum;
else
    tableInfo.maxRow = maxRow;
end

% The column infos of all tables are not changed in this subfunction
tableInfo.currRow = rowNum;

end



