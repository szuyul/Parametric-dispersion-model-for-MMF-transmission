% Std along frame dimension
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = nanstd(obj)
            img = nanstd(double(obj.data),1,3);
        end
