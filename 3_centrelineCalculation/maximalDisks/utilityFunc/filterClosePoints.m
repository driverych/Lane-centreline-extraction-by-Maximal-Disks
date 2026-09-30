% Filter out very close points

function circlesConnected = filterClosePoints(circlesConnected,distThold)

% Calculate the distance between consecutive points
posDiff = diff(circlesConnected(:,1:2));
dists = sqrt(sum(posDiff.^2, 2));

% The points to keep
flag_keep = [true; dists > distThold];

% Keep the points
circlesConnected = circlesConnected(flag_keep,:);

end