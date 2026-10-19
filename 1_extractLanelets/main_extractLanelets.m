% Introduction of the script
% This script performs the following tasks:
%   Reading Lanelet2 map information from an OpenStreetMap XML file
        % The hierarchical structure in OpenStreetMap is:
        %       nodes -> ways -> relations
        % The hierarchical structure in Lanelet2 is:
        %       points -> linestrings -> lanelets
%   Storing map information in MATLAB lanelet and multipolygon structs
%   Identifying lanelet attributes and boundary orientation flags
%   Saving the extracted lanelets
%   Visualizing the lanelets

% Abbreviation:
% orien -> orientation
% traj -> trajectory
% cntr -> counter
% elem -> element
% num -> number
% dir -> directory
% idx -> index
% fig -> figure
% s -> start
% e -> end

%% Clear workspace and add working path
clear;clc;close all;
addpath(genpath(pwd))

%% Import map data and initialize
% Import OpenStreetMap information into MATLAB
map_dir = '..\0_data\mapData\';
mapName = 'demo Lanelet2 map.osm';
% mapName = 'location1_reshapeElems.osm';
% mapName = 'location2_addVer_align_removeMultiPoly.osm';
% mapName = 'location3_addVer_align_topo_removeMultiPoly.osm';
% mapName = 'location4_addVer_align_removeMultiPoly.osm';
% mapName = 'location5_addLanelet_260917.osm';
map_path = fullfile(map_dir,mapName);
mapData = parseXML(map_path);

% The origin
origin.utm_zone = '50N'; % UTM zone
sceID = 7;
origin.utm_x = 736190; 
origin.utm_y = 3565310; 

% For inD and rounD
% origin.utm_zone = '32N'; % UTM zone

% For location 1
% sceID = 1;
% origin.utm_x = 293487.1224;
% origin.utm_y = 5629711.58163;
% For location 2
% sceID = 2;
% origin.utm_x = 295620.9575;
% origin.utm_y = 5628102.04258;
% For location 3
% sceID = 3;
% origin.utm_x = 300127.0853;
% origin.utm_y = 5629091.0587;
% For location 4
% sceID = 4;
% origin.utm_x = 297631.3187;
% origin.utm_y = 5629917.34465;
% For 3_bergheim_roemer
% sceID = 5; 
% origin.utm_x = 301221.365; 
% origin.utm_y = 5641501.341;

%% Establish a lanelet struct
[multiPoly,cntrMultipoly,lanelet,cntrLanelet] = extractLanelets(mapData,origin,sceID);

%% Save the lanelets
data_dir = '..\0_data\LaneletData\';
% The originalLanelet files store basic lanelet information; boundaries
% are not inverted or flipped (but inverted/flipped flags are added)
dataName = 'originalLanelet_demo.mat'; 
% dataName = 'originalLanelet_locn1.mat';
% dataName = 'originalLanelet_locn2.mat';
% dataName = 'originalLanelet_locn3.mat';
% dataName = 'originalLanelet_locn4.mat';
% dataName = 'originalLanelet_locn5.mat';
data_path = fullfile(data_dir,dataName);
save(data_path,'lanelet');

% Save the multipolygon
dataName = 'originalMultiPoly_demo.mat'; 
% dataName = 'originalMultiPoly_locn1.mat';
% dataName = 'originalMultiPoly_locn2.mat';
% dataName = 'originalMultiPoly_locn3.mat';
% dataName = 'originalMultiPoly_locn4.mat';
% dataName = 'originalMultiPoly_locn5.mat';
data_path = fullfile(data_dir,dataName);
save(data_path,'multiPoly');
%% Visualize the lanelet struct
% Plot points
% Initialize figure counter
cntrFig = 1;
% Plot the original lanelets (originalLanelet.mat)
figure(cntrFig);
num_lanelets = cntrLanelet;
plotOriginalLanelets(lanelet,num_lanelets,origin);
plotOriginalMultiPolys(multiPoly,cntrMultipoly,origin);

% Plot the lanelets with inverted boundaries
cntrFig = cntrFig + 1;
figure(cntrFig);
plotLanelets_withInversion(lanelet,cntrLanelet);

% Plot driving roads only
cntrFig = cntrFig + 1;
figure(cntrFig);
plotDrivingRoad(lanelet,cntrLanelet,origin);

% Plot multipolygons only
cntrFig = cntrFig + 1;
figure(cntrFig);
plotOriginalMultiPolys(multiPoly,cntrMultipoly,origin);

