%% Function to compute `weighted leverage scores'
% By: Sean Reiter
% Date Modified: 9-2-2022
function [p] = lscores(U, m)
% Function to compute the most influenced buses following an event from
% data using leverage scores (weighted row 2-norms)
% 
% Inputs:
% :param U: n \times k matrix (n >= k) with orthonormal columns (POD basis)
%        weighted by singular values (assumed to be weighted pre-input)
% :param m: scalar, number of indices to select (m <= k)
% 
% Outputs:
% :param p: m \times 1 vector containing representative indices
%           p = [p_1, ..., p_m] as chosen by sorted leverage scores.

%% 
norms = sqrt(sum(U.^2, 2)); % Compute vector 2-norms of the rows of U
norms = norms/sum(norms);
[~,p] = sort(norms,'descend');
p = p(1:m); % Get first m indices
end