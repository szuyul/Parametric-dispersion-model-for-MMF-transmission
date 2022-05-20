% + Unary plus
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function newobj = uplus(oi1)
            newobj = vm(uplus(oi1.data));
        end
