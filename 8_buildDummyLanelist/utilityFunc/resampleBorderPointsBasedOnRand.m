
function [innrPts,outrPts] = resampleBorderPointsBasedOnRand(resampledPtNum,ptNum_innr,ptNum_outr,ptSamples_innr,ptSamples_outr,iterNum)

% For reproducibility
% rng default

for idxIter = 1:iterNum
    
    % If the inner border crosses the outer border: default 1 (crossed)
    ifInnrCrossOutr = 1;
    while ifInnrCrossOutr == 1
    
        % Resample inner boundary points
        % Get lhs numbers, its range is (0,1)
        rndArray_innr = rand(resampledPtNum,1);
        % rndArray_innr = rand(resampledPtNum.innr,1);
        % Get the point index
        rndPtIdxArray_innr = sort(ceil(rndArray_innr * ptNum_innr),'ascend');
        % Get inner boundary points
        resampledInnrPts = ptSamples_innr(rndPtIdxArray_innr,:);
        % Retain the first and last points
        resampledInnrPts(1,:) = ptSamples_innr(1,:);
        resampledInnrPts(end,:) = ptSamples_innr(end,:);

        % Resample outer boundary points
        % rndArray_outr = rand(resampledPtNum.outr,1);
        rndArray_outr = rand(resampledPtNum,1);
        rndPtIdxArray_outr = sort(ceil(rndArray_outr * ptNum_outr),'ascend');
        % Get outer boundary points
        resampleOutrPts = ptSamples_outr(rndPtIdxArray_outr,:);
        % Retain the first and last points
        resampleOutrPts(1,:) = ptSamples_outr(1,:);
        resampleOutrPts(end,:) = ptSamples_outr(end,:);

        % Check if the two borders cross
        ifInnrCrossOutr = checkIfTwoBordersCross(resampledInnrPts,resampleOutrPts);
        
%         if ifInnrCrossOutr == 1
%                 for idxPt = 1:resampledPtNum
%                     lane.rightBoundary.Points(idxPt).UTM_x = (resampledInnrPts(idxPt,1))';
%                     lane.rightBoundary.Points(idxPt).UTM_y = (resampledInnrPts(idxPt,2))';
%                 end
% 
%                 for idxPt = 1:resampledPtNum
%                     lane.leftBoundary.Points(idxPt).UTM_x = (resampleOutrPts(idxPt,1))';
%                     lane.leftBoundary.Points(idxPt).UTM_y = (resampleOutrPts(idxPt,2))';
%                 end
% 
%                 % Plotting setting
%                 originPlot.x = 0; originPlot.y = 0;
%                 % Plot the lane
%                 figHdl = figure;
%                 plotSingleLane(lane,originPlot,figHdl);
%         end
        
    end % while ifInnrCrossOutr == 1
    
    % The inner and outer points
    innrPts = resampledInnrPts;
    outrPts = resampleOutrPts;
    
%     % * * * Plot the lane for test * * *
%     % Store the points in the lane struct
%     for idxPt = 1:resampledPtNum
%         lane.rightBoundary.Points(idxPt).UTM_x = (innrPts(idxPt,1))';
%         lane.rightBoundary.Points(idxPt).UTM_y = (innrPts(idxPt,2))';
%     end
%     
% %     for idxPt = 1:resampledPtNum.outr
%     for idxPt = 1:resampledPtNum
%         lane.leftBoundary.Points(idxPt).UTM_x = (outrPts(idxPt,1))';
%         lane.leftBoundary.Points(idxPt).UTM_y = (outrPts(idxPt,2))';
%     end
%     
%     % Plotting setting
%     originPlot.x = 0; originPlot.y = 0;
%     % Plot the lane
%     figHdl = figure;
%     plotSingleLane(lane,originPlot,figHdl);

end    
    
end