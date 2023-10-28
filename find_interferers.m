function [] = find_interferers(RF_band, IF, tuning_side)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Define test RF channels
    start_RF_chan_f = RF_band(1);
    mid_RF_chan_f = RF_band(1) + abs((RF_band(2) - RF_band(1)))/2;
    end_RF_chan_f = RF_band(2);
    test_RF_chans = [start_RF_chan_f, mid_RF_chan_f, end_RF_chan_f];

    is_down_conv = false;
    if IF < RF_band(1)
        is_down_conv = true;
    else
        is_down_conv = false;
    end

    IMP_order_2 = zeros(3, 3); % per row [other IF,2*RF,2*LO] 
    IMP_order_3 = zeros(3, 6);
    LO_freqs = zeros(3, 1);
    for chan_idx = 1:3
        chan_RF = test_RF_chans(chan_idx);
        if is_down_conv
            % LOs for downconvert
            if tuning_side == "low"
                LO_freqs(chan_idx,1) = chan_RF - IF;
            else % high side tuning
                LO_freqs(chan_idx,1) = chan_RF + IF;
            end
            % Interfering IMP
            IMP_order_2(chan_idx, 1) = chan_RF + LO_freqs(chan_idx,:);
        else % up-convert
            LO_freqs(chan_idx,1) = IF - chan_RF;
            % Interfering IMP
            IMP_order_2(chan_idx, 1) = abs(chan_RF - LO_freqs(chan_idx,:));
        end
        IMP_order_2(chan_idx, 2:end) = [2*chan_RF, 2*LO_freqs(chan_idx,:)];
        IMP_order_3(chan_idx, :) = [3*chan_RF, 3*LO_freqs(chan_idx,:),...
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
        stem(chan_RF, 3, '-k')
        stem(LO_freqs(chan_idx,:), 2*ones(1, 1), '-k')
        stem(IF, 3, '-m')
        stem(IMP_order_2(chan_idx,:), ones(1,3), '-r')
        stem(IMP_order_3(chan_idx,:), ones(1, 6), '-g')
        legend(sprintf("RF %g",chan_RF),...
            sprintf('Local oscillator frequency %g', LO_freqs(chan_idx,1)),...
            sprintf('IF %g', IF),...
            '2nd order products',...
            '3rd order products')
        str_convert = 'Up';
        if is_down_conv
            str_convert = 'Down';
        end
        str_tuning = 'High';
        if tuning_side == "low"
            str_tuning = 'Low';
        end
        title(sprintf("%s-convert %s tuning", str_convert, str_tuning))
    end
end