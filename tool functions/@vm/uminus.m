% - Unary minus
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function newobj = uminus(oi1)
            newobj = vm(uminus(oi1.data));
        end
