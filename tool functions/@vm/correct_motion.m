% Custom motion correction algorithm
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function varargout = correct_motion(obj,dxy)
            if ~exist('dxy','var')
                dxy = ones(100,1);
                dxyn = nlm1d(dxy); %   make sure we have these functions
                dxys = smooth1d(dxyn); % before an expensive computation
                [dxy] = estimate_displacement(obj);
                dxyn = nlm1d(dxy);
                dxys = smooth1d(dxyn);
                dxy = dxys;
            end
            obj = apply_displacement(obj,dxy);
            switch nargout
                case {0,1}
                    varargout = {obj};
                case 2
                    varargout = {obj,dxy};
                otherwise
                    error 'too many output arguments'
            end
        end
