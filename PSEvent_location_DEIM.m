%% Sean Reiter, Date: 4-20-2022
% 
% Script to generate synthetic PMU data and apply DEIM for locating the
% source of power system events. Compared against methodology used in [Li,
% Wang, Chow, 18] 'Real-time Event Identification through Low-Dimensional
% Subspace Characterization of High-Dimensional Synchrophasor Data'. 
% 
% Data generated using MATLAB's Power System Toolbox (PST) [Chow, Cheung, 96]
%% Add relevant folders to MATLAB path
addpath('/Users/seanr/Documents/MATLAB/Research/PMU Data Analysis/PST_2020_Aug_10')
addpath('/Users/seanr/Documents/MATLAB/Research/PMU Data Analysis/PST_2020_Aug_10/pdata')
addpath('/Users/seanr/Documents/MATLAB/Research/PMU Data Analysis/PST_2020_Aug_10/pdata/Modified test cases')
addpath('/Users/seanr/Documents/MATLAB/Research/PowerSys_MR')
%% Transient stability analysis of IEEE 16-machine 68-bus system 
% Use MATLAB's PST to generate PMU data before, during, and after different
% events.

%% 1. Three phase fault
% Event type: Three phase fault
% Location: Bus 6, line 6-11
clc
clear all

run s_simu.m %run transient stability analysis, select data16m_3pfault_6_11.m

%%
vmag = abs(bus_v); %get matrix of bus voltage magnitudes 
k = 5;

[p, pdeim, pdqeim] = findfault(vmag,k);
[p, pdeim, pdqeim]
%DEIM wins! 
%% 2. Line to line fault 
clc
clear all
% Event type: Line to line fault
% Location: Line connecting bus 6 and bus 11

run s_simu.m %run transient stability analysis, select data16m_l2lfault_6_11.m

%%
vmag = abs(bus_v); %get matrix of bus voltage magnitudes 
k = 5;

[p, pdeim, pdqeim] = findfault(vmag,k);
[p, pdeim, pdqeim]
%DEIM wins! 

%% 3. Line to line fault
clc
clear all
% Event type: Line to line fault
% Location: Bus 29, line 28-29

run s_simu.m %run transient stability analysis, select data16m_l2lfault_28_29.m

%%
vmag = abs(bus_v); %get matrix of bus voltage magnitudes 
k = 5;

[p, pdeim, pdqeim] = findfault(vmag,k);
[p, pdeim, pdqeim]

%% 4. Loss of load fault
clc
clear all
% Event type: Loss of load fault
% Location: Line connecting bus 6 and bus 11

run s_simu.m %run transient stability analysis, select data16m_l2lfault_6_11.m

%%
vmag = abs(bus_v); %get matrix of bus voltage magnitudes 
k = 5;

[p, pdeim, pdqeim] = findfault(vmag,k);
[p, pdeim, pdqeim]
%DEIM wins! 

%% Transient stability analysis of IEEE 48 machine-bus system 
% Use MATLAB's PST to generate PMU data before, during, and after different
% events.

%% 1. Three phase fault
% Event type: Three phase fault
% Location: Bus 105, line 105-111

run s_simu.m %run transient stability analysis, select datanp48

%%
vmag = abs(bus_v); %get matrix of bus voltage magnitudes 
k = 5;

[p, pdeim, pdqeim] = findfault(vmag,k);
[p, pdeim, pdqeim]
%DEIM wins! 