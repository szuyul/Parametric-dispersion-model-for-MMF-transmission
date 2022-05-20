% Complex conjugate
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = conj(obj)
            obj.data = conj(obj.data);
        end
