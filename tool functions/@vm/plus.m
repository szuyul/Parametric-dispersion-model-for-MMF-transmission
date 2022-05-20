% + Plus
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function newobj = plus(oi1,oi2)
            newobj = vm(bsxfun(@plus,double(oi1),double(oi2)));
        end
