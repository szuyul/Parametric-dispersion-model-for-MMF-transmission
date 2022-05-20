% ~= Not equal
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ne(obj,ex)
            obj = vm(ne(double(obj),double(ex)));
        end
