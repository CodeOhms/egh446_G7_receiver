

start_freq = 25e6;
stop_freq = 128e6;
rtlsdr_f_s = 3.2e6;
num_samples = 2^13;
location = '4014 QLD';
spectrum_sweep(start_freq, stop_freq, rtlsdr_f_s, num_samples, location)


