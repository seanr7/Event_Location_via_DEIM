%% Test script for `findfault.m' function
clc
clear all

% Add path containing necessary functions
addpath('/Users/seanr/Documents/MATLAB/Research/PS_Event_Location/Event_Location_via_DEIM')
%% 1. Load event simulation data 
% From https://github.com/Wendy0601/Event-Identification-Simulation.git
% Put the path to the event data below
cd('/Users/seanr/Documents/MATLAB/Research/PS_Event_Location/Event-Identification-Simulation/Three_Phase_86')
eventdata = dir('*.mat');  
m = length(eventdata); % No. of events in the simulation set 

% Each event contains about 5 seconds of data 
t0 = 51; % Event occurs one second in
N = 400; % no. of timesteps to include
kmax = 8;
% Space for no. of eventsin which both indices where found
found_lscores = zeros(kmax-1,1); found_deim = zeros(kmax-1,1); found_qdeim = zeros(kmax-1,1);
for k = 1:kmax % Will look up to 10 places
    for i = 1:m % Loop through events in the directory
        event = load(eventdata(i).name);
        % Bus voltage magnitude data
        Vmag = abs(event.bus_v(1:69,:)); 
%         [p_lscores, p_deim, p_qdeim] = findfault_old(Vmag, k, t0);
        p_deim = findfault(@deim, Vmag, t0, k, N);
        p_qdeim = findfault(@qdeim, Vmag, t0, k, N);
        p_lscores = findfault(@lscores, Vmag, t0, k, N);
        
        fault_loc = event.sw_con(2,2:3); % Get location of the event
        
        if isempty(find(p_deim == fault_loc(1),1)) == 0 && isempty(find(p_deim == fault_loc(2),1)) == 0
            found_deim(k-1) = found_deim(k-1) + 1;
        end
        if isempty(find(p_qdeim == fault_loc(1),1)) == 0 && isempty(find(p_qdeim == fault_loc(2),1)) == 0
            found_qdeim(k-1) = found_qdeim(k-1) + 1;
        end
        if isempty(find(p_lscores == fault_loc(1),1)) == 0 && isempty(find(p_lscores == fault_loc(2),1)) == 0
            found_lscores(k-1) = found_lscores(k-1) + 1;
        end
    end
end

percentage_lscore = 100*found_lscores./66; percentage_deim = 100*found_deim./66; percentage_qdeim = 100*found_qdeim./66;
plot(2:kmax, percentage_lscore, '-o','LineWidth', 1.5)
hold on
plot(2:kmax, percentage_deim, '-o','LineWidth', 1.5)
plot(2:kmax, percentage_qdeim, '-o','LineWidth', 1.5)
xticks(2:kmax)
xlabel('$k$, number of indices to select','FontSize',14,'Interpreter','latex')
ylabel('Percent','FontSize',14, 'Interpreter','latex')
legend('Leverage scores','DEIM','Q-DEIM','Interpreter','latex')