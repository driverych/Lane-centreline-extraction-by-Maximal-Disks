% findSuccessiveLaneletsOfInitialLanelet - Find all successive lanelets of
%                                          a given initial lanelet
%
% Syntax:  
%    [lanelet_out,tableInfo,cntrTable,idxTable,IDTable] = ...
%    findSuccessiveLaneletsOfInitialLanelet(lanelet_in,idx_firstLanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    idx_firstLanelet - the index of the first/initial lanelet in the 
%                       lanelet struct
%
% Output:
%    lanelet_out - the lanelet struct
%    tableInfo - row and column infos of the built tables
%    cntrTable - a table to store child number info
%    idxTable - a table to store child index info
%    IDTable - a table to store child ID info
%
% Other m-files required: findFollowingLanelet.m
% Subfunctions: findFollowingLanelet
% MAT-files required: none
% Abbreviation:
% cand -> candidate
% cntr -> counter
% curr -> current
% prev -> previous
% chd -> children
% num -> number
% idx -> index
% col -> column
% id -> identification
% s -> start
% e -> end


% An example of a complete ID table:
%
% one initial lanelet
%        |
%        ∨
%   ______________________________________________________________________________________________________________________________________________
%   -1766582	-1766720	-1766681	-1766676	-1766675    -1766717    -1766584        0           0           0           0           0  
%               -1766721    -1766715    -1766677    -1766682    -1766694    -1766625    -1766621    -1766616    -1766614	-1766615        0 
%                           -1766722    -1766723    -1766678    -1766596    -1766728    -1766654    -1766665    -1766667        0           0            
%                                                   -1766680    -1766727    -1766728    -1766654    -1766665    -1766667        0           0   
%                                                   -1766581        0           0           0           0           0           0           0   
%                                                               -1766656    -1766661    -1766668    -1766592        0           0           0   
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%
% An example of a complete counter table:
%   _______________________________________________________________________________________________________________________________
%       2	        2	        1	        2	        1           1           0           0           0           0           0     
%                   1           1           2           1           1           1           1           1           1           0   
%                               1           1           2           1           1           1           1           0           0   
%                                                       0           1           1           1           1           0           0   
%                                                       1           0           0           0           0           0           0   
%                                                                   1           1           1           0           0           0   
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

function [lanelet_out,tableInfo,cntrTable,idxTable,IDTable] = ...
    findSuccessiveLaneletsOfInitialLanelet(lanelet_in,idx_firstLanelet)

% Initiate the tables to store lanelet IDs, indexes and counters
IDTable = zeros(80,30) * nan;
idxTable = zeros(80,30) * nan;
cntrTable = zeros(80,30) * nan;

% Initiate the list to store lanelet indexes and invertFlag info
% The list is one column of the table actually
idxLanelet_list = zeros(50,1);
invertFlag_lanelet_list = zeros(20,1);
% Initial the counter of the table row
maxRow_table = 0;

% Initiate the lanelet index list
% The first lanelet is the initial lanelet itself
% Lanelet indexes are put into this idxLanelet_list and then their 
% children will be found, stored in the following column
idxLanelet_list(1) = idx_firstLanelet;

% If invertFlag == 0, the lanelet direction will not be inverted
% Assume the road direction is same with the first lanelet's
invertFlag_lanelet_list(1) = 0;

% Number of all lanelets in a column (Children of the former column)
numLanelets_col = 1; 
% Initial the first element in the table
idxTable(maxRow_table + 1,1) = idx_firstLanelet;
IDTable(maxRow_table + 1,1) = lanelet_in(idx_firstLanelet).ID;

% The function is to find the children of the inloop lanelet
% The inloop lanelet is extracted from the lanelet_list
for curColr_table = 1:100
    % The row number indicates how many children have been found so far
    % This is reset in the beginning of every column
    rowNum_currCol = 0;
    
    % Initiate lists to store children's info
    idxChd_list = zeros(20,1);
    IDChd_list = zeros(20,1);
    invertFlag_chd_list = zeros(20,1);
    
    % Initiate table info struct
    tableInfo.currRow = rowNum_currCol;
    tableInfo.currCol = curColr_table;
    tableInfo.maxRow = maxRow_table;
    tableInfo.maxCol = curColr_table;
    
    % Find the children of the current lanelet listed in the 
    % idxLanelet_list
    for idxLanelet = 1:numLanelets_col
        % The idxLanelet will run through all the lanelets in the column
        laneletInLoop.index = idxLanelet_list(idxLanelet);
        laneletInLoop.invertFlag = invertFlag_lanelet_list(idxLanelet);
        
        % Initiate the hasChildren flag when begin to search following
        % lanelets, the default is hasChildren = 0            
        laneletInLoop.hasChildren = 0;

        % Find its following lanelets
        [idxChd_list,IDChd_list,invertFlag_chd_list,...
            idxTable,IDTable,cntrTable,lanelet_in,tableInfo] = ...
                findFollowingLanelet(lanelet_in,laneletInLoop,tableInfo,idxLanelet,...
                    idxChd_list,IDChd_list,invertFlag_chd_list,...
                    idxTable,IDTable,cntrTable);
    end
    
    % Update the number of lanelets in the new column
    numLanelets_col = tableInfo.currRow;
    
    % No new children have been found (of all lanelets in the column)
    if sum(idxChd_list ~= 0) == 0
        break
    end
    
    % Update the lanelets for next loop (these lanelets are children of
    % former column and in the next loop, they will be the parents )
    idxLanelet_list = idxChd_list;
    invertFlag_lanelet_list = invertFlag_chd_list;
end

lanelet_out = lanelet_in;
    
end

