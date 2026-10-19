% plotSingleCircle - Plot the circle
%
% Syntax:  
%    plotSingleCircle(center,radius,centreColor,borderColor)
%
% Input:
%    center - the coordinate of the circle center
%    radius - the radius of the circle
%    centreColor - the color of the circle center
%    borderColor - the color of border
%
% Output:
%    none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% fig -> figure
% idx -> index
% num -> number


function plotSingleCircle(center,radius,centreColor,edgeColor)
    % Sample the edge points
    angRes = pi/100; % default is pi/60
    [xTemp,yTemp] = samplePointsOnCircle(center,radius,angRes);
    
    % Plot the circle centre
%     plot(center(1),center(2),'Color',centreColor,'Marker','.','MarkerSize',12);
%     sz = 15; % circle size
%     scatter(center(1),center(2),sz,'c',centreColor,'mkr','.');
%     scatter(center(1),center(2),sz);
    
    % Plot the circle edge
%     plot(xTemp,yTemp,'Color',edgeColor,'LineStyle',':','LineWidth',1.1);
    sz = 1.5;
    c = edgeColor;
    mkr = ".";
    % scatter(xTemp,yTemp,sz,c,mkr,'LineWidth',1);
    plot(xTemp,yTemp,'k','LineWidth',0.5);
    
%     grey = '#7F7F7F';
%     green = '#0c406d';
    % #337660  [0.2,0.4627,0.3765]
end