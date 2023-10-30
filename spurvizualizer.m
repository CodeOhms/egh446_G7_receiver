clc;                                        % clear command line
close all;                                  % close all figures
Mixer = rfckt.mixer('FLO', 2e9);            % FLO = Frequency of Local Oscillator
read(Mixer,'samplespur1.s2d');
disp(Mixer)                                 % displays info about the mixer in the command window below
IMT = Mixer.MixerSpurData.data;
CktIndex = 1;                               % 1 = Plot the output only
Pin = 0;                                    % Input power is -0dBm
Fin = 2.5e9;                                % Input frequency
figure
plot(Mixer,'MIXERSPUR',CktIndex,Pin,Fin);
yline(-25,'-','Spurious');                  %this creates the line on the graph
yline(-55,'-','Image');                     %this creates the line on the graph