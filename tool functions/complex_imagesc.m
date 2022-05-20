function [  ] = complex_imagesc(img, amp_range, varargin)
% input: 
% img is an image in either vector form or 2D form
% amp_range is the range of amplitude for colormap

% output: in the current figure, plot the complex field without ticks

if ismember(1, size(img))
    img_dim = sqrt(length( img ));
    oimg = reshape( img , [img_dim img_dim]);
else 
    oimg = img;
end

imgmax = max(max(abs(oimg)));
field = oimg/imgmax;
if nargin == 2    % if the amplitude range is given
    image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], amp_range)); 
else              % otherwise normalize the amplitude
    image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], [0 1])); 
end

set(gca,'XTick',[], 'YTick',[]);    axis image

end

