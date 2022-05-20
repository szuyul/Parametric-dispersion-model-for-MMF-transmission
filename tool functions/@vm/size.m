% Size of movie
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function varargout = size(obj,varargin)
            % movie dimensions
            switch nargout
                case 0
                    varargout = {size(obj.data,varargin{:})};
                otherwise
                    eval(['[' sprintf('v%d, ',1:nargout) '] = size(obj.data,varargin{:});'])
                    varargout = eval(['{' sprintf('v%d, ',1:nargout) '}']);
            end
        end
