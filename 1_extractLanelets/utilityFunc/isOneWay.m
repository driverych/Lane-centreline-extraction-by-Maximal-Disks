% isOneWay - judge if a lanelet is one-way
%
% Syntax:  
%     lanelet_out = isOneWay(lanelet_in,cntrLanelet,mapData,idxRelation)
%
% Input:
%     lanelet_in - the lanelet struct
%     cntrLanelet - the lanelet counter
%     mapData - the imported Lanelet2 map data
%     idx_relation - the index of the relation element
%
% Output:
%     lanelet_out - the lanelet struct
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% info -> information
% num -> number
% idx -> index

function lanelet_out = isOneWay(lanelet_in,cntrLanelet,mapData,idxRelation)
    lanelet_out = lanelet_in;
    % The content of a relation is its tag and member information
    num_contents = numel(mapData.Children(idxRelation).Children);
    for idxContent = 1:num_contents
        relnChild = mapData.Children(idxRelation).Children(idxContent);
        if ~strcmp('tag',relnChild.Name)
            continue
        end
        oneWayInfo = getXmlAttr(relnChild,'k');
        oneWayFlag = getXmlAttr(relnChild,'v');
        if (strcmp('one_way',oneWayInfo))
            if (strcmp('no',oneWayFlag))
                lanelet_out(cntrLanelet).isOneWay = 0;
            else
                lanelet_out(cntrLanelet).isOneWay = 1;
            end
        end
    end
end
