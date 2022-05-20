function M = msTM_phase_align(Mraw)
% 
% input: 
% Mraw is uncorrected (numel(H.channels) + numel(V.channels)) by 2*numel(pre_mode_ind) by n_lambdas exp. multispectral TMs
%   with a constant spectral sampling rate
% 
% output: 
% M is a phase corrected version of Mraw, where the scalar phase offset between i-th and i+1-th TM is a constant
%   with such M, we can find a single D by regression, where its phase offset is not relevant

%% perhaps unnecessary if using tikhonov, doesn't hurt
[nr, nc, nf, ~] = size(Mraw);
if nc > nr
    Mraw = permute(Mraw,[2 1 3]);
    [nr, nc, nf, ~] = size(Mraw);
end

%% calculate phase corrections
covM = tovec(Mraw)'*tovec(Mraw); % correlation between pairs of matrices
dCovM = diag(covM,-1); % offset diagonal for (i+1,i) pairs
angM = dCovM./abs(dCovM); % keep angle only
dAngM = angM./angM(1); % set first angle as reference 
dAcumAngM = cumprod([1; dAngM]); % augment with initial matrix
M = Mraw.*permute(dAcumAngM,[3 2 1]); % correct phase of frames 3:end

end

