%% add tool functions
addpath('tool functions')

%% load the multispectral TM (msTM) for model construction

% The MMF has 1 m in length, step-index, 0.22 NA, and 50 um core diameter.
% The operating optical frequency is 184-198 THz, where the MMF has ~200 modes in total.
% The TMs here are with spatial channels aligned (modulation frequency correction in off-axis holography)
% We offset the optical frequency by reference frequency 191 THz (wo), leading to frequency range (-7,+7) THz.
% All TMs are compressed into a subspace by U'*T*V, where U and V are the singular vectors of TM at the reference frequency.
% We pick only the first 200 singular vectors, leading to TMs with dimension 200 by 200.

load(['data', filesep, 'data_for_main_demo.mat'])
% The msTM_1 has 21 TMs with dw = -0.015
% The msTM_2 has 31 TMs with dw = -0.4667

[Mn, w] = msTM_merge(msTM_1.TMs, msTM_2.TMs, msTM_1.w, msTM_2.w);

%% estimate linear dispersion using msTM_1

n_dof = size(Mo,1);
n_f = size(Mn,3);
msTM_1.TMs = msTM_phase_align(msTM_1.TMs); % align the relative phase offset between consecutive TMs
D = D_from_msTM(msTM_1.TMs);
X1_est = logm(D)/msTM_1.dw;

%% examine spectral correlation after compensating linear dispersion with X1_est

C_original = zeros(1,n_f);
C_X1 = zeros(1,n_f);
for ii = 1:n_f
    C_original(ii) = TM_correlation(Mn(:,:,ii), Mo);

    X = X_from_Xk(X1_est, w(ii));
    D = expm(X);
    C_X1(ii) = TM_correlation(Mn(:,:,ii), D*Mo);
end

figure
plot(w+wo, abs(C_original)); hold on
plot(w+wo, abs(C_X1))
set(gca,'ylim',[0,1.04])
xlabel('optical freq.')
legend('original C','C with X1_{est}')

%% optimization for finding higher order dispersion

dispersion_order = 2;
Xk = cat(3, X1_est, repmat(zeros(size(X1_est)), [1,1,dispersion_order-1]));

% gradient descent
max_iter = 50;
step = 5;

[Xk, C_trace, loss, step] = Xk_optimization(Mn, Mo, w, Xk, max_iter, step);

%% examine spectral correlation after compensating high-order dispersion

figure
subplot(2,2,1)
imagesc(abs(C_trace))
xlabel('optical freq.')
ylabel('iter')
title('C')

subplot(2,2,3)
plot(w+wo, abs(C_trace(1,:)))
hold on
plot(w+wo, abs(C_trace(end,:)))
xlabel('optical freq.')
ylabel('C')
legend('First','Last')

subplot(2,2,[2 4])
plot(loss)
xlabel('iter')
ylabel('loss')

%% test the dispersion model on independent msTM_test

% The msTM_test has 83 TMs with nonuniform w
M_test = msTM_test.TMs;
w_test = msTM_test.w;

n_f = numel(w_test);
ref_idx = 52;
C_original = abs(tovec(M_test)'*tovec(M_test)./norm(M_test(:,:,ref_idx),'fro').^2);
C_X1 = zeros(1, n_f);
C_X2 = zeros(1, n_f);
M_hat = zeros(size(M_test));

for ii = 1:n_f
    % correlation with X1
    X = X_from_Xk(Xk(:,:,1), w_test(ii));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X1(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
    
    % correlation with X1 + X2
    X = X_from_Xk(Xk, w_test(ii));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X2(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
end


%% plot the TM spectral correlation vs. freq. and wavelength
figure('Position', [100, 100, 800, 500])
temp = [C_original(:,ref_idx), C_X1.', C_X2.'];

plot(w_test+wo, temp'); hold on
legend 'original' 'X1' 'X1+X2' 'Location' 'northeast'
xlabel('optical freq. (THz)')
ylabel('C')

w_tick = linspace(w_test(1)+wo, w_test(end)+wo, 8);
LinkTopAxisData(w_tick, round(2.999e5./w_tick,2), 'wavelength (nm)'); % Add a top axis
xlim([w_test(end) w_test(1)]+wo)
ylim([0, 1.05])
grid on
