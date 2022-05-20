% Concatenation along 3rd dimension
%
% 2017 Vicente Parot
% Cohen Lab - Harvard University

function newobj = framecat(varargin)
    % concatenate movies along any dim
    newobj = cat(3,varargin{:});
end
