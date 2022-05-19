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

close all
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

close all
moviesc(squeeze(PM_out_X(:,:,PM_idx,:)))
figure
moviesc(squeeze(PM_out_Y(:,:,PM_idx,:)))

%% visualize different PMs at a wavelength

w_idx = 1;

close all
moviefixsc(squeeze(PM_out_X(:,:,:,w_idx))) 
figure
moviefixsc(squeeze(PM_out_Y(:,:,:,w_idx)))

%% plot all PMs across the spectrum

gd_offset = gd + 31;

% sort the PM by their permanence
n_f = numel(w);
permanence = sum(abs(PM_wise_corr), 1)/n_f;
[~, I] = sort(permanence, 'descend');

close all
PM_idx = I(60);
all_plot(squeeze(PM_out_X(:,:,PM_idx,:)), squeeze(PM_out_Y(:,:,PM_idx,:)), w)

sprintf('%d th arrival, C = %0.5g', PM_idx, permanence(PM_idx))

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


%% self- defined functions

function all_plot(out_X, out_Y, w)
    n_f = numel(w);
    figure('Position', [100, 100, 1800, 300])
    img_max = max( [max(abs(out_X),[],'all'), max(abs(out_Y),[],'all')] );
    for ll = 1:n_f
        subplot(2,n_f,ll);
        field = out_X(:,:,ll)/img_max;
        image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], [0 0.8]));  
        axis image
        title(num2str(w(ll)))
        
        subplot(2,n_f,ll+n_f);
        field = out_Y(:,:,ll)/img_max;
        image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], [0 0.8]));  
        axis image
    end
end

