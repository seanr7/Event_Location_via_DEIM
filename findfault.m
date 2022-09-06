%% Function to attempt to locate the source of a power system fault
% By: Sean Reiter
% Date Modified: 9-2-2022
function [p] = findfault(location_fun, V, t0, k, N)
% Attempts to locate the source of a power system fault purely from data
% using the DEIM index selection algorithm, leverage scores, or its
% variants. Uses the optimal rank-k approximation via the SVD.
% 
% Inputs:
% 
% :param location_fun: .m function used to locate the source of power
%        system faults (DEIM + its variants, leverage scores)
% :param V: n \times T matrix V containing measurement data (typically bus
%        voltage magnitude measurements)
% :param k: no. of locations to look for. Can be an integer or a percentage
%        of variance to capture in the data.
% :param t0: timestamp at which the fault occurs
% :param N: no. of timesteps to include
% 
% Outputs:
% 
% :param p: ordered list of bus indices
%% 
[~, T] = size(V); % dimensions of the data
% Compute mean of pre-event behaviour in at each bus/ each row of V 
% (outputs col. vector `means'), and remove this to normalize the data
means = mean(V(:, 1:t0-1), 2);
V = V - means*ones(1,T); 

% Compute the economy-sized SVD of V
% Assumption: V contains 5 seconds of data with a simulation timestep of
% .01 second. The measurement sampling rate is 34 times/second ~ .0294
% seconds. So, about 3 simulation timestamps. t0 + 101 is approximately one 
% second of data.
% TODO: Make a function that handles different timesteps/step sizes?
[U, Sigma, ~] = svd(V(:, t0:2:t0 + N), 'econ'); 

if k < 1 % If k is a percentage threshold
    sum_sv = sum(diag(Sigma)); % Compute sum of all singular values
    threshold = k;
    k = 0;  sum_k_sv = 0; % Initialize counters
    % While the first k singular values < threshold * sum of all svs
    while sum_k_sv < threshold*sum_sv
        sum_k_sv = sum_k_sv + Sigma(k+1, k+1);
        k = k + 1;
    end
end

% Else, k is an integer. Pre-determined no. of locations to check for
U_k = U(:,1:k);   Sigma_k = Sigma(1:k,1:k); % Get leading left singular vectors/values
% Pass weighted left singular vectors + no. of indices to choose to location_fun arg
p = location_fun(U_k*Sigma_k, k); 
end