function [] = find_interferers(RF_band, LO_test_band, LO_num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Define test RF channels
    start_RF_chan_f = RF_band(1);
    mid_RF_chan_f = RF_band(1) + abs((RF_band(2) - RF_band(1)))/2;
    end_RF_chan_f = RF_band(2);
    test_RF_chans = [start_RF_chan_f, mid_RF_chan_f, end_RF_chan_f];

    order_2_low_side_IF = zeros(3, LO_num);
    order_2_high_side_IF = zeros(3, LO_num);
    order_2 = zeros(3, 1+LO_num); % per row [2*RF,2*LO] 
    order_3 = zeros(3, 1+5*LO_num);
    LO_freqs = zeros(3, LO_num);
    for chan_idx = 1:3
        chan_RF = test_RF_chans(chan_idx);
        LO_freqs(chan_idx,:) = linspace(LO_test_band(1), LO_test_band(2), LO_num);
        order_2_low_side_IF(chan_idx, :) = abs(chan_RF - LO_freqs(chan_idx,:));
        order_2_high_side_IF(chan_idx, :) = chan_RF + LO_freqs(chan_idx,:);
        order_2(chan_idx, :) = [2*chan_RF, 2*LO_freqs(chan_idx,:)];
        order_3(chan_idx, :) = [3*chan_RF, 3*LO_freqs(chan_idx,:),...
            abs(2*chan_RF-LO_freqs(chan_idx,:)),...
            abs(2*LO_freqs(chan_idx,:)-chan_RF),...
            2*chan_RF+LO_freqs(chan_idx,:),...
            2*LO_freqs(chan_idx,:)+chan_RF];
    end

    % Plot results
    for chan_idx = 1:3
        chan_RF = test_RF_chans(chan_idx);
        figure()
        axis padded
        hold on
        stem(chan_RF, 3, '-m')
        stem(LO_freqs(chan_idx,:), 2*ones(1, LO_num), '-k')
        stem(order_2_low_side_IF(chan_idx,:), ones(1, LO_num), '-b')
        stem(order_2_high_side_IF(chan_idx,:), ones(1, LO_num), '-c')
        stem(order_2(chan_idx,:), ones(1,1+LO_num), '-r')
        stem(order_3(chan_idx,:), ones(1, 1+5*LO_num), '-g')
        legend(sprintf("RF %g",chan_RF), 'Local oscillator frequencies',...
            'Low side IFs', 'High side IFs', 'Other 2nd order products',...
            '3rd order products')
    end
end