%% add tool functions
addpath('tool functions')

%% load optimized Xk

load(['data', filesep, 'data_for_PM_demo.mat'])

%% compute spectral-variant PMs

% generate fft TM
F_dim = size(H.dis_SF,1);
img_size = 32;
[T_fft_X, T_fft_Y, ~, F_pos_in_NA] = fft_matrix(img_size, H, V);

% find PMs
[w, PM_out_X, PM_out_Y, PM_wise_corr, gd] = spectral_variant_PM(wo, Xk, U, T_fft_X, T_fft_Y);

%% see the group delays and PM spectral correlation

figure
subplot(121)
plot(w, gd)
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

%% plot all PMs across the spectrum

gd_offset = gd + 31;

% sort the PM by their permanence
n_f = numel(w);
permanence = sum(abs(PM_wise_corr), 1)/n_f;
[~, I] = sort(permanence, 'descend');

PM_idx = I(60);
all_plot(squeeze(PM_out_X(:,:,PM_idx,:)), squeeze(PM_out_Y(:,:,PM_idx,:)), w)

fprintf('%d th arrival, C = %0.5g\n', PM_idx, permanence(PM_idx))

figure
plot(permanence(I))
xlabel('PM index')
ylabel('permanence')

figure('Position', [300, 0, 200, 1000])
plot(w, gd_offset); hold on
plot(w, gd_offset(:,PM_idx), 'black');
ylim([0, 52])
ylabel('group delay (ps)')
xlabel('optical freq. (THz)')

figure
plot(w, gd_offset); hold on
plot(w, gd_offset(:,PM_idx), 'black');
y_min = mean(gd_offset(:,PM_idx)) - .5;
y_max = mean(gd_offset(:,PM_idx)) + .5;
ylim([y_min, y_max])
yticks([y_min, y_max])


