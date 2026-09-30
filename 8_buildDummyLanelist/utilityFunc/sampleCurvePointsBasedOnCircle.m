% samplePointsOnCircle - Samples the circle defined by the centre and  
%                        the radius, at the angular resolution provided.
%                        The central angle is from 0 to 180 degrees
%
% Syntax:  
%    [x,y] = samplePointsOnCircle(centre,radius,angRes)
%
% Input:
%    circleCentr - the coordinate of the circle center
%    circleRa - the radius of the circle
%    agResl - the resolution of the circle central angle (in degree)
%    tgtAgRng - the target angle range of the central angle (in degree)
%    initAg - the initial angle of the curve (in degree)
%    ifClockWise - if to create the curve clockwisely
%
% Output:
%    x - a n by 1 array to store x coordinates of the sample points
%    y - a n by 1 array to store y coordinates of the sample points
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% num -> number
% idx -> index
% ang -> angle
% resl -> resolution
% ag -> angle
% rng -> range
% init -> initial

function [sampledPts,ptNum,finalAg] = sampleCurvePointsBasedOnCircle(circleCentr,circleRa,agResl,tgtAgRng,initAg,ifClockWise)
    % The point counter
    ptCntr = 0;
    % The total number of points
    ptNum = ceil(tgtAgRng/agResl);
    % The container to store the created points
    sampledPts = zeros(ptNum,2);
    for idxPt = 1:ptNum
        % Add one point
        ptCntr = ptCntr + 1;
        if ifClockWise == 1 % Create the circle segment clockwisely
            % The current angle of the point
            currAg = initAg - idxPt * agResl;
            delta_x = circleRa * cosd(currAg);
            delta_y = circleRa * sind(currAg);
            sampledPts(ptCntr,1:2) = [circleCentr(1,1)+delta_x, circleCentr(1,2)+delta_y];
        else % Create the circle segment anti-clockwisely
            % The current angle of the point
            currAg = initAg + idxPt * agResl;
            delta_x = circleRa * cosd(currAg);
            delta_y = circleRa * sind(currAg);
            sampledPts(ptCntr,1:2) = [circleCentr(1,1)+delta_x, circleCentr(1,2)+delta_y];
        end
    end
    
    % The final angle of the curve
    finalAg = currAg; % The last current angle

end