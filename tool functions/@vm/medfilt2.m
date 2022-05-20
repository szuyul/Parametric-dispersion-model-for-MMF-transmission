% Median filter each frame
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = medfilt2(obj,varargin)
            for it = 1:obj.frames
                obj.data(:,:,it) = medfilt2(obj.data(:,:,it),varargin{:});
            end
            obj = vm(obj.data);
        end
