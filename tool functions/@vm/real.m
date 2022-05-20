% Real part
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = real(obj)
            obj = vm(real(obj.data));
        end
