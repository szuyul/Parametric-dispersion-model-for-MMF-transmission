% .^ Element wise power
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = power(obj,ex)
            obj.data = obj.data.^ex;
        end
