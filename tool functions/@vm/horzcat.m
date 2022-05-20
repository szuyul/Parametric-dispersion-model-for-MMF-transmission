% Horizontal concatenation
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
function newobj = horzcat(varargin)
    % concatenate movies along dim 2
    newobj = cat(2,varargin{:});
end
