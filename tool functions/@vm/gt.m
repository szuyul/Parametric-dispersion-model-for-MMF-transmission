% > Greater than
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = gt(obj,ex)
            obj = vm(gt(double(obj),double(ex)));
        end
