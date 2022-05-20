% == Equal
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = eq(obj,ex)
            obj = vm(eq(double(obj),double(ex)));
        end
