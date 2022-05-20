% True if any element is true along 3rd dimension. Ignores NaNs.
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = any(obj)
            img = any(obj.data,3);
        end
