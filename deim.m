%% Function to implement Discrete Empirical Interpolation Method (DEIM) index selection algorithm
% By: Sean Reiter
% Date Modified: 8-29-2022
function [p] = deim(U, m)
% The DEIM index selection algorithm sequentially parses the singular
% vectors of a matrix (POD basis obtained from snapshot data).
% 
% Implemented so as to choose representative row indices of a POD basis. To
% obtain representative column indices, apply to right singular vectors V
% (row  indices of V corr. to column indices of the data). 
% 
% References:
% - `Nonlinear Model Reduction via Discrete Empirical Interpolation'
%   [Chatarantabut, Sorensen, 2010]
% - `A DEIM Induced CUR Factorization' [Embree, Sorensen, 15']
% 
% Inputs:
% :param U: n \times k matrix (n >= k) with orthonormal columns (POD basis)
% :param m: scalar, number of indices to select (m <= k)
% 
% Outputs:
% :param p: m \times 1 vector containing representative indices
%           p = [p_1, ..., p_m] as chosen by DEIM.
%% Initialization
[~, k] = size(U); % Dimensions of singular vectors
if nargin == 1
    m = k; % Default, choose k indices
else
    m = min(k, m); % Select at most k indices
end

%% Index selection
[~, p1] = max(abs(U(:,1))); % First index p1 is that of the largest magnitude entry of V(:,1)
p = p1; 

% Initiate loop 
for j = 2:m
    u_j = U(:,j); % jth POD vector
    % Compute jth residual; implicitly perform the operations:
    % c = U(p, 1:j-1)\u_j(p), r = u_j - U*c (interpolatory projector)
    r = u_j - (U(:,1:j-1))*(U(p,1:j-1)\u_j(p));
    
    [~, p_j] = max(abs(r)); % Next index chosen as maximal mag. entry of r
    p = [p; p_j];
end
