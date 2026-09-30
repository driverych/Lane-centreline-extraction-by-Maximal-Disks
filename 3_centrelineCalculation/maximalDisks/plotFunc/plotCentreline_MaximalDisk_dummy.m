% plotCentreline_MaximalDisk_dummy:
%   - Plot dummy lane boundaries and calculated centrelines
%   - Plot centrepoint connectivity and maximal inscribed circles
%
% Input:
%    laneList - Lane structure array containing calculated centrelines
%    originPlot - Plot origin with scalar fields x and y
%
% Output:
%    none
%
% Other m-files required: plotSingleLane.m, plotSingleCircle.m
% Subfunctions: none
% MAT-files required: none

function plotCentreline_MaximalDisk_dummy(laneList,originPlot)

for idx_lane = 1:numel(laneList)
    lane_inloop = laneList(idx_lane);
    hdlFig = figure(idx_lane);
    clf(hdlFig);

    %% Plot the chosen lane
    plotSingleLane(lane_inloop,originPlot,hdlFig);

    %% Plot the centrepoints (centreline)
    centrePoints = lane_inloop.centerline.Points;
    xCoords = [centrePoints(:).UTM_x] - originPlot.x;
    yCoords = [centrePoints(:).UTM_y] - originPlot.y;
    plot(xCoords,yCoords,'-kx','LineWidth',1);
    hold on

    %% Plot the vectors (connectivity of the centrepoints)
    numCentrepoints = numel(centrePoints);
    for idx_vector = 1:numCentrepoints-1
        x_start = xCoords(idx_vector);
        y_start = yCoords(idx_vector);
        u = xCoords(idx_vector+1) - x_start;
        v = yCoords(idx_vector+1) - y_start;
        quiver(x_start,y_start,u,v);
    end

    %% Plot the maximal inscribed circles
    for idx_circle = 1:numCentrepoints
        radius = centrePoints(idx_circle).radius;
        if radius <= 0 || ~isfinite(radius)
            continue
        end

        circleCenter(1,1) = centrePoints(idx_circle).UTM_x - originPlot.x;
        circleCenter(1,2) = centrePoints(idx_circle).UTM_y - originPlot.y;
        plotSingleCircle(circleCenter,radius,'k','k');
        hold on
    end

    xlabel('x (m)');
    ylabel('y (m)');
    title(['Dummy lane ',num2str(idx_lane)]);
    grid on
    axis equal
end

end
