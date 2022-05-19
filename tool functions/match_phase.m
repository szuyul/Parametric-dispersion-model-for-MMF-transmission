function [x_opt, phase1_corrected] = match_phase(phase1, phase2, power)
% find the phase offset and scaling factor to match the two phase distributions
% phase2 = power*phase1 + a
% 
% output: 
%   x_opt is the optimal offset
%   phase1_corrected is the corrected phase1 considering phase2
% 
% input:
%   phase1 and phase2 are 1-by-n_mode of phase distribution
%       ideally, power*phase1 wrapped in 2pi range should be the same as phase2
%       yet need an additional scalar to compensate for the measurement phase offset
%   power is a rough estimation of the scale, which must be larger than 1
%
cost1 = @(x) norm( exp(1i*(x + power*phase1)) - exp(1i*phase2) , 'fro')^2;
options = optimset('MaxFunEvals', 2e6, 'MaxIter', 1e4, 'TolFun', 1e-4, 'PlotFcns', @optimplotfval, 'display', 'off');
[x_opt, fval] = fminunc( cost1, 0, options);

lambda = 0;
cost2 = @(x) norm( exp(1i*(x_opt + power*(phase1 + x))) - exp(1i*phase2), 'fro')^2 + lambda*norm(x, 'fro')^2;
options = optimset('MaxFunEvals', 2e6, 'MaxIter', 1e2, 'TolFun', 1e-3, 'PlotFcns', @optimplotfval, 'display', 'off');
d_phase = fminunc( cost2, zeros(size(phase1)), options);
phase1_corrected = phase1+d_phase;

%% plotting    
figure
subplot(121); complex_imagesc( diag( exp(-1i*(power*phase1 - phase2)) ));
title({['before matching, cost= ', num2str(cost1([0 power]))],...
       ['scale= ', num2str(power)]})

subplot(122); complex_imagesc( diag( exp(-1i*(power*phase1 + x_opt - phase2)) )); 
title({['after matching, cost= ', num2str(fval)],...
       ['scale= ', num2str(power), ', offset= ', num2str(x_opt)]})
    
end

