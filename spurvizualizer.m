clc;
close all;
Mixer = rfckt.mixer('FLO', 2e9);      % Flo = 2GHz local oscillator.
read(Mixer,'samplespur1.s2d');
disp(Mixer)
IMT = Mixer.MixerSpurData.data;
CktIndex = 1;       % Plot the output only
Pin = 0;          % Input power is -0dBm
Fin = 2.5e9;        % Input frequency is 2.5GHz
figure
plot(Mixer,'MIXERSPUR',CktIndex,Pin,Fin);
yline(-25,'-','Spurious');
yline(-55,'-','Image');