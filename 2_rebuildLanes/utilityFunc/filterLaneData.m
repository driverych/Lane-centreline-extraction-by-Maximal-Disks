% filterLaneData - filter the redundant table values
%
% Syntax:  
%    table_lanes_out = filterLaneData(table_lanes_in)
%
% Input:
%    table_lanes_in - the table to store lanelet indexes or IDs of lanes
%
% Output:
%    table_lanes_out - the table to store lanelet indexes or IDs of lanes
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% idx -> index
% col -> column


%  An example of ID table with useless info:
%   ___________________________________________________________________________________________________________________________________________
%   -1766582	-1766720	-1766681	-1766676	-1766675    -1766717    -1766584        0           0           0           0           0  
%   -1766582    -1766720    -1766681    -1766676    -1766682    -1766694    -1766625    -1766621    -1766616    -1766614	-176661         0 
%   -1766582    -1766720    -1766715    -1766677    -1766678    -1766596    -1766728    -1766654    -1766665    -1766667        0           0   
%   -1766582    -1766720    -1766715    -1766677    -1766678    -1766727    -1766728    -1766654    -1766665    -1766667        0           0   
%   -1766582    -1766720    -1766715    -1766677    -1766680        0           0           0           0           0           0           0   
%   -1766582    -1766721    -1766722    -1766723    -1766581    -1766656    -1766661    -1766668    -1766592        0           0           0   
%   -1766582        0           0           0           0           0           0           0           0           0           0           0
%       0           0           0           0           0           0           0           0           0           0           0           0           
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% Three features of unnecessary data:
% the row starts with zero
% the data in one column are all zeros
% the second datum in a row is zero 

function table_lanes_out = filterLaneData(table_lanes_in)

% Remove rows starting with zero
rowToRetain = (table_lanes_in(:,1) ~= 0);
table_lanes_in = table_lanes_in(rowToRetain,:);

% Remove columns all filled with zeros
sum_Col = sum(table_lanes_in,1);
colToRetain = (sum_Col ~= 0);
table_lanes_in = table_lanes_in(:,colToRetain);

% Remove rows whose second datum is zero
rowToRetain = (table_lanes_in(:,2) ~= 0);
table_lanes_in = table_lanes_in(rowToRetain,:);

% Update the output
table_lanes_out = table_lanes_in;

end

