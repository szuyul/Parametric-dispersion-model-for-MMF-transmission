% Crops movie to a smaller rectangular ROI
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = crop_rect(obj,rect)
            % crop movie around rect = [xpos ypos width height]
            if nargin > 1 && isequal(size(rect),[1 4])
                rectpos = rect;
            else
                moviesc(obj,ceil(obj.frames/2))
                rectpos = getrect;
            end
            obj.data = obj.data(...
                max(1,floor(rectpos(2))):min(ceil(rectpos(2)+rectpos(4)),obj.rows),...
                max(1,floor(rectpos(1))):min(ceil(rectpos(1)+rectpos(3)),obj.cols),:);
            [obj.rows, obj.cols, obj.frames] = size(obj.data);
        end
