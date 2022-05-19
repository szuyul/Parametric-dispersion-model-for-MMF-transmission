function [TMaberr, aberr] = zern_aberr(im_siz, zern_order, zern_coef, pos_list, r, theta, TM_form, varargin)
% zern_aberr computes the aberration wavefront
% 
% output:
% TMaberr is a numel(pos_list) by numel(pos_list) matrix or numel(pos_list) by 1 column vector(if the 5th input "vector")
%           accounting for aberration correction at chosen positions
% aberr is a 2D image to visually show aberration
%
% input:
% im_siz is the pixel dimension of the MMF facet image
% zern_order is the n orders of the polynomial, must in 2 column form
% zern_coef  is a 1 by n the corresponding zernike coefficients
% pos_list is a column vector of the sampling positions
% r and theta are polar coordinates
% TM_form is the output form of TMaberr, can be either a diagonal matrix or a column vector
%       use vector form to speed up calculation
%
% the following table lists the first 15 Zernike functions.
%
%       n    m    Zernike function             Normalization        p
%       ------------------------------------------------------------------
%       0    0    1                              1/sqrt(pi)         0
%       1    1    r * cos(theta)                 2/sqrt(pi)         2
%       1   -1    r * sin(theta)                 2/sqrt(pi)         1
%       2    2    r^2 * cos(2*theta)             sqrt(6/pi)         5
%       2    0    (2*r^2 - 1)                    sqrt(3/pi)         4
%       2   -2    r^2 * sin(2*theta)             sqrt(6/pi)         3
%       3    3    r^3 * cos(3*theta)             sqrt(8/pi)         9
%       3    1    (3*r^3 - 2*r) * cos(theta)     sqrt(8/pi)         8
%       3   -1    (3*r^3 - 2*r) * sin(theta)     sqrt(8/pi)         7
%       3   -3    r^3 * sin(3*theta)             sqrt(8/pi)         6
%       4    4    r^4 * cos(4*theta)             sqrt(10/pi)        14
%       4    2    (4*r^4 - 3*r^2) * cos(2*theta) sqrt(10/pi)        13
%       4    0    6*r^4 - 6*r^2 + 1              sqrt(5/pi)         12
%       4   -2    (4*r^4 - 3*r^2) * sin(2*theta) sqrt(10/pi)        11
%       4   -4    r^4 * sin(4*theta)             sqrt(10/pi)        10
%       ------------------------------------------------------------------

% if r and theta not provided, generate by function itself
if ~exist('r', 'var') || isempty(r)
    x = linspace(-0.5, 0.5, im_siz);
    [X, Y] = meshgrid(x, x);
    [theta, r] = cart2pol(X, Y);
    theta = reshape(theta, [im_siz^2 1]);
    r = reshape(r, [im_siz^2 1]);
end

temp = zeros(im_siz, im_siz);
for ii = 1:size(zern_order,2)
    n = zern_order(1, ii);
    m = zern_order(2, ii);
    temp = temp + zern_coef(ii)*reshape(zernfun(n, m, r, theta), [im_siz im_siz]); 
end
aberr = exp(1i*temp);                                                       % full aberration plane

if exist('TM_form', 'var') && strcmp(TM_form, 'vector')
    TMaberr = aberr(pos_list);                                              % if TM output form is "vector"
else
    TMaberr = diag(aberr(pos_list));                                        % sampled aberration plane
end

end
