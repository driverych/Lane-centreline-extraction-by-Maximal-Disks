% distancePoint2Point - Calculate the distance between two points
%
% Syntax:  
%    distance = distancePoint2Point(ponit_1,point_2)
%
% Input:
%    ponit_1 - the first point
%    point_2 - the second point
%
% Output:
%    distance - the distance between 2 points
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation: none

function distance = distancePoint2Point(ponit_1,point_2)

distance = sqrt((ponit_1(1) - point_2(1))^2 + (ponit_1(2) - point_2(2))^2);

end