function [w, PM_out_X, PM_out_Y, PM_wise_corr, gd] = spectral_variant_PM(wo, Xk, U, T_fft_X, T_fft_Y)
% spectral_variant_PM
%
% output:
%   w is the optical frequency (184-198 THz) of generated PMs
%   PM_out_X and PM_out_Y are 4D matrices, the first two dim. are image, the third is PM index, and the fourth is freq. index
%   PM_wise_corr is the spectral correlation of each PM
%   gd is the group delay (ps)
%
% input: 
%   F_dim is the dimension of F domain
%   F_pos_in_NA is the indices of selected F channels in F domain
%   T_fft_H and T_fft_V are fft matrices
%   dz is the pathlength difference (unit: um)

fft_TM = blkdiag(T_fft_X', T_fft_Y');
ws = 184;
we = 198;
w = linspace(ws, we, 29);
ref_idx = find(w == wo);
dw = 0.005;
n_f = numel(w);
n_dof = size(Xk,1);
img_size = sqrt(size(T_fft_X,2));


% PM at wo
D = U*expm( X_from_Xk(Xk,dw) )*U';
%-- HV delay correction --%
spectral_phase = -0.39;
D = HV_delay_correction(D, spectral_phase);
%----------------%
[E, diag_eig_val] = eigs(D, n_dof);
eig_val = diag(diag_eig_val);
[~, I] = sort(angle(eig_val), 'descend'); % sort meaningful the eigen modes by arrival times
E = E(:,I);


% PM at varying frequency
E_prev = zeros(size(E(:,1:n_dof)));
gd = zeros(n_f, n_dof);
PM_wise_corr = zeros(n_f, n_dof); % for each spectral-variant PM, correlate with the ref. freq.
eig_vec = zeros(size(U,1), n_dof, n_f);
PM_out_X = zeros(img_size, img_size, n_dof, n_f);
PM_out_Y = zeros(img_size, img_size, n_dof, n_f);

idx = [ref_idx:n_f, ref_idx:-1:1];
for ii = idx
    Dw = w(ii) - wo;
    D = U*expm( X_from_Xk(Xk, Dw+dw) ) * expm( -X_from_Xk(Xk,Dw) )*U';
    %-- HV delay correction --%
    D = HV_delay_correction(D, spectral_phase);
    %----------------%
    [E_temp, eval_temp] = eig(D, 'vector');
    eval_temp = eval_temp(1:n_dof);
    
    if ii == ref_idx
        [eig_vec(:,:,ii), ord] = pair_vecs(E, E_temp(:,1:n_dof)); % sort the eigen_vec based on correlation to reference freq.
    else
        [eig_vec(:,:,ii), ord] = pair_vecs(E_prev, E_temp(:,1:n_dof)); % sort the eigen_vec based on correlation to previous freq.
    end
    E_prev(:,ord) = E_temp(:,1:n_dof);
    eval_temp(ord) = eval_temp;

    PM_out_X(:,:,:,ii) = reshape(fft_TM(1:img_size^2,:)*eig_vec(:,:,ii), [img_size, img_size, n_dof]);
    PM_out_Y(:,:,:,ii) = reshape(fft_TM(img_size^2+1:end,:)*eig_vec(:,:,ii), [img_size, img_size, n_dof]);
    gd(ii,:) = imag(log(eval_temp))/(2*pi*dw);
    PM_wise_corr(ii,:) = (diag(eig_vec(:,:,ii)'*E).')./(vecnorm(E).*vecnorm(eig_vec(:,:,ii)));
end

end
