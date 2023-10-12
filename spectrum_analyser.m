%   RTL-SDR Spectrum Scan
% - You can use this script to sweep and record the RF spectrum with your
%   RTL-SDR
% - Change the "location" parameter to something that identifies
%   your location, eg Brisbane
% - You may change range that the RTL-SDR will sweep over by changing the
%   values of "start_freq" and "start_freq" 
% - If you wish, you can also change the RLT-SDR sampling rate by changing
%   "rtlsdr_fs"
%   "number_samples" is the number of sample to be collected for each FFT
%   calculations. 


%spectrum_scan_original(start_freq,start_freq,rtlsdr_fs, number_samples, location);

spectrum_sweep(88e6,108e6,3.2e6, 2^10,'Brisbane')

%   e.x. spectrum_scan_original(750e6,800e6,3.2e6, 2^14,'Brisbane');
%
%   This will produce a figure titled "rtlsdr_spectrum_750MHz_800MHz_Brisbane.jpg"
%  
% - At the end of the simulation, the recorded data will be processed and
%   plotted in a popup figure
% - This figure will be saved to the MATLAB 'current folder' for later
%   viewing
% - NOTE: to end simulation early, use |Ctrl| + |C|