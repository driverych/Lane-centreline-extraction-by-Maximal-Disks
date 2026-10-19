% findInitialLaneletsOfMap - Store all initial lanelets' IDs and indexes
%
% Syntax:  
%    [lanelet_out,num_inits,idxs_inits,IDs_inits] = findInitialLaneletsOfMap(lanelet_in)
%
% Input:
%    lanelet_in - the lanelet struct
%
% Output:
%    lanelet_out - the lanelet struct
%    num_inits - the number of all initial lanelets
%    idxs_inits - a container to store all indexes of initial lanelets
%    IDs_inits - a container to store all IDs of initial lanelets
%
% Other m-files required: findInitialLanelet.m
% Subfunctions: findInitialLanelet
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% init -> initial lanelet
% num -> number
% idx -> index
% id -> identification

function [lanelet_out,num_inits,idxs_inits,IDs_inits] = findInitialLaneletsOfMap(lanelet_in)
    
% find initial lanelets of oneway lanes
skipOneWay = 0;
[lanelet_in,IDs_inits_oneWay,idxs_inits_oneWay,num_inits_oneWay] = ...
    findInitialLanelet(lanelet_in,skipOneWay);
%save('index_initialLanelet_oneWay.mat','idxs_initLanelets_oneWay');

% find initial lanelets of twoway lanes
skipOneWay = 1;
[lanelet_in,IDs_inits_twoWay,idxs_inits_twoWay,num_inits_twoWay] = ...
    findInitialLanelet(lanelet_in,skipOneWay);
%save('index_initialLanelet_twoWay.mat','idxs_initLanelet_twoWay');

% Combine oneWay and twoWay initial lanelets
idxs_inits = zeros(num_inits_oneWay + num_inits_twoWay,1);
IDs_inits = zeros(num_inits_oneWay + num_inits_twoWay,1);

for idx_initLanelet = 1:num_inits_oneWay
    idxs_inits(idx_initLanelet) = ...
        idxs_inits_oneWay(idx_initLanelet);
    IDs_inits(idx_initLanelet) = ...
        IDs_inits_oneWay(idx_initLanelet);
end

for idx_initLanelet = num_inits_oneWay + 1:num_inits_oneWay + num_inits_twoWay
    idxs_inits(idx_initLanelet) = ...
        idxs_inits_twoWay(idx_initLanelet - num_inits_oneWay);
    IDs_inits(idx_initLanelet) = ...
        IDs_inits_twoWay(idx_initLanelet - num_inits_oneWay);
end

lanelet_out = lanelet_in;
num_inits = num_inits_oneWay + num_inits_twoWay;

end