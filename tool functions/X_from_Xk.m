function X = X_from_Xk(Xk, dw)
% X_from_Xk compute X = X1*dw + X2*dw^2 + X3*dw^3 +...
%
% input:
%   Xk is a 3 dimensional matrix with the third dimension as the k-th order dispersion
%   dw is the spectral perturbation
%
% output:
%   X is the overall dispersion
% 
    order = size(Xk,3);
    dw_poly(1,1,:) = dw.^(1:order);
    X = sum(Xk.*dw_poly,3);
end
