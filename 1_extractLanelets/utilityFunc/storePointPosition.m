% storePointPosition - store the point positions in the lanelet struct,
%                      both WGS84 and UTM
%
% Syntax:  
%    lanelet_out = storePointPosition(lanelet_in,cntrLanelet,pointInfo)
%
% Input:
%    lanelet_in - the lanelet struct
%    cntrLanelet - the lanelet counter
%    pointInfo - point information: x_wgs,y_wgs,inLeftBoundary,inRightBoundary
%                                   index
%
% lanelet_out:
%    lanelet_out - the lanelet struct
%
% Other m-files required: wgs2utm.m
% Subfunctions: wgs2utm
% MAT-files required: none
% Abbreviation:
% info -> information
% cntr -> counter
% idx -> index

function lanelet_out = storePointPosition(lanelet_in,cntrLanelet,pointInfo,origin)

    lanelet_out = lanelet_in;
    x_point = str2double(pointInfo.x_wgs);
    y_point = str2double(pointInfo.y_wgs);
    inLeft = pointInfo.inLeftBoundary;
    inRight = pointInfo.inRightBoundary;
    idxPoint = pointInfo.idx;
    
    if inLeft == 1 && inRight == 0
        lanelet_out(cntrLanelet).leftBoundary.points(idxPoint).WGS84_x = x_point;
        lanelet_out(cntrLanelet).leftBoundary.points(idxPoint).WGS84_y = y_point;
        [lanelet_out(cntrLanelet).leftBoundary.points(idxPoint).UTM_x,...
            lanelet_out(cntrLanelet).leftBoundary.points(idxPoint).UTM_y] = ...
            wgs2utm(x_point,y_point,origin);
    elseif inLeft == 0 && inRight == 1
        lanelet_out(cntrLanelet).rightBoundary.points(idxPoint).WGS84_x = x_point;
        lanelet_out(cntrLanelet).rightBoundary.points(idxPoint).WGS84_y = y_point;
        [lanelet_out(cntrLanelet).rightBoundary.points(idxPoint).UTM_x,...
            lanelet_out(cntrLanelet).rightBoundary.points(idxPoint).UTM_y] = ...
            wgs2utm(x_point,y_point,origin);
    else
        fprintf('An error occurs while storing point positions/n/n');
    end
end