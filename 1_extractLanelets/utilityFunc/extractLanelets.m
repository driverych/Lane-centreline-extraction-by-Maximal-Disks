
% reln -> relation

function [multiPoly,cntrMultipoly,lanelet,cntrLanelet] = extractLanelets(mapData,origin,sceID)

%--------------------------------------------------------------------------
%---------  Identify the start and end indexes of all elements   ----------
%--------------------------------------------------------------------------
% Initiate element index information according to the imported osm.file
elemIdx = countElements(mapData.Children);

% Initiate lanelet counter
cntrLanelet = 0;
for idxReln = findXmlChildrenByName(mapData.Children,'relation')
    
    %----------------------------------------------------------------------
    %-------           Identify Lanelets from 'Relation'           --------
    %----------------------------------------------------------------------
    % Judge if it is a lanelet
    relnType = mapData.Children(idxReln).Name;
    [flag_isLanelet,ID_lanelet,cntrLanelet] = isLanelet(mapData,idxReln,relnType,...
        cntrLanelet);
    if flag_isLanelet == 0
        continue
    end
    % Store the lanelet ID in lanelet struct
    lanelet(cntrLanelet).ID = ID_lanelet;

    %----------------------------------------------------------------------
    %-------        Extract both boundary IDs from Lanelet         --------
    %----------------------------------------------------------------------
    % Find IDs of the left and right boundaries (lineStrings) of each lanelet
    [flag_hasBndries,bndryID_Lanelet] = findLaneletBoundaryID(mapData,idxReln);
    
    % Store boundary IDs in lanelet struct    
    if flag_hasBndries == 1
        lanelet(cntrLanelet).leftBoundary.ID = bndryID_Lanelet.left;
        lanelet(cntrLanelet).rightBoundary.ID = bndryID_Lanelet.right;
    else
        continue
    end
    
    %----------------------------------------------------------------------
    %-------    Match boundaries in 'Ways' and points in 'Nodes'   --------
    %----------------------------------------------------------------------
    % Find points of each boundary and store their information(IDs and positions)
    lanelet = findPointsOfLanelet(lanelet,cntrLanelet,elemIdx,mapData,bndryID_Lanelet,origin);

    %----------------------------------------------------------------------
    %-------                    Add one-way info                   --------
    %----------------------------------------------------------------------
    % Identify if the lanelet is one-way  <tag k='one_way' v='no' />
    lanelet = isOneWay(lanelet,cntrLanelet,mapData,idxReln);
    
    %----------------------------------------------------------------------
    %-------                   Add walk-way info                   --------
    %----------------------------------------------------------------------
    % Identify if the lanelet is a walkway  <tag k='subtype' v='walkway' />
    lanelet = isWalkWay(lanelet,cntrLanelet,mapData,idxReln);
    
    %----------------------------------------------------------------------
    %-------              Add boundary alignment info              --------
    %----------------------------------------------------------------------
    % Judge if lanelet boundaries should be inverted
    lanelet = checkBorderOrien(lanelet,cntrLanelet);
    
    % If a lanelet has no left boundary, skip the remaining processing.
    if isempty(lanelet(cntrLanelet).leftBoundary)
        continue
    end
    %----------------------------------------------------------------------
    %-------                  Add scenario ID info                 --------
    %----------------------------------------------------------------------
    lanelet(cntrLanelet).sceID = sceID;

end


% Initiate multiPolygon counter
cntrMultipoly = 0;
for idxReln = findXmlChildrenByName(mapData.Children,'relation')
    
    %----------------------------------------------------------------------
    %-------         Identify multipolygon from 'Relation'         --------
    %----------------------------------------------------------------------
    % Judge if it is a multipolygon
    relnType = mapData.Children(idxReln).Name;
    [flag_isMultipoly,ID_multipoly,cntrMultipoly] = ...
        isMultiploygon(mapData,idxReln,relnType,cntrMultipoly);
    if flag_isMultipoly == 0
        continue
    end
    % Store the multipolygon ID in multipolygon struct
    multiPoly(cntrMultipoly).ID = ID_multipoly;

    %----------------------------------------------------------------------
    %-------        Extract boundary IDs from Multiploygon         --------
    %----------------------------------------------------------------------
    % Find IDs of the boundaries (lineStrings) of each multipolygon
    [flag_hasBndries,bndryID_multiPoly] = findMultiPolygonBoundaryID(mapData,idxReln);
    
    % Store boundary IDs in multiPolygon struct    
    if flag_hasBndries == 1
        numBndaries = size(bndryID_multiPoly,1);
        for idxBndry = 1:numBndaries
            multiPoly(cntrMultipoly).boundary(idxBndry).ID = ...
                bndryID_multiPoly(idxBndry,1);
        end
    else
        continue
    end
    
    %----------------------------------------------------------------------
    %-------    Match boundaries in 'Ways' and points in 'Nodes'   --------
    %----------------------------------------------------------------------
    % Find points of each boundary and store their information(IDs and positions)
    multiPoly = findPointsOfMultipolygon(multiPoly,cntrMultipoly,elemIdx,mapData,bndryID_multiPoly,origin);
    
    %----------------------------------------------------------------------
    %-------                  Add scenario ID info                 --------
    %----------------------------------------------------------------------
    multiPoly(cntrMultipoly).sceID = sceID;


%     %----------------------------------------------------------------------
%     %-------                   Add walk-way info                   --------
%     %----------------------------------------------------------------------
%     % Identify if the lanelet is a walkway  <tag k='subtype' v='walkway' />
%     lanelet = isWalkWay(lanelet,cntrLanelet,mapData,idxReln);

     
end

if cntrMultipoly == 0
    multiPoly = [];
end

end
