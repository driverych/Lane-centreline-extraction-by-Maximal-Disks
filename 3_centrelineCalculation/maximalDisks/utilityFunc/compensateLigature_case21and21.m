
% Case 60 comes first and then Case 21
% The centreline, starting from CC of Case60 and ending with CC of Case21,
% is a piece of the ligature

function circlesConnected_updated = compensateLigature_case21and21(circlesConnected_updated,circlesConnected,rowLocn_Case21_1,rowLocn_Case21_2,fld,rowLocns_lgt,lanePoints,idxLgt)

% Touching point (constraint point passed by MD) is the base point of Case
% 21
proj_CC2Base_Case21_1 = circlesConnected(rowLocn_Case21_1,fld.ProjOnBaseSeg);

% Extract the target 2 segment of the Case 21_1
tgtSeg_2Idx_Case21_2 = circlesConnected(rowLocn_Case21_1,fld.tgtSeg_2Idx);

% Extract the target 1 segment of the Case 21_1
tgtSeg_1Idx_Case21_1 = circlesConnected(rowLocn_Case21_2,fld.tgtSeg_1Idx);

% The circle centres
CC_Case21_1 = circlesConnected(rowLocn_Case21_1,fld.CC);
CC_Case21_2 = circlesConnected(rowLocn_Case21_2,fld.CC);


% ------------------------- plot for test -------------------------
% % The touching points on the border
% % Extract the projection point on the target 2 segment of Case 21
% projPt2tgt_2_Case21 = circlesConnected(rowLocn_Case21_1,fld.ProjOnTgtSeg_2);
% % Extract the projection point on the base segment of Case 50
% projPt2tgt_1_Case50 = circlesConnected(rowLocn_Case21_2,fld.ProjOnTgtSeg_1);
% % Plot the projection points
% plot(projPt2tgt_2_Case21(1,1),projPt2tgt_2_Case21(1,2),'ok');
% plot(projPt2tgt_1_Case50(1,1),projPt2tgt_1_Case50(1,2),'ok');
% % Plot the identified centreline piece of the ligature
% plotLigature(rowLocns_lgt(idxLgt,:),circlesConnected);

% If the base segment and target_1 segment are not at the same border of
% the lane, return
if tgtSeg_2Idx_Case21_2*tgtSeg_1Idx_Case21_1 < 0
    return
end

% The number of border segments of interest: negative index is on the
% right border while positive on the left border
numBorderSegs = abs(tgtSeg_1Idx_Case21_1) - abs(tgtSeg_2Idx_Case21_2) + 1;

% There are MDs touching the baseSeg_Case60 and tgtSeg_1_Case21. However,
% there are no MDs in between baseSeg_Case60 and tgtSeg_1_Case21, if the
% additional border exsits.
% The first and last border segments are baseSeg_Case60 and
% tgtSeg_1_Case21.
for idxBorderSeg = 1:numBorderSegs
    % Get the border index
    if tgtSeg_2Idx_Case21_2 > 0 % On the left border
        borderSegIdx = tgtSeg_2Idx_Case21_2 + idxBorderSeg - 1;
    else % On the right border
        borderSegIdx = -(abs(tgtSeg_2Idx_Case21_2) + idxBorderSeg - 1);
    end
    
    % Extract the start point of the border segment
    strtPt_borderSeg = lanePoints(lanePoints(:,1) == borderSegIdx,2:3);
    
    % Calculate the line equation of the border segment
    % Get the end point of the border segment
    if tgtSeg_2Idx_Case21_2 > 0 % left border
        endPt_borderSeg = lanePoints(lanePoints(:,1) == borderSegIdx + 1,2:3);
    else % right border
        endPt_borderSeg = lanePoints(lanePoints(:,1) == borderSegIdx - 1,2:3);
    end
    
    % The length of the border segment
    lgthBorderSeg = distancePoint2Point(strtPt_borderSeg,endPt_borderSeg);
    
    % The line expression: start point with a direction vector
    [strtPt_borderSeg, vctr_borderSeg] = calculateLineFrom2Points(strtPt_borderSeg',endPt_borderSeg');

    % Calculate circle centres in the ligature
    % CC_lgt = createCirclesInTheLigatureAlongTheSameTgtSeg(strtPt_borderSeg,vctr_borderSeg,CC_Case21_1,CC_Case21_2,proj_CC2Base_Case21_1,lgthBorderSeg); % gpt ver: Original ligature centre-only generation kept for reference.
    [CC_lgt,radius_lgt] = createCirclesInTheLigatureAlongTheSameTgtSeg(strtPt_borderSeg,vctr_borderSeg,CC_Case21_1,CC_Case21_2,proj_CC2Base_Case21_1,lgthBorderSeg); % TODO gpt ver: Generate ligature centres and radii for interference filtering.
    [CC_lgt,radius_lgt] = filterLigatureCirclesByBorderInterference(CC_lgt,radius_lgt,lanePoints,borderSegIdx); % TODO gpt ver: Remove ligature circles that interfere with lane borders.
    % The number of points for ligature
    numPts = size(CC_lgt,1);
    if numPts > 0
        % circlesConnected_updated = [circlesConnected_updated;[CC_lgt(1:end,:),zeros(numPts,15)]]; % gpt ver: Original insertion without radius/interference filtering kept for reference.
        circlesConnected_updated = [circlesConnected_updated;[CC_lgt(1:end,:),radius_lgt(1:end,:),zeros(numPts,14)]]; % TODO gpt ver: Preserve radius and append only validated ligature circles.
    end        
end

end