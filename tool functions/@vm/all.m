% True if all elements are true along 3rd dimension. Ignores NaNs.
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = all(obj)
            img = all(obj.data,3);
        end
