% Sets the fraction of intensity values to be saturated for display
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = setDisplaySaturationFraction(obj,sat)
            % set saturation fraction for movie display
            obj.DisplaySaturationFraction = sat;
        end
