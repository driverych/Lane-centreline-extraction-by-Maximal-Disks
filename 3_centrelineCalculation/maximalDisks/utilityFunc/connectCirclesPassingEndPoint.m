% connectCirclesPassingEndPoint
%   - Sequence the centre points whose circles pass the end point.
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCirclesPassingEndPoint(segL,circles_end,numCircles,circlesConnected)
%
% Input:
%    segL - The chosen left segment
%    circles_end - A matlab matrix of all circles passing by the end point
%    numCircles - The number of cirlces
%    circlesConnected - A matlab matrix to store circle info in sequence
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions: cosValues
%
% MAT-files required: none
%
% Abbreviation:
% seg -> segment
% num -> number
% cos -> cosine
% fld -> field
% idx -> index
% R -> right
% L -> left

function [circlesConnected,numCircles] = ...
            connectCirclesPassingEndPoint(segL,circles_end,numCircles,circlesConnected)

% The field of the coordinates of circle centres
fld_circleCentre = 1:2;  

% Initialise
numCircles_end = size(circles_end,1); 
isLeftDiscriminant = zeros(numCircles_end,1);
cosValues = zeros(numCircles_end,1);

for idxCircle_end = 1:numCircles_end
    circleCentre = circles_end(idxCircle_end,fld_circleCentre);
    % isLeft discriminant
    isLeftOfSeg = isPointLeftOfLine(circleCentre,segL);
    isLeftDiscriminant(idxCircle_end,1) = isLeftOfSeg;
    % Calculate the vector (endNode - startNode)
    endPoint = segL(1:2);
    endPoint = segL(3:4);
    vector1 = endPoint - endPoint;
    vector2 = circleCentre - endPoint;
    % Calculate the cos values
    cosValue = cosAngle(vector1,vector2);
    cosValues(idxCircle_end,1) = cosValue;
end

% Sort circles with their centres on the right side of the left segment
idxs_CC_rightSide = find(isLeftDiscriminant == 0);
cosValues_onRightSide = cosValues(idxs_CC_rightSide,:);
[~,idx_CC_rightSide_ascend] = sort(cosValues_onRightSide,'ascend');

% Sort circles with their centres on the left side of the left segment
if sum(isLeftDiscriminant)>0
    idxs_CC_leftSide = find(isLeftDiscriminant == 1);
    cosValues_onLeftSide = cosValues(idxs_CC_leftSide,:);
    [~,idx_CC_leftSide_descend] = sort(cosValues_onLeftSide,'descend');
else
    idx_CC_leftSide_descend = [];
end

idxs_direction = [idx_CC_rightSide_ascend;idx_CC_leftSide_descend];
circlesConnected_temp = circles_end(idxs_direction,:);

circlesConnected = [circlesConnected;circlesConnected_temp];
numCircles = numCircles + numCircles_end;

% % Resample the circles
% endPoint = segL(1,3:4);
% num_resampledPoints = 1;
% resampledCircles = [];
% resampledCircles = [resampledCircles;circlesConnected_temp(1,:)];
% 
% if numCircles_end > 1
%     for idxCircle = 1:numCircles_end-1
%         % initialize with the next point
%         resampledCircles = [resampledCircles; circlesConnected_temp(idxCircle+1,:)];
%         num_resampledPoints = num_resampledPoints + 1;
%         
%         circleCentre_1 = circlesConnected_temp(idxCircle,1:2);
%         radius_1 = circlesConnected_temp(idxCircle,3);
%         circleCentre_2 = circlesConnected_temp(idxCircle+1,1:2);
%         radius_2 = circlesConnected_temp(idxCircle+1,3);
%         vector_1 = circleCentre_1 - endPoint;
%         vector_2 = circleCentre_2 - endPoint;
%         
%         radius_3 = (radius_1 + radius_2)/2;
%         vector_3 = vector_1/norm(vector_1) + vector_2/norm(vector_2);
%         vector_3 = vector_3/norm(vector_3) * radius_3;
%         circleCentre_3 = endPoint + vector_3;
%         resampledCircles(num_resampledPoints,1:2) = circleCentre_3;
%         resampledCircles(num_resampledPoints,3) = radius_3;
%         
%         % Add the next point
%         resampledCircles = [resampledCircles; circlesConnected_temp(idxCircle+1,:)];
%         num_resampledPoints = num_resampledPoints + 1;
%     end
%     
% else
%     num_resampledPoints = numCircles_end;
%     resampledCircles = circlesConnected_temp;
%     
% end
% 
% circlesConnected = [circlesConnected;resampledCircles];
% numCircles = numCircles + num_resampledPoints;

% % Resample the circles
% endPoint = segL(1,3:4);
% num_resampledPoints = 1;
% resampledCircles = [];
% resampledCircles = [resampledCircles;circlesConnected_temp(1,:)];
% 
% if numCircles_end > 1
%     for idxCircle = 1:numCircles_end-1
%         % initialize with the next point
%         resampledCircles = [resampledCircles; circlesConnected_temp(idxCircle+1,:)];
%         num_resampledPoints = num_resampledPoints + 1;
%         
%         circleCentre_1 = circlesConnected_temp(idxCircle,1:2);
%         radius_1 = circlesConnected_temp(idxCircle,3);
%         circleCentre_2 = circlesConnected_temp(idxCircle+1,1:2);
%         radius_2 = circlesConnected_temp(idxCircle+1,3);
%         vector_1 = circleCentre_1 - endPoint;
%         vector_2 = circleCentre_2 - endPoint;
%         
%         radius_3 = (radius_1 * radius_2) * 2/(radius_1 + radius_2);
%         vector_3 = vector_1/norm(vector_1) + vector_2/norm(vector_2);
%         vector_3 = vector_3/norm(vector_3) * radius_3;
%         circleCentre_3 = endPoint + vector_3;
%         resampledCircles(num_resampledPoints,1:2) = circleCentre_3;
%         resampledCircles(num_resampledPoints,3) = radius_3;
%         
%         % Add the next point
%         resampledCircles = [resampledCircles; circlesConnected_temp(idxCircle+1,:)];
%         num_resampledPoints = num_resampledPoints + 1;
%     end
%     
% else
%     num_resampledPoints = numCircles_end;
%     resampledCircles = circlesConnected_temp;
%     
% end
% 
% circlesConnected = [circlesConnected;resampledCircles];
% numCircles = numCircles + num_resampledPoints;




end        