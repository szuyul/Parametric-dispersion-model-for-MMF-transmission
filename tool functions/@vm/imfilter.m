% Wrapper for imfilter
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = imfilter(obj,varargin)
            [obj.data] = imfilter(double(obj.data),varargin{:});
        end
