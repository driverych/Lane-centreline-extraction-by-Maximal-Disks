% discretizeCentreline 
%   - Discretize the centreline
% 
% Syntax:  [discretePoints,numDiscretePoints] = discretizeCentreline(containerCircles,numCircles,discreteStep)
%
% Input:
%    containerCircles - A matlab matrix to store circle info
%    numCircles - The number of circles
%    discreteStep - The discrete step
%
% Output:
%    discretePoints - Discrete centre points
%    numDiscretePoints - The number of discrete points
%
% Other m-files required: none
%
% Subfunctions: isPointOnSegment
%
% MAT-files required: none
% Abbreviation:
% accum -> accumulated
% seg -> segment
% num -> number
% idx -> index
% fld -> field


function [discretePoints,numDiscretePoints] = discretizeCentreline(containerCircles,numCircles,discreteStep)
    
    % Initialise
    numSegs = numCircles - 1;
    numDiscretePoints = 0;
    fld_coordinates = 1:2; fld_radius = 3;
    discretePoints = [];

    % Run through all segments constructed by circle centres
    for idxSeg = 1:numSegs
        accumDist = 0;
        startPoint = [containerCircles(idxSeg,1),containerCircles(idxSeg,2)];
        endPoint = [containerCircles(idxSeg + 1,1),containerCircles(idxSeg + 1,2)];
%         seg = [startPoint(1),startPoint(2),endPoint(1),endPoint(2)];
        lengthSeg = distancePoint2Point(startPoint,endPoint);
        
        % If lengthS <= discreteStep, store the start point and proceed to
        % the next loop
        if lengthSeg <= discreteStep
            numDiscretePoints = numDiscretePoints + 1;
            discretePoints_temp = containerCircles(idxSeg,:);
            discretePoints = [discretePoints;discretePoints_temp];
            continue
        end
        
        % Store the start point in the containerDiscretePoints
        numDiscretePoints = numDiscretePoints + 1;
        discretePoints_temp = containerCircles(idxSeg,:);
        discretePoints = [discretePoints;discretePoints_temp];
        
        % Find the first discrete point
        segmentStandandVector = (endPoint - startPoint)./lengthSeg;
        discretePoint = startPoint + segmentStandandVector .* discreteStep;
        accumDist = accumDist + discreteStep;
        if accumDist < lengthSeg
            isDiscretPointOnSeg = 1;
        else
            isDiscretPointOnSeg = 0;
        end
%         isDiscretPointOnSeg = isPointOnSegment(discretePoint,seg);

        while isDiscretPointOnSeg
            numDiscretePoints = numDiscretePoints + 1;
            discretePoints_temp(1,fld_coordinates) = discretePoint;
            discretePoints_temp(1,fld_radius) = 0;
            discretePoints = [discretePoints;discretePoints_temp];
            % Find the next discrete point
            discretePoint = discretePoint + segmentStandandVector .* discreteStep;
            accumDist = accumDist + discreteStep;
            if accumDist < lengthSeg
                isDiscretPointOnSeg = 1;
            else
                isDiscretPointOnSeg = 0;
            end            
%             isDiscretPointOnSeg = isPointOnSegment(discretePoint,seg);
        end

    end

    % Here,the endPoint is the last point of the last segment (the last point of the border)
    if discretePoint(1)~=endPoint(1) && discretePoint(2)~=endPoint(2)
        numDiscretePoints = numDiscretePoints + 1;
        discretePoints_temp = containerCircles(idxSeg + 1,:);
        discretePoints = [discretePoints;discretePoints_temp];
    end

end