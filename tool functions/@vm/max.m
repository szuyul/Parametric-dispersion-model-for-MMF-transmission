% Maximum intensity projection
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = max(obj)
            img = max(obj.data,[],3);
        end
