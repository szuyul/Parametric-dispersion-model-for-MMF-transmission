%% add tool functions
addpath('tool functions')

%% load the multispectral TM (msTM) for model construction

% The MMF has 1 m in length, -index, 0.22 NA, and 50 um core diameter.
% The operating wavelength is 1525-1566 nm, where the MMF has ~420 modes in total.
% The operating frequency is 191.5-196.7 THz.
% We offset the frequency by reference frequency 194.1234 THz (wo), leading to frequency range (-2.6,+2.6) THz.

load(['data', filesep, 'data_from_UQ.mat'])
% The data is shared from Dr. Joel Carpenter at U. Queensland, https://espace.library.uq.edu.au/view/UQ:405939
%
% The original msTM has 512 TMs with dw = -0.0102 THz
% The msTM_1 has 11 TMs with dw = -0.0102
% The msTM_2 has 18 TMs with dw = -0.3068
% The msTM_test has 483 TMs with nonuniform sampling

[Mn, w] = msTM_merge(msTM_1.TMs, msTM_2.TMs, msTM_1.w, msTM_2.w);

addpath('tool functions')

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

close all
figure
plot(w+wo, abs(C_original)); hold on
plot(w+wo, abs(C_X1))
set(gca,'ylim',[0,1.04])
xlabel('optical freq.')
legend('original C','C with X1_{est}')

%% optimization for finding higher order dispersion

dispersion_order = 3;
Xk = cat(3, X1_est, repmat(zeros(size(X1_est)), [1,1,dispersion_order-1]));

% gradient descent
max_iter = 150;
step = 1e-8;

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

% The msTM_test has 483 TMs with nonuniform w
M_test = msTM_test.TMs;
w_test = msTM_test.w;

n_f = numel(w_test);
ref_idx = 240;
C_original = abs(tovec(M_test)'*tovec(M_test)./norm(M_test(:,:,ref_idx),'fro').^2);
C_X1_est = zeros(1, n_f);
C_X1 = zeros(1, n_f);
C_X2 = zeros(1, n_f);
C_X3 = zeros(1, n_f);
M_hat = zeros(size(M_test));

for ii = 1:n_f
    % correlation with X1 est.
    X = X_from_Xk(X1_est, w_test(ii) - w_test(ref_idx));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X1_est(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
    
    % correlation with X1
    X = X_from_Xk(Xk(:,:,1), w_test(ii) - w_test(ref_idx));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X1(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
    
    % correlation with X1 + X2
    X = X_from_Xk(Xk(:,:,1:2), w_test(ii) - w_test(ref_idx));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X2(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
    
    % correlation with X1 + X2 + X3
    X = X_from_Xk(Xk, w_test(ii) - w_test(ref_idx));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    C_X3(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
    
    fprintf('correlation %d/%d\n', ii, n_f)
end


%% plot the TM spectral correlation vs. freq. and wavelength
figure('Position', [100, 100, 800, 500])
temp = [C_original(:,ref_idx), C_X1_est.', C_X1.', C_X2.', C_X3.'];

plot(w_test+wo, temp'); hold on
legend 'original' 'X1 est.' 'X1' 'X1+X2' 'X1+X2+X3' 'Location' 'northeast'
xlabel('optical freq. (THz)')
ylabel('C')

w_tick = linspace(w_test(1)+wo, w_test(end)+wo, 8);
LinkTopAxisData(w_tick, round(2.999e5./w_tick,2), 'wavelength (nm)'); % Add a top axis
xlim([w_test(end) w_test(1)]+wo)
ylim([0, 1.05])
grid on
