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

function [samples,ptNum] = sampleLinePointsBasedOnUnitVector(strtPt,unitVect,lineSegLgth,unitSegLgth)
    % The point counter
    ptCntr = 0;
    % The accumulated length of the line segement
    accumLgth = 0;
    % Initilize the current point
    currPt = strtPt;
    % Initialize the sampled point container
    samples = [];
    
    while accumLgth < lineSegLgth
        % Add one point
        ptCntr = ptCntr + 1;
        % The current point coordinates
        currPt = currPt + unitVect;
        % The accumulated distance of the line
        accumLgth = accumLgth + unitSegLgth;
        % Add the point to the container
        samples = [samples;currPt];
    end
    
    % The number of points
    ptNum = ptCntr;
end