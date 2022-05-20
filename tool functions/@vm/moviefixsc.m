% Display movie with fixed scale intensity
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function moviefixsc(obj,lim,fr)
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
            moviesc(obj,fr,'fixed')
        end
