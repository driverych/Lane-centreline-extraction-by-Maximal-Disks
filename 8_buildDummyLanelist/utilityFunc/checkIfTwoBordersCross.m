
function ifInnrCrossOutr = checkIfTwoBordersCross(innrPts,outrPts)
 
% The number of points
ptNum_innr = size(innrPts,1);
ptNum_outr = size(outrPts,1);

for idx_innr = 1:ptNum_innr-1
    % Extract one segment from the inner border
    innrSeg_strtPt = innrPts(idx_innr,:);
    innrSeg_endPt = innrPts(idx_innr+1,:);
    innrSeg_SI = pointSlopeEquFrom2Points(innrSeg_strtPt,innrSeg_endPt);
    
    for idx_outr = 1:ptNum_outr-1
        % Extract one segment from the outr border
        outrSeg_strtPt = outrPts(idx_outr,:);
        outrSeg_endPt = outrPts(idx_outr+1,:);
        outrSeg_SI = pointSlopeEquFrom2Points(outrSeg_strtPt,outrSeg_endPt);
        
        % The intersection point of the two border segments
        intxnPt = intersectionFrom2Lines(innrSeg_SI,outrSeg_SI);
        
        % Judge if the intersection point is on either of the segments
        isIntxnPtOnInnrSeg = isPointOnSegment_byLength(intxnPt,[innrSeg_strtPt,innrSeg_endPt]);
        isIntxnPtOnOutrSeg = isPointOnSegment_byLength(intxnPt,[outrSeg_strtPt,outrSeg_endPt]);
        
        if isIntxnPtOnInnrSeg && isIntxnPtOnOutrSeg % Actually, one discriminant is enough
            ifInnrCrossOutr = 1; % Two borders are crossing
%             % * * * Plot the lines for test * * *
%             figure
%             plot([innrSeg_strtPt(1,1),innrSeg_endPt(1,1)],[innrSeg_strtPt(1,2),innrSeg_endPt(1,2)],'k-');
%             hold on
%             plot([outrSeg_strtPt(1,1),outrSeg_endPt(1,1)],[outrSeg_strtPt(1,2),outrSeg_endPt(1,2)],'k-');
%             plot(intxnPt(1,1),intxnPt(1,2),'r*');
            return % No need to preceed
        end % if isIntxnPtOnInnrSeg || isIntxnPtOnOutrSeg
    
    end % for idx_outr = 1:ptNum_outr-1
    
end % for idx_innr = 1:ptNum_innr-1

% No crossing is found
ifInnrCrossOutr = 0;

end