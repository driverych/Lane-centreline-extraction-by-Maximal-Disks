% findBoundaryID - find the IDs of the left and right boundaries of a
%                  lanelet.
%
% Syntax:  
%    [flag_hasBoundaries,boundaryID] = findBoundaryID(mapData,idxRelation)
%
% Input:
%    mapData - the imported Lanelet2 map data
%    idxRelation - the index of the relation element
%
% Output:
%    flag_hasBoundaries - if flag_hasBoundaries == 1, both boundaries of a
%                         lanelet are found
%    boundaryID - a MATLAB struct: boundaryID.left is the ID of the left
%    boundary and boundaryID.right the ID of the right boundary
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% orien -> orientation
% num -> number
% bdy -> boundary
% idx -> index
% cntnt -> content

function [flag_hasBndries,IDs_bndry] = findMultiPolygonBoundaryID(mapData,idxReln)
    
% Initiate the number of multipolygon boundaries
numBndries = 0;
IDs_bndry = [];
% The content of a relation is its tag and member information
num_cntnts = numel(mapData.Children(idxReln).Children);
for idxCntnt = 1:num_cntnts
    relnChild = mapData.Children(idxReln).Children(idxCntnt);
    if ~strcmp('member',relnChild.Name)
        continue
    end
    bndryRole = getXmlAttr(relnChild,'role');
    if (strcmp('outer',bndryRole))
        numBndries = numBndries + 1;
        ID_bndry = str2double(getXmlAttr(relnChild,'ref'));
        fprintf('%s\n\n','A polygon boundary is recognized');
        IDs_bndry = [IDs_bndry;ID_bndry];
    else
        continue
    end
end

if size(IDs_bndry,1) > 0
    flag_hasBndries = 1;
end
    
end
