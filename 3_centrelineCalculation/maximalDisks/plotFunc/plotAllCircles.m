% calculateCentreline_MaximalDisk_5Cases
%   - Calculate lane centrelines based on Maximal Disks. The cases could be
%     devided into 5 cases.
% 
% Syntax:  plotAllCircles(circleInfo,cntrCircles)
%
% Input:
%    circleInfo - A matlab matrix to store circle info
%    cntrCircles - The number of circles
%
% Subfunctions: plotSingleCircle
%
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% idx -> index

function plotAllCircles(circleInfo,cntrCircles)
    
for idx_circle = 1: cntrCircles
    circleCenter(1,1) = circleInfo(idx_circle,1);
    circleCenter(1,2) = circleInfo(idx_circle,2);
    radius = circleInfo(idx_circle,3);
    plotSingleCircle(circleCenter,radius,'k','k');
    hold on
    axis equal
end  

end