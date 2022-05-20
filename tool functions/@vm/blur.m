% Gaussian blur performed with imfilter
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = blur(obj,sigma)
            % gaussian filter each image
            if ~exist('sigma','var')
                sigma = 1;
            end
            ker = fspecial('gaussian',2*ceil(2*sigma)+1,sigma);
            [obj.data] = imfilter(double(obj.data),ker,'replicate');
%             [obj.rows, obj.cols, obj.frames] = size(obj.data);
        end
