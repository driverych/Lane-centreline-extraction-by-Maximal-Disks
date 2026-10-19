% plotOriginalLanelets - Plot the original lanelet struct,with no inversion.
%
% Syntax:  
%    plotOriginalLanelets(lanelet,cntrLanelet)
%
% Input:
%    lanelet - the lanelet struct
%    num_lanelets - the lanelet number
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: originalLanelet.mat(optional)
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index

function plotOriginalMultiPolys(multipoly,num_multipolys,origin)

% Select one polygon
for idxMultipoly = 1:num_multipolys
    % If a multipolygon is empty, skip plotting.
    if isempty(multipoly(idxMultipoly).boundary)
        continue
    end
    
    % Initialize
    numBndries = numel(multipoly(idxMultipoly).boundary);
    UTM_x = [];UTM_y = [];
    
    % Select one boundary
    for idxBndry = 1:numBndries
        % Select one point
        numPts_bndry = multipoly(idxMultipoly).boundary(idxBndry).numPoints;
        for idxPt = 1:numPts_bndry
            UTM_x(idxPt) = multipoly(idxMultipoly).boundary(idxBndry).points(idxPt).UTM_x;
            UTM_y(idxPt) = multipoly(idxMultipoly).boundary(idxBndry).points(idxPt).UTM_y;
        end
        bndry_X = UTM_x;
        bndry_Y = UTM_y;
        % Plot one boundary
        plot(bndry_X,bndry_Y,'Color','#EDB120','LineStyle','-.','LineWidth',1);
        hold on
        UTM_x = [];UTM_y = [];

    end
end

% Plot the origin
xUtmOrigin = origin.utm_x;
yUtmOrigin = origin.utm_y;
plot(xUtmOrigin,yUtmOrigin,'og');
axis equal

end