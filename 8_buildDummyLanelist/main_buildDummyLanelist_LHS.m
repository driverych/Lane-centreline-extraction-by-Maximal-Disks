%% Introduction of the script
% This script realizes mutiple functions as follows:
%   xxxxx
%   Included angle: 75-105 with delta of 15 (75,90,105)
%   Curvature: inf,1/8,1/16,1/100
%   Accumulated distance: 200
%   Lane width: 1.2-3.6 with delta of 1.2 (1.2,2.4,3.6)

% Abbreviation:
% cntr -> counter
% init -> initial
% num -> number
% dir -> directory
% idx -> index
% fig -> figure
% innr -> inner
% outr -> outer
% rnd -> random
% iter -> iteration
% rd -> radius
% intxn -> intersection
% ag -> angle
% cen -> central
% crv -> curve
% centr -> centre
% rep -> repetition
% est -> estimated
% incl -> included


%% Clear workspace and add working path
clear;clc;close all;
addpath(genpath(pwd))

%% The path to store the data
% Data path
data_dir = '..\0_data\LaneletData\';

%% Basic road parameters
% Road length
roadLgth = 150;

% The initial angle of the curve segment
initCrvAg = 140;
% The circle centre of the curve
circleCentr = [0,0];

% The road width: 1.2, 2.4, 3.6
roadWidth_arr = [1.2; 2.4; 3.6;];
% roadWidth_arr = 1.2;
% The radius of the road curve segment: 8, 16, 50, inf
crvRa_arr = [8; 16; 50;];
% crvRa_arr = 8;
% The intersection angle of two road arms (degrees): 75, 90, 105
armIntxnAg_arr = [75; 90; 105;];
% armIntxnAg_arr = 75;

% The number of iterations: repetition times of resampling
repNum = 1;
% Initialize the road counter: how many roads have been built
roadCntr = 0;
% Initialize the lane list
laneList = struct('leftBoundary',{},'rightBoundary',{});

for idx_roadWidth = 1:size(roadWidth_arr,1)
    % The road width
    roadWidth = roadWidth_arr(idx_roadWidth,:);
    
    % The curvature is not inf
    for idx_crvRa = 1:size(crvRa_arr,1)
        % The curve radius
        crvRa = crvRa_arr(idx_crvRa,:);
        
        for idx_armIntxnAg = 1:size(armIntxnAg_arr,1)
            % Set the point distance resolution
            distResl.arm.innr = 0.5; % Difference on resolution leads to inalignment
            distResl.arm.outr = 0.3;
            distResl.crv = 0.1; % High density in curve leads to more points
            % The number of resampled points on the border:
            % Higher the resolution, more retained sampled points
            resampledPtNum.innr = 25;
            resampledPtNum.outr = 30;  % This difference also causes the inalignment

            % The arm intersection angle
            armIntxnAg = armIntxnAg_arr(idx_armIntxnAg,:);
            
            %% Create the curve
            % The central angle of the curve
            crvCenAg = 360 - 90 - 90 - armIntxnAg;
            % Calculate the curve length
            crvLgth = crvCenAg * (pi/180) * crvRa;
            % The estimated number of sampled points on the curve
            estCrvPtNum = ceil(crvLgth/distResl.crv);
            % The angle resolution of the curve
            crvAgResl = crvCenAg/estCrvPtNum;
            
            % If create the circle clockwisely
            ifClockWise = 1;
            [crvPtSamples_innr,crvPtSamples_outr,crvPtNum_innr,crvPtNum_outr,finalCrvAg] = ...
                createCurveSegment(circleCentr,crvRa,crvAgResl,crvCenAg,initCrvAg,ifClockWise,roadWidth);

            %% Create the first arm
            % The arm length
            armLgth = (roadLgth - crvLgth)/2;
            extLgth = 0;
            % Create the first arm: link to the curve start
            armStrtPt_innr = crvPtSamples_innr(1,:);
            armStrtPt_outr = crvPtSamples_outr(1,:);
            % Rotate the initial curve angle for 90 degrees
            % anti-clock-wisely
            % Reverse direction of the actual arm 
            armDir = initCrvAg + 90; 

            [firstArmPtSamples_innr,firstArmPtSamples_outr,firstArmPtNum_innr,firstArmPtNum_outr] = ...
                createArmSegment(armStrtPt_innr,armStrtPt_outr,armDir,distResl,armLgth,extLgth);

            %% Create the second arm
            % Create the second arm: link to the curve end
            armStrtPt_innr = crvPtSamples_innr(end,:);
            armStrtPt_outr = crvPtSamples_outr(end,:);
            % Rotate the final curve angle for 90 degrees clock-wisely
            % Actual line direction
            armDir = finalCrvAg - 90; 

            [secArmPtSamples_innr,secArmPtSamples_outr,secArmPtNum_innr,secArmPtNum_outr] = ...
                createArmSegment(armStrtPt_innr,armStrtPt_outr,armDir,distResl,armLgth,extLgth);

            %% Assemble the sampled points by tagent-circle rule
            % Duplicated points exsit at the joint of two consecutive
            % segments
            ptNum_innr = firstArmPtNum_innr + (crvPtNum_innr-1) + (secArmPtNum_innr-1);
            ptNum_outr = firstArmPtNum_outr + (crvPtNum_outr-1) + (secArmPtNum_outr-1);
            ptSamples_innr = [flip(firstArmPtSamples_innr);crvPtSamples_innr(2:end,:);secArmPtSamples_innr(2:end,:)];
            ptSamples_outr = [flip(firstArmPtSamples_outr);crvPtSamples_outr(2:end,:);secArmPtSamples_outr(2:end,:)];
            
            %% Resample the border points
            % Select points based on LHS
            % Resample the border points based on LHS
            [laneList,roadCntr] = ...
                resampleBorderPointsBasedOnLHS(resampledPtNum,ptNum_innr,ptNum_outr,ptSamples_innr,ptSamples_outr,repNum,roadCntr,laneList);
            
        end % for idx_armIntxnAg = 1:size(armIntxnAg_arr,1)
    end % for idx_crvRa = 1:size(crvRa_arr,1)
    
    % Empty the used container
    armStrtPt_innr = [];armStrtPt_outr = [];
    firstArmPtSamples_innr = [];firstArmPtSamples_outr = [];
    secArmPtSamples_innr = []; secArmPtSamples_outr = [];
    
    ifClockWise = 1;
    % While the curvature equals inf
    for idx_armIntxnAg = 1:size(armIntxnAg_arr,1)
            % Set the point distance resolution
            distResl.arm.innr = 0.2;
            distResl.arm.outr = 0.15;
            % The number of resampled points on the border:
            % Higher the resolution, more retained sampled points
            resampledPtNum.innr = 30;
            resampledPtNum.outr = 40;  
            
            % The arm intersection angle
            armIntxnAg = armIntxnAg_arr(idx_armIntxnAg,:);
            % The included angle of the curve (with an infinite radius)
            crvCenAg = 360 - 90 - 90 - armIntxnAg;
            % The arm length
            armLgth = (roadLgth - 0)/2;
            % Use the bisector of the included angle
            if ifClockWise == 1 % Create the circle segment clockwisely
                bisectorDir = initCrvAg - crvCenAg/2;
            else
                bisectorDir = initCrvAg + crvCenAg/2;
            end
            bisectorLgth = roadWidth/cosd(crvCenAg/2);
            delta_x = bisectorLgth * cosd(bisectorDir);
            delta_y = bisectorLgth * sind(bisectorDir);
            bisectorVect = [delta_x,delta_y];
            
            %% Create the first arm
            
            % The start of the inner border
            armStrtPt_innr = circleCentr;
            armStrtPt_outr = armStrtPt_innr + bisectorVect;
            % For alignment at the entrance and exit of the road
            extLgth = bisectorLgth * sind(crvCenAg/2);
            
            % Rotate the initial curve angle for 90 degrees
            % anti-clock-wisely
            armDir = initCrvAg + 90; % Reverse direction of the actual arm
            [firstArmPtSamples_innr,firstArmPtSamples_outr,firstArmPtNum_innr,firstArmPtNum_outr] = ...
                createArmSegment(armStrtPt_innr,armStrtPt_outr,armDir,distResl,armLgth,extLgth);
            
            %% Create the second arm
            % Share the same start points with the first arm
            % Use the cross segment
            if ifClockWise == 1 % Create the circle segment clockwisely
                crossDir = initCrvAg - crvCenAg;
            else
                crossDir = initCrvAg + crvCenAg;
            end
            % Rotate the final curve angle for 90 degrees clock-wisely
            % Actual line direction
            armDir = crossDir - 90; 
            [secArmPtSamples_innr,secArmPtSamples_outr,secArmPtNum_innr,secArmPtNum_outr] = ...
                createArmSegment(armStrtPt_innr,armStrtPt_outr,armDir,distResl,armLgth,extLgth);
            
            %% Assemble the sampled points by tagent-circle rule
            ptNum_innr = firstArmPtNum_innr + (secArmPtNum_innr-1);
            ptNum_outr = firstArmPtNum_outr + (secArmPtNum_outr-1);
            ptSamples_innr = [flip(firstArmPtSamples_innr);secArmPtSamples_innr(2:end,:)];
            ptSamples_outr = [flip(firstArmPtSamples_outr);secArmPtSamples_outr(2:end,:)];
            
            %% Resample the border points
            % Select points based on LHS
            % Resample the border points based on LHS
            [laneList,roadCntr] = ...
                resampleBorderPointsBasedOnLHS(resampledPtNum,ptNum_innr,ptNum_outr,ptSamples_innr,ptSamples_outr,repNum,roadCntr,laneList);
    
    end % for idx_armIntxnAg = 1:size(armIntxnAg_arr,1)

end % for idx_roadWidth = 1:size(roadWidth_arr,1)


%% Save the data
% Save laneList
dataName = 'laneList_dummy.mat';
data_path = fullfile(data_dir,dataName);
save(data_path,'laneList');

