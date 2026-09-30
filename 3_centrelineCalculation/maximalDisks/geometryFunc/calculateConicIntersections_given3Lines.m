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

function [p_centre,num_point] = calculateConicIntersections_given3Lines(par_Sta_1,par_Sta_2,par_Sta_3)
    p_centre = zeros(2,6);
    A1 = par_Sta_1(1); B1 =par_Sta_1(2); C1 = par_Sta_1(3);
    A2 = par_Sta_2(1); B2 =par_Sta_2(2); C2 = par_Sta_2(3);
    A3 = par_Sta_3(1); B3 =par_Sta_3(2); C3 = par_Sta_3(3);
    % A*x^2 + B*y^2 + 2C*xy + 2D*x + 2E*y + F = 0
    e1 = 1/(A1^2 + B1^2); e2 = 1/(A2^2 + B2^2);e3 = 1/(A3^2 + B3^2);
    A_conic_1 = e1*A1^2 - e2*A2^2; B_conic_1 = e1*B1^2 - e2*B2^2;
    C_conic_1 = e1*A1*B1 - e2*A2*B2; D_conic_1 = e1*A1*C1 - e2*A2*C2;
    E_conic_1 = e1*B1*C1 - e2*B2*C2; F_conic_1 = e1*C1^2 - e2*C2^2;
    
    A_conic_2 = e1*A1^2 - e3*A3^2; B_conic_2 = e1*B1^2 - e3*B3^2;
    C_conic_2 = e1*A1*B1 - e3*A3*B3; D_conic_2 = e1*A1*C1 - e3*A3*C3;
    E_conic_2 = e1*B1*C1 - e3*B3*C3; F_conic_2 = e1*C1^2 - e3*C3^2;
    
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
        end
    end
    
end