% C1 = [1 0 0; 0 1 0; 0 0 -1];
% C2 = [1/2 0 0; 0 -1 0; 0 0 -1];
% 
% plotConic(C1)

% Intersection of conics matlab functions
% For more info: www.pigei.com or pierluigi.taddei@polimi.it
close all;
clc;clear;
%%example usage
%%the homogeneous representation of a conic is a matrix
%% m = [A C D; C B E; D E F] that represents the equation
%% A x^2 + B y^2 + 2C xy + 2D x + 2Ey + F = 0
A1 = 0.5; B1= -1; C1= 0.05; D1= 0; E1= 0; F1= 1;
A2 = -1; B2= 1; C2= 0; D2= 0; E2= 0; F2= 1;

%a circle centered in the origin
% E1 = [1 0 0; 0 1 0; 0 0 -3]
% E1 = [1 0 0; 0 0 -0.5; 0 -0.5 0]
E1 = [A1 C1 D1; C1 B1 E1; D1 E1 F1];

%an ellipse centered in the origin
% E2 = [1 0 0; 0 3 0; 0 0 -6]
% E2 = [3 0 0; 0 0 -0.5; 0 -0.5 -2]
E2 = [A2 C2 D2; C2 B2 E2; D2 E2 F2];

%get the four homogeneous intersections
P = intersectConics(E1, E2);
hold on;
plotConic(E1);
plotConic(E2);

if (isempty(P)==0)
    % plot the normalized points
    plot(P(1,:) ./ P(3,:) , P(2,:) ./ P(3,:), 'ro');
%     plot(P(1,:) , P(2,:) , 'ro');
end