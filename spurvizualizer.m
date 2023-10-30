%% this section is for editing the mixer's data file
%edit('samplespur1.s2d');                    % this data file contains paramaters that adjust the mixer
%% code to run
clc;                                        % clear command line
close all;                                  % close all figures
clear;                                      % close all data files and objects
Mixer = rfckt.mixer('FLO', 2e9);            % FLO = Frequency of Local Oscillator
read(Mixer,'samplespur1.s2d');
disp(Mixer)                                 % displays info about the mixer in the command window below
IMT = Mixer.MixerSpurData.data;
CktIndex = 1;                               % 1 = Plot the output only
Pin = -10;                                  % Input power
Fin = 2.5e9;                                % Input frequency
figure
plot(Mixer,'MIXERSPUR',CktIndex,Pin,Fin);
yline(-25,'-','Spurious');                  % this creates the line on the graph
yline(-55,'-','Image');                     % this creates the line on the graph
xlim([0 5]);                                % this sets the x axis limits for the plot in GHz  