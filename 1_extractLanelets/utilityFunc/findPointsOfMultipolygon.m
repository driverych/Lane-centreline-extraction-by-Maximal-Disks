% findPoints - find each point in both boundaries and store its positions
%              in the lanelet struct
%
% Syntax:  
%    lanelet_out = findPoints(lanelet_in,cntrLanelet,elemIdx,mapData,boundaryID)
%
% Input:
%    lanelet_in - the lanelet struct
%    cntrLanelet - the lanelet counter
%    elemIdx - index info of the map elements (node,way,relation)
%    mapData - the imported Lanelet2 map data
%    boundaryID - IDs of the left and right boundaries
%
% Output:
%    lanelet_out - the lanelet struct
%
% Other m-files required: storePointPosition.m
% Subfunctions: storePointPosition
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% elem -> element
% num -> number
% bdy -> boundary
% idx -> index
% id -> identification
% S -> start
% E -> end

function multiPoly_out = findPointsOfMultipolygon(multiPoly_in,cntrMultiPoly,elemIdx,mapData,...
    bndryIDs,origin)
    
    % The number of multipolygon boundaries
    numBndries = size(bndryIDs,1);
    
    multiPoly_out = multiPoly_in;
    for idx_way = findXmlChildrenByName(mapData.Children,'way')
        % Find the left boundary in mapData. First, extract ID information
        % from way information in mapData
        ID_way = getXmlAttr(mapData.Children(idx_way),'id');
        % Find points in the left boundary first.
        
        for idxBndry = 1:numBndries
            % The boundary ID
            ID_bndry = bndryIDs(idxBndry,1);
            
            % Compare the boundary ID with the way ID
            if strcmp(num2str(ID_bndry),ID_way)
                idxNodes = findXmlChildrenByName(mapData.Children(idx_way).Children,'nd');
                num_wayCntnts = numel(mapData.Children(idx_way).Children);
                % Initiate node counter of the multipolygon boundary
                numNodes_bndry = 0;
                % Calculate the number of nodes in the boundary
                for idx_wayCntnt = 1:num_wayCntnts
                    wayCntnt = mapData.Children(idx_way).Children(idx_wayCntnt).Name;
                    if strcmp('nd',wayCntnt)
                        numNodes_bndry = numNodes_bndry + 1;
                    end
                end
                multiPoly_out(cntrMultiPoly).boundary(idxBndry).numPoints = numNodes_bndry;
                % Extract points information from mapData ways one by one (one information in a single loop)
                for idxPoint = 1:numNodes_bndry
                    % Get a point ID from way information of the mapData
                    ID_point = getXmlAttr(mapData.Children(idx_way).Children(idxNodes(idxPoint)),'ref');
                    % Store a point ID of the boundary in lanelet
                    multiPoly_out(cntrMultiPoly).boundary(idxBndry).points(idxPoint).ID = str2double(ID_point);
                    % Get points' position from node information of the mapData, one in a single loop
                    for idx_node = findXmlChildrenByName(mapData.Children,'node')
                        ID_node = getXmlAttr(mapData.Children(idx_node),'id');
                        if strcmp(ID_point,ID_node)
                            pointInfo.x_wgs = getXmlAttr(mapData.Children(idx_node),'lat');
                            pointInfo.y_wgs = getXmlAttr(mapData.Children(idx_node),'lon');
                            pointInfo.idx = idxPoint;
                            multiPoly_out = storePointPositionInMultipolygon(multiPoly_out,cntrMultiPoly,idxBndry,pointInfo,origin);
                        end
                    end
                end % for idxPoint = 1:numNodes_bndry
                fprintf('The number of points in boundary is %d\n\n',numNodes_bndry);
                fprintf('The ID of boundary is %s\n\n',num2str(ID_bndry));
            end % if strcmp(num2str(ID_bndry),ID_way)
            
        end % for idxBndry = 1:numBndries

    end % for idx_way = findXmlChildrenByName(mapData.Children,'way')
end
