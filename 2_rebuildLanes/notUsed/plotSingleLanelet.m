% plotSingleLanelet - Plot the single lanelet
%
% Syntax:  
%    plotSingleLanelet(lanelet_in,idxlanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    idxlanelet - the index of the to-plot lanelet
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% num -> number
% idx -> index

function plotSingleLanelet(lanelet_in,idxlanelet)
    
% Plot original borders in lanelet struct
numPointsLeft = lanelet_in(idxlanelet).leftBoundary.numPoints;
Left_UTM_x = [];
Left_UTM_y = [];
for idxPoint_left = 1:numPointsLeft
    Left_UTM_x(idxPoint_left) = lanelet_in(idxlanelet).leftBoundary.points(idxPoint_left).UTM_x;
    Left_UTM_y(idxPoint_left) = lanelet_in(idxlanelet).leftBoundary.points(idxPoint_left).UTM_y;
end

% % Settings in desktop
% set(gcf,'position',[1349,570,560,420]); 
% Settings in laptop
set(gcf,'position',[376.2,336.2,560,420]);
axis equal
plot(Left_UTM_x,Left_UTM_y,'-b','LineWidth',3);
hold on
% Plot extreme points
plot(Left_UTM_x(1),Left_UTM_y(1),'ob','MarkerSize',7)
plot(Left_UTM_x(numPointsLeft),Left_UTM_y(numPointsLeft),'xb','MarkerSize',4);

numPointsRight = lanelet_in(idxlanelet).rightBoundary.numPoints;
Right_UTM_x = [];
Right_UTM_y = [];
for idxPoint_right = 1:numPointsRight
    Right_UTM_x(idxPoint_right) = lanelet_in(idxlanelet).rightBoundary.points(idxPoint_right).UTM_x;
    Right_UTM_y(idxPoint_right) = lanelet_in(idxlanelet).rightBoundary.points(idxPoint_right).UTM_y;
end

plot(Right_UTM_x,Right_UTM_y,'-r','LineWidth',3);
% Plot extreme points
plot(Right_UTM_x(1),Right_UTM_y(1),'or','MarkerSize',7)
plot(Right_UTM_x(numPointsRight),Right_UTM_y(numPointsRight),'xr','MarkerSize',4);
hold on

end