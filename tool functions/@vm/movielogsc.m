% Display movie with Log scale intensity
%
% vm: Vectorized movie class
%
% 2021 Vicente Parot
% Institute for Biological and Medical Engineering
% Catholic University of Chile
%
        function movielogsc(obj,lim,fr)
            % display movie with fixed scale
            % optionally input scale limits, then initially displayed frame
            if ~exist('fr','var')
                fr = 1;
            end
            if exist('lim','var')
                obj = obj.setSaturationLimits(lim);
            else
                obj = obj.setDisplaySaturationFraction(obj.DisplaySaturationFraction*1e-2);
                obj = obj.setSaturationLimits;
            end
            moviesc(obj,fr,'log')
        end
