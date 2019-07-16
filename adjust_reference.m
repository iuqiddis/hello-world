function ppm_scale = adjust_reference(nucleus, field, sw, fts, ref_ppm)

% Sarmad Siddiqui, 10/29/2015

% ppm_scale = adjust_reference(nucleus, field, sw, fts, max_ppm)
% nucleus: choose 'c' for carbon, 'p' for phosphorus, 'h' for proton
% field: number, for field strength, in Tesla
% sw: sweep width
% fts: the spectrum (fourier transformed)
% ref_ppm: the ppm of the tallest peak, usually the HP probe

gamma_c = 10.705; %Mhz/T
gamma_p = 17.235; %Mhz/T
gamma_h = 42.576; %Mhz/T

switch nucleus
    case 'c'
        gamma = gamma_c;
    case 'p'
        gamma = gamma_p;
    case 'h'
        gamma = gamma_h;
end

pre_freq = gamma * field; %precession frequency

[points, ~] =size(fts);

%unscaled hz to ppm here.
ppm_unscale = linspace(sw/pre_freq, 0, points);


%to scale ppm by highest peak, here:

switch nucleus
    
    case 'c'
        fts_re = reshape(fts,1, []);
        [~, max_index] = max(fts_re);
        index = mod(max_index, points); %the index in a given acquisition (array)
        
    case 'p'
        figure(387);
        plot(real(fts));
        xlim([0.9e4 1.2e4]);
        %set(gca, 'XDir', 'reverse')
        [index, ~] = ginput(1);
        close figure 387
        index = round(index);
end


shift = ppm_unscale(index) - ref_ppm;
ppm_scale = ppm_unscale - shift; %should work for both when max_ppm is > or < unscaled ppm
