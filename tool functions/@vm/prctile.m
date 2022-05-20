% Prctile along frame dimension
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = prctile(obj,p)
            img = prctile(double(obj.data),p,3);
        end
