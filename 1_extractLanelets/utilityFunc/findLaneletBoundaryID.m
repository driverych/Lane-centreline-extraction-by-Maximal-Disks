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

function [flag_hasBoundaries,boundaryID] = findLaneletBoundaryID(mapData,idxRelation)

    isLeftBoundary = 0; isRightBoundary = 0;
    % The content of a relation is its tag and member information
    num_contents = numel(mapData.Children(idxRelation).Children);
    for idxContent = 1:num_contents
        relnChild = mapData.Children(idxRelation).Children(idxContent);
        if ~strcmp('member',relnChild.Name)
            continue
        end
        boundaryOrien = getXmlAttr(relnChild,'role');
        if (strcmp('left',boundaryOrien))
           ID_leftBoundary = str2double(getXmlAttr(relnChild,'ref'));
           fprintf('%s\n\n','A left boundary is recognized');
           isLeftBoundary = 1;
        elseif (strcmp('right',boundaryOrien))
           ID_rightBoundary = str2double(getXmlAttr(relnChild,'ref'));
           fprintf('%s\n\n','A right boundary is recognized');
           isRightBoundary = 1;
        else
            continue
        end
    end
    
    if (isLeftBoundary == 0) && (isRightBoundary == 0)
        flag_hasBoundaries = 0;
        fprintf('%s\n\n','No boundaries are found');
    else
        flag_hasBoundaries = 1;
    end
    boundaryID.left = ID_leftBoundary;
    boundaryID.right = ID_rightBoundary;
    
end
