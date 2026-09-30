
function plotLaneAndCentrepoints(laneList,origin)

%% Plot both borders
% Plot the left border
x_L = [laneList.leftBoundary.Points(:).UTM_x] - origin.x;
y_L = [laneList.leftBoundary.Points(:).UTM_y] - origin.y;
plot(x_L,y_L,'b-','LineWidth',1.25,'Marker','.','MarkerSize',12);
hold on

% Plot the right border
x_R = [laneList.rightBoundary.Points(:).UTM_x] - origin.x;
y_R = [laneList.rightBoundary.Points(:).UTM_y] - origin.y;
plot(x_R,y_R,'b-','LineWidth',1.25,'Marker','.','MarkerSize',12);

x_C = [laneList.centerline.Points(:).UTM_x] - origin.x;
y_C = [laneList.centerline.Points(:).UTM_y] - origin.y;

%% Plot the maximal disks
numCentrepoints = size(x_C,2);
for idx_circle = 1: numCentrepoints
    radius = laneList.centerline.Points(idx_circle).radius;
    if radius == 0
        continue
    end
    circleCenter(1,1) = laneList.centerline.Points(idx_circle).UTM_x - origin.x;
    circleCenter(1,2) = laneList.centerline.Points(idx_circle).UTM_y - origin.y;
    blackPoint = 'k';
%     blackEdge = "#000000";
    blackEdge = "k";
    plotSingleCircle(circleCenter,radius,blackPoint,blackEdge);
end

%% Plot the centre line

% % plot(x_C,y_C,'k-.','LineWidth',1);
plot(x_C,y_C,'r-','LineWidth',1.25);

%% Plot the centre points
sz = 60;
c = 'r';
mkr = ".";
scatter(x_C,y_C,sz,c,mkr,'LineWidth',1);


end