% Remove constant borders from movie
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = trim(obj)
            % remove constant border values
            if isnan(obj.data(1))
                mask = ~isnan(obj.data);
            else
                mask = ~(obj.data == obj.data(1));
            end
            idxs = find(mask);
            [r, c, ~] = ind2sub(size(mask),idxs);
            obj = vm(obj.data(min(r):max(r),min(c):max(c),:));
        end
