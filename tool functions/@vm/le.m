% <= Less or equal than 
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = le(obj,ex)
            obj = vm(le(double(obj),double(ex)));
        end
