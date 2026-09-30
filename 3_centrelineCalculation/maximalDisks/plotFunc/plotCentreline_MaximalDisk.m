% Main functions:
%  - Plot the chosen lane
%  - Plot the centreline
%  - Plot the connectivity of the centrepoints
%  - Plot the maximal inscribed circles

function plotCentreline_MaximalDisk(laneList,alignedLanelet,originPlot)

% Initialize the figure counter
cntr_fig = 0;

% for idx_lane = 1:numel(laneList)
for idx_lane = 1:numel(laneList)
    % Pick up a lane
    lane_inloop = laneList(idx_lane);
    
    % Update the figure counter and create the figure
    cntr_fig = cntr_fig + 1;
%     cntr_fig = 1;
    hdlFig = figure(cntr_fig);
    
    %% Plot the whole map
%     plotMapWithLaneletBoundaries(hdlFig,alignedLanelet,originPlot)

    %% Plot the chosen lane
    if isempty(lane_inloop.centerline) == 0
        plotSingleLane(lane_inloop,originPlot,hdlFig);
    else
        continue
    end
    
    %% Plot the centrepoints (centreline)
    xCoords = [laneList(idx_lane).centerline.Points(:).UTM_x] - originPlot.x;
    yCoords = [laneList(idx_lane).centerline.Points(:).UTM_y] - originPlot.y;
    plot(xCoords,yCoords,'-k.','LineWidth',1);
    hold on
    axis equal

    % The size of the point
    numCentrepoints = size(xCoords,2);
    %% Plot the vetor (connectivity of the centrepoints)
    for idx_vector = 1:numCentrepoints-1
        x_start = xCoords(1,idx_vector);
        y_start = yCoords(1,idx_vector);
        x_end = xCoords(1,idx_vector+1);
        y_end = yCoords(1,idx_vector+1);
        u = x_end - x_start;
        v = y_end - y_start;
        quiver(x_start,y_start,u,v);
    end
    
    %% Plot the maximal inscribed circles
    for idx_circle = 1: numCentrepoints
        radius = laneList(idx_lane).centerline.Points(idx_circle).radius;
        if radius == 0
            continue
        end
        circleCenter(1,1) = laneList(idx_lane).centerline.Points(idx_circle).UTM_x - originPlot.x;
        circleCenter(1,2) = laneList(idx_lane).centerline.Points(idx_circle).UTM_y - originPlot.y;
        plotSingleCircle(circleCenter,radius,'k','k');
%         plotSingleCircle(circleCenter,radius,'k','#0c406d');
        hold on
    end

end

end