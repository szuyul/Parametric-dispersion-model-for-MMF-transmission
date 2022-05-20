% Solve linear system of projection along frame dimension
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = mldivide(obj1,obj2)
            % special matrix operation between movies
            % estimate patterns from data and reference locations
            % d*p = r -> p = d\r
            img = double(obj1.tovec.data)\double(obj2.tovec.data);
        end
