% Permute movie dimensions
%
% vm: Vectorized movie class
%
% 2017 Sami Farhi
% Cohen Lab - Harvard University
%
        function obj = permute(obj,varargin)
            % resize images in whole movie
            [obj.data] = permute(obj.data,varargin{:});
            [obj.rows, obj.cols, obj.frames] = size(obj.data);
        end
