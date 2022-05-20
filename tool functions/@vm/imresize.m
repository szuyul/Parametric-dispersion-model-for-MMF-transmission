% Resize the frame size of the movie
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = imresize(obj,varargin)
            % resize images in whole movie
            [obj.data, ~] = imresize(obj.data,varargin{:});
            [obj.rows, obj.cols, obj.frames] = size(obj.data);
        end
