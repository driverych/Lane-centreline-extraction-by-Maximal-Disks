% pointPairing
%   - Match points from two opposite lane borders. A range searching is
%     firstly performed. But, due to sparse distribution of points, failure
%     of point matching happens from time to time. To make sure each points
%     could match at least two points on the opposite border, K-nearest
%     neighbor searching is performed if less than two point pairs are
%     found. One benefit of KNN searching is that it could guarantee
%     effective point matching while not enlarging the radius in range
%     searching, which usually causes low efficiency and reduntant
%     matching.
%   - Choose one border as the base border. Run throuth all points on the
%     base border (base points) to match points on the opposite border 
%     (target border).
% 
% Syntax:  [pointPairs,numPairs] = pointPairing(lanePoints,laneInfo,radius,numNN,field,isLeftBase)
%
% Input:
%    lanePoints - A matlab martix storing both left and right border points.
%                 Its field is [index,x,y]
%    laneInfo - A matlab struct storing info of point numbers
%    radius - The radius of the circle in range searching
%    numNN - The number of the nearest neighbors to search
%    field - the field info of lane points
%    isLeftBase - Indicate if the left border is the base border
%
% Output:
%    pointPairs - A matlab matrix to store point pairs info, the field is:
%                 [idx_leftPoint,idx_rightPoint,coord_leftPoint,coord_rightPoint]
%    numPairs - The number of the found point pairs
%
% Subfunctions: calculateBorderLength
%               rangeSearchingBasedOnChosenPoint
%               calculateDistancesFromCurrentToStartAndEnd
%               KnnSearchingBasedOnChosenPoint
%               isIndexContinous
%               storeThePointPairs
%               addOneMorePoint2Tail
%               
% Main steps:
%  - Build the Kd-tree based on the target border data
%    and calculate the segment distance of the base border (filter unwanted points)
%  - Perform range searching with a given base point
%  - Calculate the distance form the current point to its start and end
%    points (filter unwanted points)
%  - Perform KNN searching if range searching does not fullfill the 
%    requirements
%  - Judge if the index of the matched target points are continuous (filter unwanted points)
%  - Eliminate the unsuitable points (filter unwanted points)
%  - Store the matched point pairs
%
% MAT-files required: none
% Abbreviation:
% accum -> accumulated
% cntr -> counter
% srch -> search
% tgt -> target
% num -> number
% rng -> range
% NN -> nearest neighbor


% FYI:
% The counter is the row index in the matrix while the index is the point
% sequence in the left/right border
% The counter is always positive while the index is positive for left
% points and negative for right points

function [pointPairs,numPairs] = pointPairing(lanePoints,laneInfo,flds,isLeftBase,...
                                              leftTree,rightTree,params,filterPointPairsByAccumDist)

% The field information of the lane points
fld_idx = flds.lanePoints.idx; fld_coords = flds.lanePoints.coords;

% The numbers of points on both borders
numPoints_L = laneInfo.leftPoints.number;
numPoints_R = laneInfo.rightPoints.number;
% Extract the left and right border points
leftPoints = lanePoints(1:numPoints_L,:);
rightPoints = lanePoints(numPoints_L + 1:numPoints_L + numPoints_R,:);

% Initialize a matrix to store point-point information
pointPairs = []; numPairs = 0; 

%--------------------------------------------------------------------------
%---------     Assign Kd-tree and calculate segment distance     ----------
%--------------------------------------------------------------------------
% Initialize the base and target border info
if isLeftBase == 1 % Given a left point, find the matched right points of Kd-tree
    numPoints_Base = numPoints_L; numPoints_Tgt = numPoints_R;
    basePoints = leftPoints; tgtPoints = rightPoints;
    % Assign the kdTree for the target
    KdTree_tgt = rightTree;
    if filterPointPairsByAccumDist == 1
        % Calculate the segment distances of the left border 
        [lgth_leftBorder,lgth_leftSegs] = calculateBorderLength(leftPoints(:,fld_coords));
        lgth_baseSegs = lgth_leftSegs; lgth_baseBorder = lgth_leftBorder;
    end
else % Given a right point, find the matched left points of Kd-tree
    numPoints_Base = numPoints_R; numPoints_Tgt = numPoints_L;
    basePoints = rightPoints; tgtPoints = leftPoints;
    % Assign the kdTree for the target
    KdTree_tgt = leftTree;
    if filterPointPairsByAccumDist == 1
        % Calculate the segment distances of the right border 
        [lgth_rightBorder,lgth_rightSegs] = calculateBorderLength(rightPoints(:,fld_coords));
        lgth_baseSegs = lgth_rightSegs; lgth_baseBorder = lgth_rightBorder;
    end
end

% Initialize the accumulated distance from the start point
accumLgth_base = 0;

% The procedure of point pairing
for cntrPoint_Base = 1:numPoints_Base

    % The coordinate of the chosen base point
    idx_basePoint = basePoints(cntrPoint_Base,fld_idx);
    coord_basePoint = basePoints(cntrPoint_Base,fld_coords);
    % * * * Plot the range circle for test * * *
%     plotSingleCircle(coord_basePoint,radius,'#000000','#0c406d'); hold on;

    %----------------------------------------------------------------------
    %-------                perform range searching                --------
    %----------------------------------------------------------------------
    % Perform the range searching
    % cntrMatrixTgt is the matrix of row number in KdTree
    [locsMatrixTgt_rngSrch,numPoints_rngSrch] = ...
        rangeSearchingBasedOnChosenPoint(coord_basePoint,KdTree_tgt,params);
    
    if filterPointPairsByAccumDist == 1
        % Calculate the distances from one base point to the start and end
        % points
        [dist_currBase2Start,dist_currBase2End,accumLgth_base] = ...
            calculateDistancesFromCurrentToStartAndEnd(cntrPoint_Base,lgth_baseSegs,lgth_baseBorder,accumLgth_base);
    end

    % At least 2 points should be identified
    if numPoints_rngSrch < 2
        %------------------------------------------------------------------
        %-----                 perform KNN searching                 ------
        %------------------------------------------------------------------
        % Perform KNN searching
        % cntrMatrixTgt_KnnSearch is the matrix of row number in KdTree
        locsMatrixTgt_KnnSearch = ...
            KnnSearchingBasedOnChosenPoint(coord_basePoint,KdTree_tgt,params);
        
        %------------------------------------------------------------------
        %-----               eliminate unwanted points               ------
        %------------------------------------------------------------------
        if filterPointPairsByAccumDist == 1
            % Judge if the indexes are continous. If not, then some unwanted
            % points are included
            [isIndexCont,breakIdx] = isIndexContinous(locsMatrixTgt_KnnSearch);
            if isIndexCont == 0
                % If the left point is closer to the start point, then smaller
                % indexes will be retained
                if dist_currBase2Start <= dist_currBase2End
                    locsMatrixTgt_KnnSearch = locsMatrixTgt_KnnSearch(1:breakIdx-1,:);
                else
                    locsMatrixTgt_KnnSearch = locsMatrixTgt_KnnSearch(breakIdx:end,:);
                end
            end
        end
        
        %------------------------------------------------------------------
        %-----                store matched points                   ------
        %------------------------------------------------------------------
        % Store the point pair
        [pointPairs,numPairs] = storeThePointPairs...
            (locsMatrixTgt_KnnSearch,tgtPoints,numPairs,pointPairs,idx_basePoint,coord_basePoint,flds,isLeftBase);

    else % At least two points are found in the range searching
        %------------------------------------------------------------------
        %-----               eliminate unwanted points               ------
        %------------------------------------------------------------------
        if filterPointPairsByAccumDist == 1
            [isIndexCont,breakIdx] = isIndexContinous(locsMatrixTgt_rngSrch);
            if isIndexCont == 0
                % If the left point is closer to the start point, then smaller
                % indexes will be retained
                if dist_currBase2Start <= dist_currBase2End
                    locsMatrixTgt_rngSrch = locsMatrixTgt_rngSrch(1:breakIdx-1,:);
                else
                    locsMatrixTgt_rngSrch = locsMatrixTgt_rngSrch(breakIdx:end,:);
                end
            end
        end
        
        %------------------------------------------------------------------
        %-----                store matched points                   ------
        %------------------------------------------------------------------
        % Store the point pair
        [pointPairs,numPairs] = storeThePointPairs...
            (locsMatrixTgt_rngSrch,tgtPoints,numPairs,pointPairs,idx_basePoint,coord_basePoint,flds,isLeftBase);

        % Add one more point
        maxLoc_tgt = locsMatrixTgt_rngSrch(end);
        if maxLoc_tgt < numPoints_Tgt
            [pointPairs,numPairs] = addOneMorePoint2Tail...
                (maxLoc_tgt,tgtPoints,numPairs,pointPairs,idx_basePoint,coord_basePoint,flds,isLeftBase);            
        end
    end

    
end

end