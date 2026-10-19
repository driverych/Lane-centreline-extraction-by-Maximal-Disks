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

function multiPoly_out = storePointPositionInMultipolygon(multiPoly_in,cntrMultiPoly,idxBndry,pointInfo,origin)

    
multiPoly_out = multiPoly_in;
x_point = str2double(pointInfo.x_wgs);
y_point = str2double(pointInfo.y_wgs);
idxPoint = pointInfo.idx;

multiPoly_out(cntrMultiPoly).boundary(idxBndry).points(idxPoint).WGS84_x = x_point;
multiPoly_out(cntrMultiPoly).boundary(idxBndry).points(idxPoint).WGS84_y = y_point;
[multiPoly_out(cntrMultiPoly).boundary(idxBndry).points(idxPoint).UTM_x,...
    multiPoly_out(cntrMultiPoly).boundary(idxBndry).points(idxPoint).UTM_y] = wgs2utm(x_point,y_point,origin);

end