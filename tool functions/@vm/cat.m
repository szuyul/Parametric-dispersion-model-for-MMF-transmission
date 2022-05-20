% Concatenation along any dimension
%
% 2017 Vicente Parot
% Cohen Lab - Harvard University

function newobj = repmat(dim,varargin)
    % concatenate movies along any dim
    if isnumeric(dim) && isscalar(dim)
        cfun = cellfun(@(el)el.data,varargin,'uni',false);
        newobj = vm(cat(dim,cfun{:}));
    end
    if isa(dim,'vm')
        if isnumeric(varargin{1}) && isscalar(varargin{1})
            % swap them
            temp = dim;
            dim = varargin{1};
            varargin{1} = temp;
            newobj = cat(dim,varargin{:});
        else
            % assume cat(3,...)
            newobj = cat(3,varargin{:});
        end
    end
end
