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
    spur_order_2 = zeros(3, 2);
    spur_order_3 = zeros(3, 7);
    LO_freqs = zeros(3, 1);
    for chan_idx = 1:3
        chan_RF = test_RF_chans(chan_idx);
        if is_down_conv
            % LOs for downconvert
            if tuning_side == "low"
                LO_freqs(chan_idx,1) = chan_RF - IF;
                spur_order_2(chan_idx,:) = [IF/2, LO_freqs(chan_idx,1) - IF];
            else % high side tuning
                LO_freqs(chan_idx,1) = chan_RF + IF;
                spur_order_2(chan_idx,:) = [IF/2, LO_freqs(chan_idx,1) + IF];
            end
            % Interfering IMP
            IMP_order_2(chan_idx, 1) = chan_RF + LO_freqs(chan_idx,:);

        else % up-convert
            LO_freqs(chan_idx,1) = IF - chan_RF;
            % Interfering IMP
            IMP_order_2(chan_idx, 1) = abs(chan_RF - LO_freqs(chan_idx,:));
            spur_order_2(chan_idx,:) = [IF/2, LO_freqs(chan_idx,1) + IF];
        end
        
        % Spurious signals (i.e. other RFs that mix down to IF)
        spur_order_3(chan_idx,:) = [IF/3, (IF - LO_freqs(chan_idx,1)/2),...
            IF - 2*LO_freqs(chan_idx,1),...
            (LO_freqs(chan_idx,1) + IF)/2,...
            (LO_freqs(chan_idx,1) - IF)/2,...
            2*LO_freqs(chan_idx,1) + IF,...
            2*LO_freqs(chan_idx,1) - IF];

        % Intermodulation Mixer Product signals (i.e. mixer output)
        IMP_order_2(chan_idx, 2:end) = [2*chan_RF, 2*LO_freqs(chan_idx,:)];
        IMP_order_3(chan_idx, :) = [3*chan_RF, 3*LO_freqs(chan_idx,:),...
            abs(2*chan_RF - LO_freqs(chan_idx,:)),...
            abs(2*LO_freqs(chan_idx,:) - chan_RF),...
            2*chan_RF + LO_freqs(chan_idx,:),...
            2*LO_freqs(chan_idx,:) + chan_RF];
    end

    spur_order_2
    % Plot results
    for chan_idx = 1:3
        chan_RF = test_RF_chans(chan_idx);
        
        figure()
        subplot(2,1,1)
        axis padded
        hold on
        stem(chan_RF, 3, '-k')
        stem(spur_order_2(chan_idx,:), ones(1, 2), '-c')
        stem(spur_order_3(chan_idx,:), ones(1, 7), '-b')
        legend(sprintf("RF %g",chan_RF),...
            '2nd order spurious signals',...
            '3rd order spurious signals')
        title("RF signals that will mix down to IF")

        subplot(2,1,2)
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
        str_tuning = 'high';
        if tuning_side == "low"
            str_tuning = 'low';
        end
        title(sprintf("%s-conversion %s-side tuning", str_convert, str_tuning))
    end
end