% Extract the image data of a single frame
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = frame(obj,fr)
            % extract frame image
            obj = obj.toimg;
            img = obj.data(:,:,fr);
        end
