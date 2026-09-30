% isIndexContinous
%   - Judge if the found counters are continuous
%   - Examples:
%     continous: 4 5 6 7 8 9 10
%     incontinous: 4 5 9 10 11 12
%                      |
%               this index will be pushed back
% 
% Syntax:  [isIndexCont,breakingCntr] = isIndexContinous(cntrMatrix_Points)
%
% Input:
%    cntrMatrix_Points - A matrix storing the row number of the points in
%                        the point matrix
%
% Output:
%    isIndexCont - 0 indenfies the row numbers are not continous
%    breakingCntr - The counter/index of the first uncontinous number
%
% Subfunctions: none
%
% MAT-files required: none
% Abbreviation:
% idx -> index
% num -> number


function [isIndexCont,breakingCntr] = isIndexContinous(cntrMatrix_Points)

% The number of points
numPoints = size(cntrMatrix_Points,1);

% Current idx minus the former idx
discriminant = cntrMatrix_Points(2:numPoints,1) - cntrMatrix_Points(1:numPoints-1,1);

% The sum should be equivelant to numPoints-1 if indexes are continous
if sum(discriminant) ~= (numPoints-1)
    isIndexCont = 0;
    % Find the first index that causes the incontinuity
    idxs_latterPart = find(discriminant~=1);
    breakingCntr = idxs_latterPart(1,1)+1;
else
    isIndexCont = 1;
    breakingCntr = 0;
end

end