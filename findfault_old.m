%% By: Sean Reiter, Date: 4-20-2022
function [plscore, pdeim, pqdeim] = findfault_old(X, k, t0)
% Function to locate power system events using the Discrete Empirical
% Interpolation Method (DEIM),
% 
% X == n\times m block matrix of PMU data, n >> m (usually bus voltage
% magnitude data).
% k == no. of locations to look at, OR, can input a threshold <1 for 
% computing approx. rank of data, indicates how much variance to capture in 
% the chosen singular values.
% t0 == timestamp at which event occurs 
% N == no. of timesteps to include 
%
% p == distinguished row indices as chosen by selecting the k largest 
% magnitude r left singular vectors, r is approximate rank of X.
% pdeim == distinguished indices chosen by standard DEIM selection process.
% pqdeim == distinguished indices chosen by QDEIM.

%% 
[n,T] = size(X); %no. of buses
if nargin == 3 
    for i = 1:n %remove mean of pre-event behavior from each row    
%         X(i,:) = X(i,:)-mean(X(i,1:t0-2))*ones(1,T);   
        X(i,:) = X(i,:)-mean(X(i,1:49))*ones(1,T);     
    end 
    [U,S,~] = svd(X(:,t0:3:t0+100),'econ');    sv = diag(S); %include one second of data
    if k < 1 % k variable is a threshold
        threshold = k;
        sum_s = 0;  k=0;
        while sum_s < threshold*sum(sv) 
            sum_s = sum_s+sv(k+1);
            k = k+1;
        end
    end
elseif nargin == 2 %if no t0 included, use all data before, during, and after event
%     for i = 1:n %remove mean behaviour of each row
%         X(i,:) = X(i,:)-mean(X(i,:))*ones(1,T);           
%     end 
    [U,S,~] = svd(X,'econ');    sv = diag(S);  
    if k < 1 % k variable is a threshold
        threshold = k;
        sum_s = 0;  k=0;
        while sum_s < threshold*sum(sv) 
            sum_s = sum_s+sv(k+1);
            k = k+1;
        end
    end
else %if no k or threshold selected
    for i = 1:n %remove mean behaviour of each row
        X(i,:) = X(i,:)-mean(X(i,1:49))*ones(1,T);           
    end 
    [U,S,~] = svd(X,'econ');    
    k = 3; %look at five most affected buses by default
end

Uk = U(:,1:k);   Sk = S(1:k,1:k); %first r singular vectors and singular values
Uktest = Uk*Sk;

Ukmag = zeros(n,1); 
for i = 1:n %take 2-norm of rows of Ur
    Ukmag(i) = norm(Uktest(i,:),2);
end
Ukmag = Ukmag/sum(Ukmag); %normalize 

[~,plscore] = sort(Ukmag,'descend');   pdeim = deim(Uktest);   pqdeim = qdeim(Uktest); 
plscore = plscore(1:k); %get first k indices
end