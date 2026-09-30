%% Introduction of the script
% This script realizes centreline extraction based on MD as follows:
%   Importing lanes into MATLAB workspace
%   Calculate centrelines by maximal disks
%   Visualizing the centrelines of lanes
%   Create figures for the demo lane (Optional)
%   Saving the data

% Abbreviation:
% dir -> directory
% idx -> index

%% Clear workspace and add working path
clear;clc;close all;
waitbars = findall(0, 'Type', 'figure', 'Tag', 'TMWWaitbar');
delete(waitbars);

addpath(genpath(pwd));

%% Import extracted lane data and get initiated
% Import lane list into MATLAB
data_dir = '..\..\0_data\LaneletData\';
% dataName = 'laneList_locn1.mat'; % The data for inD and rounD (locn1~5)
dataName = 'laneList_dummy.mat'; 
data_path = fullfile(data_dir,dataName);
load(data_path);

% Import lanelets into MATLAB, which directions have been aligned
% For maps from inD and rounD only
% dataName = 'alignedLanelet_locn1.mat';
% data_path = fullfile(data_dir,dataName);
% load(data_path);

%% The origin of the map
% utmOrigin.x = 293487.1224; utmOrigin.y = 5629711.58163; % locn1
% utmOrigin.x = 295620.9575; utmOrigin.y = 5628102.04258; % locn2
% utmOrigin.x = 300127.0853; utmOrigin.y = 5629091.0587; % locn3 
% utmOrigin.x = 297631.3187; utmOrigin.y = 5629917.34465; % locn4
% utmOrigin.x = 301221.365; utmOrigin.y = 5641501.341; % locn5

% For dummy circles
utmOrigin.x = 0; utmOrigin.y = 0;

%% Calculate the center lines of the lanes

% If discritize the centreline
discretInfo.isCnlDiscret = 1; discretInfo.cnlDiscretStep = 0.5; % Default is 0.005
[laneList,circlesConnected] = calculateCentreline_MaximalDisk_sixCases(laneList,discretInfo,utmOrigin);

%% Plot the centreline
% For inD and rounD (locn1~5)
% plotCentreline_MaximalDisk(laneList,alignedLanelet,utmOrigin);

% For dummy samples
plotCentreline_MaximalDisk_dummy(laneList,utmOrigin);

%% Save the data
data_dir = '..\..\0_data\centrelineComparasion';
% dataName = 'cnlWithMDP_cnlDiscret_no_locn5.mat';
% dataName = 'cnlWithMDP_cnlDiscret_4dm_locn5.mat';
dataName = 'cnlWithMDP_cnlDiscret_5dm_dummy.mat';
data_path = fullfile(data_dir,dataName);
save(data_path,'laneList');

   
