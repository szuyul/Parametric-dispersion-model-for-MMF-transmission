function [  ] = complex_imgplot( img, f_pos_siz, plot_name, c_limit, varargin )
% input: an image in either flattened vector form or original 2D form
% output: create a new figure and plot the complex field without ticks

if ismember(1, size(img))               % if the image is either a row or column vecotr
    img_dim = sqrt(length( img ));
    oimg = reshape( img , [img_dim img_dim]);
else                                    % if the image is in original 2D form
    oimg = img;
end

if nargin < 2                           % if the figure position and size not specified
    f_pos_siz = [300, 300, 400, 400];
end
figure('Position', f_pos_siz)

if nargin < 3                           % if the title is not specified
    plot_name = 'complex field';
end

imgmax = max(max(abs(oimg)));           % normalize the image amplitude
field = oimg/imgmax;

if nargin < 4                           % if the brightness range not specified
    c_limit = [0 1];
end
image(HueOverLum(angle(field), abs(field), colormap(cmap('C6')), [-pi, pi], c_limit)); 
title(plot_name)
set(gca,'XTick',[], 'YTick',[], 'FontSize', 20);    axis image

%% generate colormap
[cmap_x, cmap_y] = meshgrid(linspace(-1, 1, 101),linspace(-1, 1, 101));
circ_cmap = cmap_x + 1i*cmap_y;
circ_cmap(sqrt(cmap_x.^2 + cmap_y.^2) > 1) = 0;
axes('pos',[.14 .14 .1 .1])
image(HueOverLum(angle(circ_cmap), abs(circ_cmap), colormap(cmap('C6')), [-pi, pi], [0 1]));
set(gca,'XTick',[], 'YTick',[]);    axis image

%{
% used to plot amplitude 
subplot(1,2,2)
colormap('gray')
imagesc(abs(oimg));
title('amplitude of the field')
axis image
set(gca,'XTick',[], 'YTick',[]);
%}
end

