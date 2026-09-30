

function [crvPtSamples_innr,crvPtSamples_outr,crvPtNum_innr,crvPtNum_outr,finalCrvAg] = createCurveSegment(circleCentr,crvRa,crvAgResl,crvCenAg,initCrvAg,ifClockWise,roadWidth)
    
% The sample points in the inner curve boundary
crvRa_innr = crvRa - roadWidth;
if crvRa_innr < 0
    fprintf('The curve radius is smaller than road width');
end
[crvPtSamples_innr,crvPtNum_innr,~] = sampleCurvePointsBasedOnCircle(circleCentr,crvRa_innr,crvAgResl,crvCenAg,initCrvAg,ifClockWise);

% The sample points in the outer curve boundary
crvRa_outr = crvRa + roadWidth;
[crvPtSamples_outr,crvPtNum_outr,finalCrvAg] = sampleCurvePointsBasedOnCircle(circleCentr,crvRa_outr,crvAgResl,crvCenAg,initCrvAg,ifClockWise);    
    
end