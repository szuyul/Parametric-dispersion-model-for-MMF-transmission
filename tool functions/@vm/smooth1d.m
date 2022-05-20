function out = smooth1d(in,sigma)
% gaussian lowpass smoothing filter with default sigma 15
%
% 2016 Vicente Parot
% Cohen Lab - Harvard University
%
if ~exist('sigma','var')
    sigma = 15;
end
ns = size(in,1);
gw = gausswin(floor(ns/2)*2+1,sigma);
gw = gw(1:ns);
out = ifft(bsxfun(@times,fft(in),ifftshift(gw)));
