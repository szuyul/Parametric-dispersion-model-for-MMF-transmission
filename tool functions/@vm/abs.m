% Absolute value
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = abs(obj)
            obj = vm(abs(obj.data));
        end
