% Sets scales alond row and column dimensions
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = setScale(obj,xscale,yscale)
            % set scales for display
            if ~exist('yscale','var')
                yscale = xscale;
            end
            obj.xscale = xscale;
            obj.yscale = yscale;
        end
