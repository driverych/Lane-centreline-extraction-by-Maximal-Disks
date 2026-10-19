% isUnique - Judge if the found lanelet ID is unique. And the initial guess
%            is non-unique.
%
% Syntax:  
%    isUnique_flag = isUnique(IDs_initLanelet,num_initLanelet,ID_initLanelet)
%
% Input:
%    IDs_initLanelet - a container storing all IDs of initial lanelets
%    num_initLanelet - the number of found initial lanelets
%    ID_initLanelet - the ID of the imported initial lanelet, which is to
%                     be checked if it has been included in IDs_initLanelet
%
% Output:
%    isUnique_flag - a flag to indicate if the imported initial lanelet
%                    has been included in the IDs_initLanelet
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% Abbreviation:
% init -> initial
% num -> number
% idx -> index


function isUnique_flag = isUnique(IDs_initLanelet,num_initLanelet,ID_initLanelet)

% If the ID container is empty, the coming lanelet ID is unique
if num_initLanelet == 0
    isUnique_flag = 1;
else
    for idx_initLanelet = 1:num_initLanelet
        if IDs_initLanelet(idx_initLanelet) == ID_initLanelet
            isUnique_flag = 0;
            break;
        else
            isUnique_flag = 1;
        end    
    end
end

end