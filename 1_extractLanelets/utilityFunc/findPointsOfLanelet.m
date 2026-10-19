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

function lanelet_out = findPointsOfLanelet(lanelet_in,cntrLanelet,elemIdx,mapData,...
    boundaryID,origin)
    ID_leftBoundary = boundaryID.left;
    ID_rightBoundary = boundaryID.right;    

    lanelet_out = lanelet_in;
    for idx_way = findXmlChildrenByName(mapData.Children,'way')
        % Find the left boundary in mapData. First, extract ID information
        % from way information in mapData
        ID_way = getXmlAttr(mapData.Children(idx_way),'id');
        % Find points in the left boundary first.
        if strcmp(num2str(ID_leftBoundary),ID_way)
            idxNodes = findXmlChildrenByName(mapData.Children(idx_way).Children,'nd');
            num_wayContents = numel(mapData.Children(idx_way).Children);
            % Initiate node counter of the left boundary
            numNodes_left = 0;
            % Calculate the number of nodes in the left boundary
            for idx_content = 1:num_wayContents
                wayContent = mapData.Children(idx_way).Children(idx_content).Name;
                if strcmp('nd',wayContent)
                    numNodes_left = numNodes_left + 1;
                end
            end
            lanelet_out(cntrLanelet).leftBoundary.numPoints = numNodes_left;
            % Extract points information from mapData ways one by one (one information in a single loop)
            for idxPoint_left = 1:numNodes_left
                % Get a point ID from way information of the mapData
                ID_point_left = getXmlAttr(mapData.Children(idx_way).Children(idxNodes(idxPoint_left)),'ref');
                % Store a point ID of the left boundary in lanelet
                lanelet_out(cntrLanelet).leftBoundary.points(idxPoint_left).ID = str2double(ID_point_left);
                % Get points' position from node information of the mapData, one in a single loop
                for idx_node = findXmlChildrenByName(mapData.Children,'node')
                    ID_node = getXmlAttr(mapData.Children(idx_node),'id');
                    if strcmp(ID_point_left,ID_node)
                        pointInfo.x_wgs = getXmlAttr(mapData.Children(idx_node),'lat');
                        pointInfo.y_wgs = getXmlAttr(mapData.Children(idx_node),'lon');
                        pointInfo.inLeftBoundary = 1;
                        pointInfo.inRightBoundary = 0;
                        pointInfo.idx = idxPoint_left;
                        lanelet_out = storePointPosition(lanelet_out,cntrLanelet,pointInfo,origin);
                    end
                end
            end
            fprintf('The number of points in left boundary is %d\n\n',numNodes_left);
            fprintf('The ID of left boundary is %s\n\n',num2str(ID_leftBoundary));
        elseif strcmp(num2str(ID_rightBoundary),ID_way)
            idxNodes = findXmlChildrenByName(mapData.Children(idx_way).Children,'nd');
            num_wayContents = numel(mapData.Children(idx_way).Children);
            % Initiate nodes counter of right boundary
            numNodes_right = 0;
            % Calculate the number of nodes in the right boundary
            for idx_content = 1:num_wayContents
                wayContent = mapData.Children(idx_way).Children(idx_content).Name;
                if strcmp('nd',wayContent)
                    numNodes_right = numNodes_right + 1;
                end
            end
            lanelet_out(cntrLanelet).rightBoundary.numPoints = numNodes_right;
            % Extract points information from mapData ways one by one (one information in a single loop)
            for idxPoint_right = 1:numNodes_right
                % Get a point ID from way information of the mapData
                ID_point_right = getXmlAttr(mapData.Children(idx_way).Children(idxNodes(idxPoint_right)),'ref');
                % Store point ID of the right boundary in lanelet
                lanelet_out(cntrLanelet).rightBoundary.points(idxPoint_right).ID = str2double(ID_point_right);
                % Get points' position from mapData, one in a single loop
                for idx_node = findXmlChildrenByName(mapData.Children,'node')
                    ID_node = getXmlAttr(mapData.Children(idx_node),'id');
                    if strcmp(ID_point_right,ID_node)
                        pointInfo.x_wgs = getXmlAttr(mapData.Children(idx_node),'lat');
                        pointInfo.y_wgs = getXmlAttr(mapData.Children(idx_node),'lon');
                        pointInfo.inLeftBoundary = 0;
                        pointInfo.inRightBoundary = 1;
                        pointInfo.idx = idxPoint_right;
                        lanelet_out = storePointPosition(lanelet_out,cntrLanelet,pointInfo,origin);
                    end
                end
            end
            fprintf('The number of points in right boundary is %d\n\n',numNodes_right);
            fprintf('The ID of right boundary is %s\n\n',num2str(ID_rightBoundary));
        end
    end
end
