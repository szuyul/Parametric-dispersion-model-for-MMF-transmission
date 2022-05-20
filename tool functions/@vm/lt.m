% < Less than 
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = lt(obj,ex)
            obj = vm(bsxfun(@lt,double(obj),double(ex)));
        end
