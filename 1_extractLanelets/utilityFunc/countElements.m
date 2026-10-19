% countElements - get element numbers and indices from the imported map data. 
% Element types are identified independently of XML whitespace and order.
%
% Syntax:  
%    elemIdx = countElements(mapContext)
%
% Input:
%    mapContext - the imported Lanelet2 map data
%
% Output:
%    elemIdx - A MATLAB struct, containing number, start index and end
%    index of different map elements
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% intvl -> interval
% cntr -> counter
% elem -> element
% idx -> index
% num -> number

function elemIdx = countElements(mapContext)

    idxNodes = findXmlChildrenByName(mapContext,'node');
    idxWays = findXmlChildrenByName(mapContext,'way');
    idxRelations = findXmlChildrenByName(mapContext,'relation');
    
    elemIdx.n_nodes = numel(idxNodes);
    elemIdx.n_ways = numel(idxWays);
    elemIdx.n_relations = numel(idxRelations);
    
    % Retain the original fields for compatibility; empty types return [].
    [elemIdx.start_node,elemIdx.end_node] = firstAndLast(idxNodes);
    [elemIdx.start_way,elemIdx.end_way] = firstAndLast(idxWays);
    [elemIdx.start_relation,elemIdx.end_relation] = firstAndLast(idxRelations);
end

function [idxFirst,idxLast] = firstAndLast(indices)
    idxFirst = [];
    idxLast = [];
    if isempty(indices) == 0
        idxFirst = indices(1);
        idxLast = indices(end);
    end
end