function ppm_scale = adjust_p31_reference(field, sw, fts, ref)

% Sarmad Siddiqui, 10/29/2015

% ppm_scale = adjust_reference(nucleus, field, sw, fts, max_ppm)
% nucleus: choose 'c' for carbon, 'p' for phosphorus, 'h' for proton
% field: number, for field strength, in Tesla
% sw: sweep width
% fts: the spectrum (fourier transformed)
% max_ppm: the ppm of the tallest peak, usually the HP probe


gamma_p = 17.235; %Mhz/T
gamma = gamma_p;

        
pre_freq = gamma * field; %precession frequency

[points, ~] =size(fts);

%unscaled hz to ppm here.

ppm_unscale = linspace(sw/pre_freq, 0, points);

%scale ppm by highest peak here.

figure(387);
plot(real(fts));
xlim([0.9e4 1.2e4]);
%set(gca, 'XDir', 'reverse')
[x, ~] = ginput(1);
x = round(x);


shift = ppm_unscale(x) - ref;
ppm_scale = ppm_unscale - shift; %should work for both when max_ppm is > or < unscaled ppm
