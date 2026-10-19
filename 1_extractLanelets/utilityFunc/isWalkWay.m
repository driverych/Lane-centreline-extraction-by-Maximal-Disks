% isWalkWay - Judge if the lanelet is walkway
%
% Syntax:  
%     lanelet_out = isWalkWay(lanelet_in,cntrLanelet,mapData,idxRelation)
%
% Input:
%     lanelet_in - the lanelet struct
%     cntrLanelet - the lanelet counter
%     mapData - the imported Lanelet2 map data
%     idxRelation - the index of the relation element
%
% Output:
%     lanelet_out - the lanelet struct
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% info -> information
% cntr -> counter
% num -> number
% idx -> index

function lanelet_out = isWalkWay(lanelet_in,cntrLanelet,mapData,idxRelation)

    lanelet_out = lanelet_in;
    % The content of a relation is its tag and member information
    num_contents = numel(mapData.Children(idxRelation).Children);
    for idx_content = 1:num_contents
        relnChild = mapData.Children(idxRelation).Children(idx_content);
        if ~strcmp('tag',relnChild.Name)
            continue
        end
        walkWayInfo = getXmlAttr(relnChild,'k');
        walkWayFlag = getXmlAttr(relnChild,'v');
        if (strcmp('subtype',walkWayInfo))
            if (strcmp('walkway',walkWayFlag))
                lanelet_out(cntrLanelet).isWalkWay = 1;
            else
                lanelet_out(cntrLanelet).isWalkWay = 0;
            end
        end
    end

end
