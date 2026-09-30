% connectCirclesByPoint
%   - Sequence the centre points whose circles pass the selected left point.
% 
% Syntax:  
%    [circlesConnected,numCircles] = connectCirclesByPoint(circles_point,numCircles,circlesConnected)
%
% Input:
%    segL - The chosen left segment
%    circles_start - A matlab matrix of all circles passing by the start
%                    point
%    numCircles - The number of cirlces
%    circlesConnected - A matlab matrix to store circle info in sequence
%
% Output:
%    circlesConnected - A matlab matrix to store circle info in sequence
%    numCircles - The number of all found circles
%
% Subfunctions:
%
% MAT-files required: none
%
% Main steps:
%  - Extract the indexes based on whether the base element is on the left
%    or not
%  - Get the absolute values of the indexes
%  - Sort the circles by indexes in the first column
%  - sort the circles by indexes in the second column if necessary
%
% Abbreviation:
% seg -> segment
% num -> number
% cos -> cosine
% fld -> field
% idx -> index
% R -> right
% L -> left

function [circlesConnected,numCircles] = ...
            connectCirclesByPoint(circles_point,numCircles,circlesConnected)

% The fields of the circle info
fld_idx_elemTgt_1 = 4;
fld_idx_elemTgt_2 = 7;
fld_idx_elemBase = 10;
fld_isLeft_Base = 13;

% Initialise
numCircles_point = size(circles_point,1); 

if numCircles_point == 1 % Only 1 circle exists
    circlesConnected = [circlesConnected;circles_point];
    numCircles = numCircles + 1;
else
    % Build the index container, first column for Tgt_1/Base, second for Tgt_2.
    indexContainer = zeros(numCircles_point,2);
    for idxCircle = 1:numCircles_point
        %------------------------------------------------------------------
        %-----                    extract indexes                    ------
        %------------------------------------------------------------------
        % If the circle base element is on the left, extract the index of  
        % the tgt_1 and tgt_2 on the right.
        % If the circle base element in on the right, extract the index of 
        % the base on the right.(because only one element is on the right)
        % Anyway, store the element index on the right
        isLeft = circles_point(idxCircle,fld_isLeft_Base);
        if isLeft == 1
            uniIdx = circles_point(idxCircle,fld_idx_elemTgt_1);
            idx_tgt_2 = circles_point(idxCircle,fld_idx_elemTgt_2);
            indexContainer(idxCircle,:) = [uniIdx,idx_tgt_2];
        else % isLeft == 0
            idx_base = circles_point(idxCircle,fld_idx_elemBase);
            indexContainer(idxCircle,1) = idx_base;
        end

        %------------------------------------------------------------------
        %-----             get absolute values of indexes            ------
        %------------------------------------------------------------------
        % The indexes of elements on the right border are negative
        indexContainer = abs(indexContainer);
    end
    
    %----------------------------------------------------------------------
    %-------    sort the circles by indexes in the first column    --------
    %----------------------------------------------------------------------
    % Sort the circles by element index of the first column
    [~,idx_firstSort] = sort(indexContainer(:,1),'ascend');
    circlesConnected_temp = circles_point(idx_firstSort,:);
    
    %----------------------------------------------------------------------
    %-------   sort the circles by indexes in the second column    --------
    %----------------------------------------------------------------------
    % If the indexes of the first row are duplicated, the second sort is
    % needed
    % Extract the unique index
    idxs_unique = unique(circlesConnected_temp(:,1),'sorted');
    num_uniIdxs = size(idxs_unique,1);
    if num_uniIdxs == numCircles_point % No indexes are duplicated
        circlesConnected = [circlesConnected;circlesConnected_temp];
        numCircles = numCircles + num_uniIdxs;
    else % Part of the indexes are duplicated
        % Update the index container according to the result of first sort
        indexContainer = indexContainer(idx_firstSort,:);
        circles_uniIdx = [];
        for idx_uniIdxs = 1: num_uniIdxs
            
            %--------------------------------------------------------------
            %------ isolate the circles with same first-column index ------
            %--------------------------------------------------------------
            % Get one unique index
            uniIdx = idxs_unique(idx_uniIdxs,1);
            % Extract the rows with the same index
            idxs_same = indexContainer(indexContainer(:,1) == uniIdx);
            circles_sameIdx = circlesConnected_temp(indexContainer(:,1) == uniIdx);
            num_sameIdxs = size(idxs_same,1);
            
            if num_sameIdxs > 1 % This index is duplicated
                % Sort according to the second row
                [~,idx_second_temp] = sort(idxs_same(:,2),'ascend');
                circles_uniIdx = ...
                    [circles_uniIdx;circlesConnected_temp(idx_second_temp)];
            else % No need to sort
                circles_uniIdx = ...
                    [circles_uniIdx;circles_sameIdx];
            end
        end
        % Store the sorted circles
        circlesConnected = [circlesConnected;circles_uniIdx];
        numCircles = numCircles + numCircles;
    end
end % if numCircles_point == 1
        
end