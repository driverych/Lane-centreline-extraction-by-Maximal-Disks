% filterLigatureCirclesByBorderInterference - Remove ligature circles that
% interfere with lane border segments.
%
% TODO gpt ver: This validation is used after ligature compensation because
% the generated compensation circles do not pass through the original
% extractInscribedCircles_* interference checks.

function [CC_lgt_valid,radius_lgt_valid,keepFlags] = filterLigatureCirclesByBorderInterference(CC_lgt,radius_lgt,lanePoints,tangentBorderSegIdx)

if isempty(CC_lgt)
    CC_lgt_valid = CC_lgt;
    radius_lgt_valid = radius_lgt;
    keepFlags = [];
    return
end

radius_lgt = radius_lgt(:);
keepFlags = true(size(CC_lgt,1),1);
epsilon = 0.00001; % TODO gpt ver: Match the tolerance style used by nearby circle-border interference checks.

leftPoints = lanePoints(lanePoints(:,1)>0,:);
rightPoints = lanePoints(lanePoints(:,1)<0,:);
borderSegments = [];

for idxLeftPoint = 1:size(leftPoints,1)-1
    segIdx = leftPoints(idxLeftPoint,1);
    pointS = leftPoints(idxLeftPoint,2:3);
    pointE = leftPoints(idxLeftPoint+1,2:3);
    borderSegments = [borderSegments;segIdx,pointS,pointE]; % TODO gpt ver: Store left border segment for ligature interference filtering.
end

for idxRightPoint = 1:size(rightPoints,1)-1
    segIdx = rightPoints(idxRightPoint,1);
    pointS = rightPoints(idxRightPoint,2:3);
    pointE = rightPoints(idxRightPoint+1,2:3);
    borderSegments = [borderSegments;segIdx,pointS,pointE]; % TODO gpt ver: Store right border segment for ligature interference filtering.
end

for idxCircle = 1:size(CC_lgt,1)
    center = CC_lgt(idxCircle,:);
    radius = radius_lgt(idxCircle);

    if radius <= epsilon || any(isnan(center)) || isnan(radius)
        keepFlags(idxCircle) = false; % TODO gpt ver: Drop invalid compensation circles before they become centreline points.
        continue
    end

    for idxSeg = 1:size(borderSegments,1)
        segIdx = borderSegments(idxSeg,1);
        if segIdx == tangentBorderSegIdx
            continue
        end

        pointS = borderSegments(idxSeg,2:3);
        pointE = borderSegments(idxSeg,4:5);
        distStart = distancePoint2Point(center,pointS);
        distEnd = distancePoint2Point(center,pointE);

        isStartPointInCircle = distStart < radius - epsilon;
        isEndPointInCircle = distEnd < radius - epsilon;
        if isStartPointInCircle || isEndPointInCircle
            keepFlags(idxCircle) = false; % TODO gpt ver: Remove circles containing any non-tangent border endpoint.
            break
        end

        parSegSta = standardFormEquFrom2Points(pointS,pointE);
        distLine = distancePoint2Line(center,parSegSta);
        if distLine >= radius - epsilon
            continue
        end

        angleStart = (center(1) - pointS(1))*(pointE(1) - pointS(1)) + ...
            (center(2) - pointS(2))*(pointE(2) - pointS(2));
        angleEnd = (center(1) - pointE(1))*(pointS(1) - pointE(1)) + ...
            (center(2) - pointE(2))*(pointS(2) - pointE(2));

        if angleStart > 0 && angleEnd > 0
            keepFlags(idxCircle) = false; % TODO gpt ver: Remove circles crossing any non-tangent border segment.
            break
        end
    end
end

CC_lgt_valid = CC_lgt(keepFlags,:);
radius_lgt_valid = radius_lgt(keepFlags,:);

end
