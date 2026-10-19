% storeInitialLaneletID - Store initialLanelet ID into container only if 
%                         it is unique. If not, continue to find the 
%                         previous lanelet before the initial lanelet 
%                         has been found
%
% Syntax:  
%    [IDs_inits_out,idxs_inits_out,cntrInits_out] = ...
%    storeInitialLaneletID(IDs_inits_in,idxs_inits_in,cntrInits_in,ID_initLanelet,idx_initLanelet)
%
% Input:
%    lanelet_in - the lanelet struct
%    lanelet_inloop - the imported single lanelet, of which a previous
%                     lanelet is to be found
%
% Output:
%    lanelet_out - the lanelet struct
%    prevLanelet - the found previous lanelet
%
% Other m-files required: isUnique.m
% Subfunctions: isUnique
% MAT-files required: none
% Abbreviation:
% cntr -> counter
% cand -> candidate
% prev -> previous
% init -> initial lanelet
% num -> number
% idx -> index
% id -> identification
% s -> start
% e -> end

function [IDs_inits_out,idxs_inits_out,cntr_inits_out] = ...
    storeInitialLaneletID(IDs_inits_in,idxs_inits_in,cntr_inits_in,ID_init,idx_init)

% Intialize the outputs
IDs_inits_out = IDs_inits_in;
idxs_inits_out = idxs_inits_in;
cntr_inits_out = cntr_inits_in;
% Store initial lanelet ID only if it is not douplicated. (unique)
% Judge if the ID is unique.
isUnique_flag = isUnique(IDs_inits_in,cntr_inits_in,ID_init);
if isUnique_flag == 1
    cntr_inits_out = cntr_inits_in + 1;
    IDs_inits_out(cntr_inits_out) = ID_init;
    idxs_inits_out(cntr_inits_out) = idx_init;
end

end