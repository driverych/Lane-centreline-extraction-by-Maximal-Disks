% buildLanesFromInitLanelet - Build a full-size lanelet table from the
%                             imported lanelet table.
%
% Syntax:  
%    [idxTable_lanes_out,IDTable_lanes_out] = ...
%    buildLanesFromInitLanelet(tableInfo,cntrTable_lanelet,idxTable_lanelet,IDTable_lanelet)
%
% Input:
%    tableInfo - row and column infos of the built tables
%    cntrTable_lanelet - a table to store child number info of lanelets
%    idxTable_lanelet - a table to store index info of lanelets
%    IDTable_lanelet - a table to store ID info of lanelets
%
% Output:
%    idxTable_lanes_out - a table to store lanelet index info of lanes
%    IDTable_lanes_out - a table to store lanelet ID info of lanes
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% curr -> current
% ptr -> pointer
% chd -> children
% col -> column

% An example of a complete laneelt ID table:
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
% An example of a complete lanelet counter table:
%   _______________________________________________________________________________________________________________________________
%       2	        2	        1	        2	        1           1           0           0           0           0           0     
%                   1           1           2           1           1           1           1           1           1           0   
%                               1           1           2           1           1           1           1           0           0   
%                                                       0           1           1           1           1           0           0   
%                                                       1           0           0           0           0           0           0   
%                                                                   1           1           1           0           0           0   
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%
% An example of a full size lane ID table:
%   _______________________________________________________________________________________________________________________________
%   -1766582	-1766720	-1766681	-1766676	-1766675    -1766717    -1766584        0           0           0           0  
%   -1766582    -1766720    -1766681    -1766676    -1766682    -1766694    -1766625    -1766621    -1766616    -1766614	-1766615
%   -1766582    -1766720    -1766715    -1766677    -1766678    -1766596    -1766728    -1766654    -1766665    -1766667        0
%   -1766582    -1766720    -1766715    -1766677    -1766678    -1766727    -1766728    -1766654    -1766665    -1766667        0
%   -1766582    -1766720    -1766715    -1766677    -1766680        0           0           0           0           0           0
%   -1766582    -1766721    -1766722    -1766723    -1766581    -1766656    -1766661    -1766668    -1766592        0           0
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%
% ATTENTION: The column numbers of the idx/ID table and the counter table
% are different; idx/ID table have one more column than the counter table.
% The tableInfo here is using the column number of the counter table.
% However, the last columns of ID and index tables are redundant for only
% zeros exist.

function [idxTable_lanes_out,IDTable_lanes_out] = ...
    buildLanesFromInitLanelet(tableInfo,cntrTable_lanelet,idxTable_lanelet,IDTable_lanelet)

maxRow = tableInfo.maxRow;
maxCol = tableInfo.maxCol;
% Initiate lane container/table
idxTable_lanes = zeros(maxRow,maxCol);
IDTable_lanes = zeros(maxRow,maxCol);
% This container/table is used to store how many children the current
% lanelet has and is updated on each new column
cntrTable_lanes = cntrTable_lanelet;

% The column numbers of the lanelet and lane are the same
for idxCol = maxCol:-1:1
    % The row pointer of the current column, start of current row
    rowPtr_currCol = 0;
    
    % Counter the number of lanelets in the current column, getting 
    % ready for finding children,which locates in the next column
    numLanelets = 0;
    for idxRow_currCol = 1:maxRow
        if (~isnan(idxTable_lanelet(idxRow_currCol,idxCol)))  
          numLanelets = numLanelets + 1;
        end
    end

    % If the row is full size, write down everything directly
    if numLanelets == maxRow
        for idxRow_currCol = 1:maxRow
            idxTable_lanes(idxRow_currCol,idxCol) = ...
                idxTable_lanelet(idxRow_currCol,idxCol);
            IDTable_lanes(idxRow_currCol,idxCol) = ...
                IDTable_lanelet(idxRow_currCol,idxCol);
        end
    else
        % Reset cntrTable_lanes in column idxCol
        cntrTable_lanes(:,idxCol) = 0;
        % The row pointer of the current column, at the end of current row
        rowPtr_currCol = rowPtr_currCol + 1;
        % The row pointer of the following column, at the start of row
        rowPtr_nextCol = 0;

        % Choose a current lanelet and count its children
        for idxRow_currCol = 1:numLanelets
            % How many children does the current lanelet have
            if cntrTable_lanelet(idxRow_currCol,idxCol) == 0
                numChd = 1;
            else
                numChd = cntrTable_lanelet(idxRow_currCol,idxCol);
            end

            % How many children does the child have
            for idxChd = 1:numChd
                % This will index the row of the following column
                rowPtr_nextCol = rowPtr_nextCol + 1;
                % Store the number of children in a container for
                % further use. If counter_laneletList() = 0, store 1;
                if cntrTable_lanes...
                        (rowPtr_nextCol,idxCol + 1) == 0
                    cntrChd = 1;
                else
                    cntrChd = ...
                        cntrTable_lanes...
                        (rowPtr_nextCol,idxCol + 1);
                end
                cntrTable_lanes(idxRow_currCol,idxCol) = ...
                    cntrTable_lanes(idxRow_currCol,idxCol) + ...
                    cntrChd;
            end

            % The number of current lanelet is dependent on the number of
            % its children, this is stored for current use
            % numRows_currLanelet indicates how many rows the current
            % lanelet will occupy
            numRows_currLanelet = ...
                cntrTable_lanes(idxRow_currCol,idxCol);

            % Store the lanelet info in the table
            % The column indexes of the lanelet and lane tables are the same
            for idxRow = rowPtr_currCol:(rowPtr_currCol + numRows_currLanelet - 1)
                idxTable_lanes(idxRow,idxCol) = ...
                    idxTable_lanelet(idxRow_currCol,idxCol);
                IDTable_lanes(idxRow,idxCol) = ...
                    IDTable_lanelet(idxRow_currCol,idxCol);
            end
            rowPtr_currCol = rowPtr_currCol + numRows_currLanelet;
        end
    end
end

idxTable_lanes_out = idxTable_lanes;
IDTable_lanes_out = IDTable_lanes;

end

