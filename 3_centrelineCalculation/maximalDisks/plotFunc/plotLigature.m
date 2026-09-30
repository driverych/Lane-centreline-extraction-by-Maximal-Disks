

function plotLigature(rowLocns_lgt,circlesConnected)

cntrCircles = size(circlesConnected,1);

cirIdx_lgtS = rowLocns_lgt(:,1);
cirIdx_lgtE = rowLocns_lgt(:,2);

plotTgtCircles(circlesConnected,cntrCircles,cirIdx_lgtS,'b');
plotTgtCircles(circlesConnected,cntrCircles,cirIdx_lgtE,'r'); 


end