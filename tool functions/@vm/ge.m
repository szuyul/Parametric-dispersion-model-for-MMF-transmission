% >= Greater or equal than
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ge(obj,ex)
            obj = vm(ge(double(obj),double(ex)));
        end
