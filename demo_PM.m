%% add tool functions
addpath('tool functions')

%% load optimized Xk

load(['data', filesep, 'data_for_PM_demo.mat'])

%% compute spectral-variant PMs

% generate fft TM
img_size = 32;
[T_fft_X, T_fft_Y] = fft_matrix(img_size, H, V);

% find PMs
[w, PM_out_X, PM_out_Y, PM_wise_corr, gd] = spectral_variant_PM(wo, Xk, U, T_fft_X, T_fft_Y);

%% see the group delays and PM spectral correlation
gd_offset = 31;

figure
subplot(121)
plot(w, gd + gd_offset)
ylabel('group delay (ps)')
xlabel('optical freq. (THz)')

subplot(122)
plot(w, abs(PM_wise_corr))
ylim([0.4, 1.02])
ylabel('C')
xlabel('optical freq. (THz)')

%% visualize PMs across the spectrum

PM_idx = 9;

figure
moviesc(squeeze(PM_out_X(:,:,PM_idx,:)))
figure
moviesc(squeeze(PM_out_Y(:,:,PM_idx,:)))

%% visualize different PMs at a wavelength

w_idx = 1;

figure
moviefixsc(squeeze(PM_out_X(:,:,:,w_idx))) 
figure
moviefixsc(squeeze(PM_out_Y(:,:,:,w_idx)))

%% plot Figure 3 in the results - all PMs across the spectrum

select_idx = 200; % 25, 98, 127, 200 th

% sort the PM by their permanence
Nw = numel(w);
permanence = sum(abs(PM_wise_corr), 1)/Nw;
[~, I] = sort(permanence, 'descend');

PM_idx = I(select_idx); 
all_plot(squeeze(PM_out_X(:,:,PM_idx,:)), squeeze(PM_out_Y(:,:,PM_idx,:)), w)

fprintf('%d th arrival, C = %0.5g\n', PM_idx, permanence(PM_idx))

close all

figure
plot(permanence(I))
xlabel('PM index')
ylabel('permanence')

figure('Position', [300, 0, 200, 1000])
plot(w, gd + gd_offset); hold on
plot(w, gd(:,PM_idx) + gd_offset, 'black');
ylim([0, 52])
ylabel('group delay (ps)')
xlabel('optical freq. (THz)')

figure
plot(w, gd + gd_offset); hold on
plot(w, gd(:,PM_idx) + gd_offset, 'black');
y_min = mean(gd(:,PM_idx) + gd_offset) - .5;
y_max = mean(gd(:,PM_idx) + gd_offset) + .5;
ylim([y_min, y_max])
yticks([y_min, y_max])


