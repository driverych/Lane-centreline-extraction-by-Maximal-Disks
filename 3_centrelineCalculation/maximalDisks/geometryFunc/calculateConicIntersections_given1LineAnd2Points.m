% findCircleCentre_tangent3Lines - 
%       Find the centre of a circle which is tangent to 3 lines.
% 
% Syntax:  [p_centre,num_point] = findCircleCentre_tangent3Lines(par_Sta_1,par_Sta_2,par_Sta_3)
%
% Input:
%    par_Sta_1 - The parameters of a standform line equation
%    par_Sta_2 - The parameters of a standform line equation
%    par_Sta_3 - The parameters of a standform line equation
%
% Output:
%    p_centre - An array contains circle centre coordinates
%    num_point - The number of found circle center
%
% Other m-files required: intersectConics.m 
% Subfunctions: intersectConics
% MAT-files required: none

function [p_centre,num_point] = calculateConicIntersections_given1LineAnd2Points(point_1,point_2,par_Sta)

    % Initialize the circle centre container
    p_centre = zeros(1,6);
    
    % Parse the input
    x_1 = point_1(1); y_1 =point_1(2);
    x_2 = point_2(1); y_2 =point_2(2);
    A = par_Sta(1); B = par_Sta(2); C = par_Sta(3);
    % A*x^2 + B*y^2 + 2C*xy + 2D*x + 2E*y + F = 0
    % A = A_conic_1， C = C_conic_1
    e = (A^2 + B^2);
    A_conic_1 = 0; B_conic_1 = 0;
    C_conic_1 = 0; D_conic_1 = x_2 - x_1;
    E_conic_1 = y_2 - y_1; F_conic_1 = x_1^2 + y_1^2 - x_2^2 - y_2^2;
    
    A_conic_2 = A^2 - e; B_conic_2 = B^2 - e;
    C_conic_2 = A*B; D_conic_2 = A*C + e*x_1;
    E_conic_2 = B*C + e*y_1; F_conic_2 = C^2 - e*(x_1^2 + y_1^2);
    
    E1 = [A_conic_1 C_conic_1 D_conic_1; ...
        C_conic_1 B_conic_1 E_conic_1; ...
        D_conic_1 E_conic_1 F_conic_1];
    E2 = [A_conic_2 C_conic_2 D_conic_2; ...
        C_conic_2 B_conic_2 E_conic_2; ...
        D_conic_2 E_conic_2 F_conic_2];

    % P_candidate is in column, not in row
    p_cand = intersectConics(E1, E2);
    
    if isempty(p_cand)
        p_centre = [];
        num_point = 0;
    else
        % P_centre is in row, not in column
        num_point = numel(p_cand(1,:));
        for idx_point = 1:num_point
            p_centre(idx_point,1) = p_cand(1,idx_point)/p_cand(3,idx_point);
            p_centre(idx_point,2) = p_cand(2,idx_point)/p_cand(3,idx_point);
            % * * * Plot the circle for test * * *
%             plot(point_1(1,1),point_1(1,2),'ro');
%             hold on
%             plot(point_2(1,1),point_2(1,2),'ro');
%             radius = distancePoint2Line(p_centre,par_Sta);
%             plotSingleCircle(p_centre(idx_point,1:2),radius,'#000000','#EDB120');
%             axis equal
        end
    end

% point_1 = [-6 6];  point_2 = [6 1];  point_3 = [-1 -sqrt(2)]; point_4 = [1 -sqrt(2)]; 
% par_Sta = standardFormEquFrom2Points(point_3,point_4);    
% point_1 = [43.639877703855745 -53.303782161325216];  point_2 = [30.736205011315178 -58.504352213814855];
% par_Sta = [6.590671758167446, -6.949174531851895, -6.580333949595458e+02];
% [p_centre,num_point] = calculateConicIntersections_given1LineAnd2Points(point_1,point_2,par_Sta);  
% line([point_3(1),point_4(1)],[point_3(2),point_4(2)]);
    
end