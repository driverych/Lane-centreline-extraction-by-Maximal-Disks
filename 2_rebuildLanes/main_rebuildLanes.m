%% Introduction of the script
% This script realizes multiple functions as follows:
%   Importing extracted lanelets into MATLAB workspace
%   Finding all initial lanelets of lanes
%   Building lanes from found initial lanelets
%   Visualizing the lanes
%   Saving the data

% Abbreviation:
% cntr -> counter
% init -> initial
% num -> number
% dir -> directory
% idx -> index
% fig -> figure

%% Clear workspace and add working path
clear;clc;close all;
addpath(genpath(pwd))

%% Import extracted lanelet data
% Import lanelet struct into MATLAB
data_dir = '..\0_data\LaneletData\';
% The originalLanelet store the basic lanelet info, and their boundaries
% are not inverted or flipped (but inverted/flipped flags are added)
% dataName = 'originalLanelet_demo.mat'; 
% dataName = 'originalLanelet_locn1.mat';
% dataName = 'originalLanelet_locn2.mat';
% dataName = 'originalLanelet_locn3.mat';
% dataName = 'originalLanelet_locn4.mat';
dataName = 'originalLanelet_locn5.mat'; 
data_path = fullfile(data_dir,dataName);
load(data_path);

%% Find initial lanelets of lanes
% Find all initial lanelets and update lanelet struct
[lanelet,num_initLanelets,idxs_initLanelet,~] = findInitialLaneletsOfMap(lanelet);

%% Build lanes from lanelets
% Build both lane boundaries from lanelet boundaries
% Build loop-free lane paths without modifying static topology.
[lanelet,idxs_laneLanelets] = ...
    buildLanes_DFS_noLoop(lanelet,num_initLanelets,idxs_initLanelet);

% Align all lanelets and build a new lanelet struct
alignedLanelet = alignLaneletMap(lanelet);

% Build consecutive lanes (connect separate lanelets together)
laneList = buildConsecutiveLanes(idxs_laneLanelets,alignedLanelet);
[laneList,idxs_laneLanelets] = removeDuplicatedLanes(laneList,idxs_laneLanelets);

%% Extract lane polygon
% lanePolygons = extractLanePolygons(laneList);

%% Extract Lanelet IDs in the lanes
IDs_laneLanelets = convertLaneletIndexListIntoIDList(alignedLanelet,idxs_laneLanelets);

%% Plot separate lanes

% utmOrigin.x = 736190; utmOrigin.y = 3565310; % demo
% utmOrigin.x = 293487.1224; utmOrigin.y = 5629711.58163; % locn1
% utmOrigin.x = 295620.9575; utmOrigin.y = 5628102.04258; % locn2
% utmOrigin.x = 300127.0853; utmOrigin.y = 5629091.0587; % locn3
% utmOrigin.x = 297631.3187; utmOrigin.y = 5629917.34465; % locn4
utmOrigin.x = 301221.365; utmOrigin.y = 5641501.341; % locn5 

cntrFig = 0;
origin.x = utmOrigin.x;
origin.y = utmOrigin.y;
mapPath = data_path;
cntrFig = plotLanes(laneList,cntrFig,mapPath,origin);

% Plot the separate Lanelets
cntrFig = cntrFig + 1;
figure(cntrFig);
plotLanelets_distinguishBoundaries(lanelet,origin);

cntrFig = cntrFig + 1;
figure(cntrFig);
plotLanelets_distinguishBoundaries(alignedLanelet,origin);

% Save data
% Save aligned lanelets
data_dir = '..\0_data\LaneletData\';
dataName = 'alignedLanelet_locn5.mat'; 
% dataName = 'alignedLanelet_demo.mat';
data_path = fullfile(data_dir,dataName);
save(data_path,'alignedLanelet');
% Save laneList
dataName = 'laneList_locn5.mat'; 
% dataName = 'laneList_demo.mat'; 
data_path = fullfile(data_dir,dataName);
save(data_path,'laneList');
% Save Lanelet ID lists of all lanes
dataName = 'laneList_LaneletID_locn5.mat';
% dataName = 'laneList_LaneletID_demo.mat'; 
data_path = fullfile(data_dir,dataName);
save(data_path,'IDs_laneLanelets');
