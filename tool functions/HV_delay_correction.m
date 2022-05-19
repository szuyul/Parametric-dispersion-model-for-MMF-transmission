function D_corrected = HV_delay_correction(D_raw, spectral_phase)
% HV_delay_correction compensate for the pathlength difference between the two polarization states in detection
%
% output:
%   D_corrected is the dispersion matrix with H and V polarization channels aligned.
%
% input: 
%   D_raw is the original dispersion matrix
%   spectral_phase is the spectral phase offset in free space between dw due to relative delay of V to H

D_dim = size(D_raw,1);
phase_V = [ones(D_dim/2,1); exp(1i*spectral_phase)*ones(D_dim/2,1)]; % spectral phase

D_corrected = phase_V.*D_raw;
end



