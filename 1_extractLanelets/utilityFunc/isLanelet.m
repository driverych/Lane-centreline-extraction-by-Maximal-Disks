% isLanelet - Judge if a relation is actually a lanelet. 
%             Lanelets are stored as 'relation' in maps
%
% Syntax:  
%    [flag_isLanelet,ID_lanelet,cntrLanelet_out] = 
%              isLanelet(mapData,idx_relation,relationType,cntrLanelet_in)
%
% Input:
%    mapData - the imported Lanelet2 map data
%    idxRelation - the index of the relation in the Lanelet2 map data
%    relationType - the type of the relation (lanelet,multipolygon etc.)
%    cntrLanelet_in - the number of the lanelets when imported
%
% Output:
%    flag_isLanelet - if flag_isLanelet == 1, then it is a lanelet
%    ID_lanelet - the id of the newly found lanelet
%    cntrLanelet_out - the number of the lanelets when exported
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% info -> information
% cntr -> counter
% num -> number
% idx -> index
% id -> identification

function [flag_isLanelet,ID_lanelet,cntrLanelet_out] = isLanelet(mapData,idxRelation,relationType,...
   cntrLanelet_in)

    if strcmp('relation',relationType)

        % Identify the relation by its type tag, regardless of tag order.
        tagInfo_last = getXmlTagValue(mapData.Children(idxRelation),'type');
        if strcmp('lanelet',tagInfo_last)
            % If it is a lanelet, store lanelet ID
            laneletInfo_ID = getXmlAttr(mapData.Children(idxRelation),'id');
            ID_lanelet = str2double(laneletInfo_ID);
            cntrLanelet_out = cntrLanelet_in + 1;
            flag_isLanelet = 1;
        else
            fprintf('%s,and its ID in Struct is %d\n\n','It is a relation but not a lanelet',idxRelation);
            % The ID and counter will not be stored in the main function
            ID_lanelet = 999999;
            cntrLanelet_out = cntrLanelet_in;
            flag_isLanelet = 0;
        end
    else
        fprintf('%s,and its ID in Struct is %d\n\n','A non_relation is found',idxRelation);
        % The ID and counter will not be stored in the main function
        ID_lanelet = 999999;
        cntrLanelet_out = cntrLanelet_in;
        flag_isLanelet = 0;
    end

end
