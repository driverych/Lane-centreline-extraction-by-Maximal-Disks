
function [laneList,roadCntr] = resampleBorderPointsBasedOnLHS(resampledPtNum,ptNum_innr,ptNum_outr,ptSamples_innr,ptSamples_outr,iterNum,roadCntr,laneList)

% Plotting setting
originPlot.x = 0; originPlot.y = 0;

% For reproducibility
% rng default

for idxIter = 1:iterNum
    % Add one lane
    roadCntr = roadCntr + 1;
    % Resample inner boundary points
    % Get lhs numbers, its range is (0,1)
    rndArray_innr = lhsdesign(resampledPtNum.innr,1);
%     rndArray_innr = rand(resampledPtNum.innr,1);
    % Get the point index
    rndPtIdxArray_innr = sort(ceil(rndArray_innr * ptNum_innr),'ascend');
    % Get inner boundary points
    innrPts = ptSamples_innr(rndPtIdxArray_innr,:);
    % Retain the first and last points
    innrPts(1,:) = ptSamples_innr(1,:);
    innrPts(end,:) = ptSamples_innr(end,:);
    
    % Resample outer boundary points
    rndArray_outr = lhsdesign(resampledPtNum.outr,1);
%     rndArray_outr = rand(resampledPtNum.outr,1);
    rndPtIdxArray_outr = sort(ceil(rndArray_outr * ptNum_outr),'ascend');
    % Get outer boundary points
    outrPts = ptSamples_outr(rndPtIdxArray_outr,:);
    % Retain the first and last points
    outrPts(1,:) = ptSamples_outr(1,:);
    outrPts(end,:) = ptSamples_outr(end,:);

    % Store the points
    for idxPt = 1:resampledPtNum.innr
        laneList(roadCntr).rightBoundary.Points(idxPt).UTM_x = (innrPts(idxPt,1))';
        laneList(roadCntr).rightBoundary.Points(idxPt).UTM_y = (innrPts(idxPt,2))';
    end
    
    for idxPt = 1:resampledPtNum.outr
        laneList(roadCntr).leftBoundary.Points(idxPt).UTM_x = (outrPts(idxPt,1))';
        laneList(roadCntr).leftBoundary.Points(idxPt).UTM_y = (outrPts(idxPt,2))';
    end
    
    % * * * Plot the lane for test * * *
    % figHdl = figure(roadCntr);
    % plotSingleLane(laneList(roadCntr),originPlot,figHdl);

end    
    
end