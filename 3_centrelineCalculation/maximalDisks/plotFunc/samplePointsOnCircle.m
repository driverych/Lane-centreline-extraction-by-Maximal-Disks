% samplePointsOnCircle - Samples the circle defined by the centre and  
%                        the radius, at the angular resolution provided
%
% Syntax:  
%    [x,y] = samplePointsOnCircle(centre,radius,angRes)
%
% Input:
%    centre - the coordinate of the circle center
%    radius - the radius of the circle
%    angRes - the color of the circle center
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
% res -> resolution
% num -> number
% idx -> index
% ang -> angle

function [x,y] = samplePointsOnCircle(centre,radius,angRes)
    cntr_point = 0;
    num_point = ceil(2*pi/angRes) + 1;
    samples = zeros(num_point,2);
    for idx = 1:num_point
        cntr_point = cntr_point + 1;
        ang = -pi + idx * angRes;
        delta_x = radius * cos(ang);
        delta_y = radius * sin(ang);
        samples(cntr_point,1:2) = [centre(1)+delta_x,centre(2)+delta_y];
    end
    x = samples(:,1);
    y = samples(:,2);
end