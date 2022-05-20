% Removes photobleaching dividing by a fitted exponential
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = pblc(obj,skip,stop)
            % photobleach correction dividing dataset by fitted exponential
            % shape. optionally exclude initial SKIP samples from the fit,
            % defaulting to 0 when omitted.
            if ~exist('stop','var'), stop = obj.frames; end
            if ~exist('skip','var'), skip = 0; end
            p = mean(obj.tovec.data,1);
            t = (0:obj.frames-1);
            tau = 1000;
            q = p(1+skip:stop);
            offs = mean(q(ceil(.75*end):end));
            amp = mean(q(1:ceil(.25*end)))-offs;
            expf = @(t,v)v(1) + (v(2))*(exp(-t/v(3)));
            objf = @(v)sum((p(skip+1:stop) - expf(t(skip+1:stop),v)).^2);
            initialparams = [offs amp tau];
            fittedparams = fminsearch(objf,initialparams);
            fittedcurve = permute(expf(t,fittedparams),[1 3 2]);
%             dbstop in vm at 478 if any(fittedcurve<0)
            obj = obj./fittedcurve.*mean(p);
%             obj.meantrace = reshape(mean(mean(obj.data,1),2),[],1);
        end
