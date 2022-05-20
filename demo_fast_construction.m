%% add tool functions
addpath('tool functions')

%% load the multispectral TM (msTM) for fast model construction

% The MMF has 1 m in length, step-index, 0.22 NA, and 50 um core diameter.
% The operating optical frequency is 184-198 THz, where the MMF has ~200 modes in total.
% The TMs here are with spatial channels aligned (modulation frequency correction in off-axis holography)
% We offset the optical frequency by reference frequency 191 THz (wo), leading to frequency range (-7,+7) THz.
% All TMs are compressed into a subspace by U'*T*V, where U and V are the singular vectors of TM at the reference frequency.
% We pick only the first 200 singular vectors, leading to TMs with dimension 200 by 200.

load(['data', filesep, 'data_for_fast_construction_demo.mat'])
% The msTM_1 has 11 TMs with dw = -0.0122
% The msTM_2 has 11 TMs with dw = -0.0607

addpath('tool functions')

%% calculate D from respective msTMs

N = 3; % number of measurement used in each msTM (<11), the 1st TM of the two msTMs are the same

temp = msTM_phase_align(msTM_1.TMs(:,:,1:N));
D_small = D_from_msTM(temp);

temp = msTM_phase_align(msTM_2.TMs(:,:,1:N));
D_large = D_from_msTM(temp);

%% use eigenvec from D_large as space basis, work with eigenvalues

[eigvec_D_l, eigval_D_l] = eig(D_large, 'vector');
eigval_D_l = exp(1i*angle( eigval_D_l ));

eigval_D_s = exp(1i*angle(diag( eigvec_D_l\(D_small*eigvec_D_l) ))); % project D_small into the space basis

% fine tune the phase
power = msTM_2.dw / msTM_1.dw;
[~, D_s_phase_c] = match_phase(angle(eigval_D_s(1:n_dof)), angle(eigval_D_l(1:n_dof)), power);
eigval_D_s = blkdiag(diag(exp(1i*D_s_phase_c)), zeros(size(eigval_D_l,1)-n_dof));
eigval_D_l = diag(eigval_D_l);

% compute X1_est
temp = eigvec_D_l * eigval_D_s /eigvec_D_l;
ttemp = sqrtm(temp*temp')\temp;
X1_est = logm(ttemp)/(msTM_1.dw);

%% test the dispersion model on separate measurements

% The msTM_test has 58 TMs with nonuniform w
M_test = msTM_test.TMs;
w_test = msTM_test.w;

n_f = numel(w_test);
ref_idx = 25;
C_original = abs(tovec(M_test)'*tovec(M_test)./norm(M_test(:,:,ref_idx),'fro').^2);
C_X1_est = zeros(1, n_f);
M_hat = zeros(size(M_test));

for ii = 1:n_f
    X = X_from_Xk(X1_est, w_test(ii));
    D = expm(X);
    M_hat(:,:,ii) = D * M_test(:,:,ref_idx);
    
    C_X1_est(ii) = TM_correlation(M_test(:,:,ii), M_hat(:,:,ii));
end

%% plot the TM spectral correlation vs. freq. and wavelength
close all
figure('Position', [100, 100, 800, 400])
temp = [C_original(:,ref_idx), C_X1_est.'];

plot(w_test+wo, temp'); hold on
legend 'original' 'X1_{est}' 'Location' 'northeast'
xlabel('optical freq. (THz)')
ylabel('C')

w_tick = linspace(w_test(1)+wo, w_test(end)+wo, 8);
LinkTopAxisData(w_tick, round(2.999e5./w_tick,2), 'wavelength (nm)'); % Add a top axis
xlim([w_test(end) w_test(1)]+wo)
ylim([0, 1.05])
grid on
