% ~ Not
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = not(obj)
            obj = vm(not(double(obj)));
        end
