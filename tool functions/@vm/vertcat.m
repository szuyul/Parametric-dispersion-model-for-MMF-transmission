% Vertical concatenation
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function newobj = vertcat(varargin)
            % concatenate movies along dim 1
            newobj = cat(1,varargin{:});
        end
