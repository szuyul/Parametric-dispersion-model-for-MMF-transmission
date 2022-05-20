% repmat
%
% 2017 Vicente Parot
% Cohen Lab - Harvard University

function newobj = repmat(obj,varargin)
    % repmat
    newobj = vm(repmat(obj.toimg.data,varargin{:}));
end
