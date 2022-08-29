%% Function implement Discrete Empirical Interpolation Method (DEIM) Selection algorith (via Pivoted-QR, QDEIM variant)
% By: Sean Reiter
% Date modified: 8-29-2022
function [p] = qdeim(U, m)
% QDEIM variant of DEIM. Selected a set representative row indices of a
% singular vector (POD) basis via a pivoted-QR factorization.
% 
% Implemented so as to choose representative row indices of a POD basis. To
% obtain representative column indices, apply to right singular vectors V
% (row  indices of V corr. to column indices of the data). 

% References:
% - `A New Selection Operator for the Discrete Empirical Interpolation
%   Method---Improved A Priori Error Bound and Extensions' [Drmac,
%   Gugercin, 2016]

% Inputs:
% :param U: n \times k matrix (n >= k) with orthonormal columns (POD basis)
% :param m: scalar, number of indices to select (m <= k)
% 
% Outputs:
% :param p: m \times 1 vector containing representative indices
%           p = [p_1, ..., p_m] as chosen by QDEIM.
%% Initialization
[~, k] = size(U); % Dimensions of singular vectors
if nargin == 1
    m = k; % Default, choose k indices
else
    m = min(k, m); % Select at most k indices
end

%% Index selection via QDEIM
% Compute a pivoted-QR factorization of U'
[~, ~, p] = qr(U', 'vector');   
% U' is rank k < n; last n-k indices are determined by noice. At most,
% k are selected.
p = p(1:m)';
end
