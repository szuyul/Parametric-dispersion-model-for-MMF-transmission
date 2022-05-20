% Sets the colormap limits for display
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = setSaturationLimits(obj,userlim)
            if exist('userlim','var')
                obj.SaturationLimits = userlim;
            else
                targetelms = 1e7;
                rszf = max(1/8,min(1,sqrt(targetelms/numel(obj.data))));
                if isreal(obj.data)
                    obj.SortedFew = sort(reshape(imresize(obj.data,rszf),[],1));
                    lims = double(obj.SortedFew);
                    lims = lims(~isnan(lims));
                    lims = lims(~isinf(lims));
                    lims = lims(max(1,ceil([obj.DisplaySaturationFraction 1-obj.DisplaySaturationFraction]*end)))';
                    if numel(lims) < 2
                        lims = [0 1];
                    end            
                    if ~diff(lims)
                        lims = lims + [0 eps];
                    end
                else
                    obj.SortedFew = sort(reshape(imresize(abs(obj.data),rszf),[],1));
                    lims = double(obj.SortedFew);
                    lims = lims(~isnan(lims));
                    lims = lims(~isinf(lims));
                    lims = lims(max(1,ceil((1-obj.DisplaySaturationFraction)*end)));
                    if lims
                        lims = [0 lims];
                    else
                        lims = [0 1];
                    end
                end
                obj.SaturationLimits = lims;
            end
        end
