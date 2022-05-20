% Approximate gradient
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
function varargout = gradient(obj)
    switch nargout
        case 0
            varargout{1} = gradient(obj.data);
        case 1
            varargout{1} = gradient(obj.data);
        case 2
            [fx, fy] = gradient(obj.data);
            varargout{1} = fx;
            varargout{2} = fy;
        case 3
            [fx, fy, fz] = gradient(obj.data);
            varargout{1} = fx;
            varargout{2} = fy;
            varargout{2} = fz;
        otherwise
            error 'vm gradient undefined for this output format'
    end
end