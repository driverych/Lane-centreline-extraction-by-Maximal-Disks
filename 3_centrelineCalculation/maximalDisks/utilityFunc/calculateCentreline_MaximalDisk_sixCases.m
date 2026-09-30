% calculateCentreline_MaximalDisk_6Cases
%   - The cases could be devided into 6 cases.
%     Case 1: The circle is tangent to 2 segments and passes by one extreme
%             point, which is on one of the segments
%     Case 2: The circle is tangent to 2 segments and passes by one extreme
%             point, which is not on neither of the 2 segments. The 2
%             segments could be on the same side of the lane, or 1 segment
%             and the point could be on the same side.
%     Case 3: The circle is tangent to 3 segments,2 of which are on the
%             same lane boder.
%     Case 4: The circle passes 3 extreme points, two of which are on the
%             same lane boder.
%     Case 5: The circle  is tangent to 1 segment and passes 2 extreme
%             points. The segment and 1 point could be on the same side of
%             the lane, or the 2 point could be on the same side.
%     Case 6: The circle passes 2 points and is tangent to 1 segment, 1
%             point is the extreme point of the segment
%
% Syntax:  [laneList,circlesConnected] = calculateCentreline_MaximalDisk_sixCases(laneList)
%
% Input:
%    laneList - A matlab struct storing lane info
%
% Output:
%    laneList - A matlab struct storing lane info
%    circlesConnected - A matlab matrix to store circle info in sequence
%
% Subfunctions: offsetLane2Local
%               matchPointsByRangeAndKnnSearching
%               findInscribedCirclesThroughSegmentPairs_5Cases
%               connectCircleCentres
%               discretizeCentreline
%
% Main steps:
%  - Initialize parameters
%  - Offset the lane into the local origin
%  - Extract point pairs
%  - Select the base border and explore MDs of six cases
%  - Connect the circle centres
%  - Calculate the distance of the lane
%  - Discretize the centreline (Optional)
%  - Store the centrepoints
%  - Sum the lengths of all lanes (Optional)
%
% MAT-files required: none
% Abbreviation:
% coord -> coordinate
% cont -> continous
% lgth -> length
% num -> number
% cir -> circle
% idx -> index
% NN -> nearest neighbor
% CC -> circle centre
% R -> right
% L -> left

function [laneList,circlesConnected] = calculateCentreline_MaximalDisk_sixCases(laneList,discretInfo,utmOrigin)

% Initialize
flag_discretize = discretInfo.isCnlDiscret;
discreteStep = discretInfo.cnlDiscretStep; % Default is 0.005

cntr_fig = 0;

% Initiate the length martix of all lanes
% lanesLgth = zeros(numel(laneList),1);

ifCreateBar = 1;
if ifCreateBar == 1
    % Create a wait bar to show the progress of playing the scenario
    hdlFig_bar = waitbar(0,'The centreline is being calculated...','Position',[500,550,300,50]);
end

% for idx_lane = 1:numel(laneList)
for idx_lane = 1:numel(laneList)
    % Pick up a lane
    lane = laneList(idx_lane);

    %----------------------------------------------------------------------
    %-------              offset to the local origin               --------
    %----------------------------------------------------------------------
    % Offset the lane into the local origin
    [lanePoints,laneInfo,flds] = offsetLane2Local(lane,utmOrigin);

    % * * * Plot the lane for test * * *
    cntr_fig = cntr_fig + 1;
    % plotSingleLane(lane,utmOrigin,cntr_fig);
    % axis equal

    %----------------------------------------------------------------------
    %-------                    build Kd trees                     --------
    %----------------------------------------------------------------------
    [leftTree,rightTree,params] = buildKdTreesBasedOnLanePoints(lanePoints,laneInfo,flds);

    %----------------------------------------------------------------------
    %-------                   match point pairs                   --------
    %----------------------------------------------------------------------
    % The flag to eliminate unsuitable points (in the range and knn searching)
    filterPointPairsByAccumDist = 1;
    % Extract point pairs according to distance
    [pointPairs_CConL,pointPairs_CConR,flds] = ...
        matchPointsByRangeAndKnnSearching(lanePoints,laneInfo,flds,...
                                          leftTree,rightTree,params,filterPointPairsByAccumDist);

    %----------------------------------------------------------------------
    %-------                   calculate the MDs                   --------
    %----------------------------------------------------------------------
    % Initialize the circle container and the counter
    circleInfo = []; cntrCircles = 0;
    % Select border segments by Knn to check the intersection with circles
    intxnCheckByKNN = 0;
    % Run through the left border first and then the right
    for idx_loop = 1:2
        if idx_loop == 1
            isLeftBase = 1;
        else
            isLeftBase = 0;
        end
        [circleInfo,cntrCircles] = ...
            exploreMaximalDisksThroughPointPairs_sixCases...
                (pointPairs_CConL,pointPairs_CConR,flds,...
                 lanePoints,laneInfo,isLeftBase,...
                 circleInfo,cntrCircles,leftTree,rightTree,params,intxnCheckByKNN);
    end

    % * * * Plot the MDs for test * * *
    % plotAllCircles(circleInfo,cntrCircles);

    %----------------------------------------------------------------------
    %-------                 connect circle centres                --------
    %----------------------------------------------------------------------
    % Connect the circle centres
    [circlesConnected,numCircles] = ...
        connectCircleCentresByPointAndSegmentInfo(lanePoints,laneInfo,circleInfo);
    % Filter out the very-close points
    distThold = 0.01;
    circlesConnected = filterClosePoints(circlesConnected,distThold);

    % * * * Plot the raw centrelines for test * * *
    % plot(circlesConnected(:,1),circlesConnected(:,2),'-b');

    %----------------------------------------------------------------------
    %-------                   identify ligatures                  --------
    %----------------------------------------------------------------------
    rowLocns_lgt = identifyLigatureBySharedPts_withFilter(circlesConnected,laneInfo,lanePoints);

    % * * * Plot the range for test * * *
    % plotLigature(rowLocns_lgt,circlesConnected);

    %----------------------------------------------------------------------
    %-------                  compensate ligatures                 --------
    %----------------------------------------------------------------------
    distThold_skipLgt = 0.05;
    circlesConnected = compensateLigature(circlesConnected,rowLocns_lgt,distThold_skipLgt,lanePoints);

    %----------------------------------------------------------------------
    %-------              calculate the lane distance              --------
    %----------------------------------------------------------------------
    % Calculate the distance of the lane
    % lanesLgth(idx_lane,1) = calculateCentrelineLength(circlesConnected,numCircles);

    %----------------------------------------------------------------------
    %-------               discretize the centrelines              --------
    %----------------------------------------------------------------------
    centrepoints = [];
    if flag_discretize == 1
        % The discreteStep is in meter
        [discretePoints,numDiscretePoints] = ...
            discretizeCentreline(circlesConnected,size(circlesConnected,1),discreteStep);

        % * * * Plot the discretised points for test * * *
        % plot(discretePoints(:,1),discretePoints(:,2),'.r','MarkerSize',3);

        centrepoints = discretePoints;
        numCentrepoints = numDiscretePoints;
    else
        centrepoints = circlesConnected;
        numCentrepoints = numCircles;
    end

    %----------------------------------------------------------------------
    %-------                 store the centrepoints                --------
    %----------------------------------------------------------------------
    numCentrepoints = size(centrepoints,1);
    centre_x_prev = inf; 
    centre_y_prev = inf; 
    epsilon = 1e-6;
    cntrCnlPt = 1; 
    for idx_centrePoints = 1:numCentrepoints
        centre_x = centrepoints(idx_centrePoints,1);
        centre_y = centrepoints(idx_centrePoints,2);
        radius = centrepoints(idx_centrePoints,3);
        isSameWithPrev = abs(centre_x_prev - centre_x) < epsilon && abs(centre_y_prev - centre_y) < epsilon; 
        if isSameWithPrev
            continue
        else
            % Store de-duplicated centreline point.
            laneList(idx_lane).centerline.Points(cntrCnlPt).UTM_x = centre_x + utmOrigin.x; 
            laneList(idx_lane).centerline.Points(cntrCnlPt).UTM_y = centre_y + utmOrigin.y; 
            laneList(idx_lane).centerline.Points(cntrCnlPt).radius = radius; 
            % Advance compacted centreline point counter.
            cntrCnlPt = cntrCnlPt + 1;
            centre_x_prev = centre_x;
            centre_y_prev = centre_y;
        end
    end

    if ifCreateBar == 1
        % Update the wait bar
        prog = idx_lane/numel(laneList);
        prog_inPCT = floor(idx_lane/numel(laneList)*10000)/100;
        str = ['In progress:  ',num2str(prog_inPCT),'%'];
        waitbar(prog,hdlFig_bar,str);
    end
end

%--------------------------------------------------------------------------
%---------               sum lengths of all lanes                ----------
%--------------------------------------------------------------------------
% lengthOfAllLanes = sum(lanesLgth);

if ifCreateBar == 1
    % Kill the wait bar at last
    delete(hdlFig_bar);
end

end


