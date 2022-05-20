% Custom motion correction
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function [dxy] = estimate_displacement(m)
%             auxm = m.data;
%             auxm(auxm==min(auxm(:))) = NaN;
            % m(m==m(1)) = NaN;
%             auxm(isnan(auxm)) = prctile(reshape(auxm./auxm.*auxm,[],1),5);
%             m = vm(auxm);
%             clear auxm
%             moviefixsc(m)
            %
            fm = fft(m);
            fmm = fft2(m.mean);
            r = ifft((fm.*conj(fmm))./abs(fm.*conj(fmm)));
            r = r.data;
            clear fm fmm
            r(isnan(r)) = 0;
            r(1,1,:) = (...
                r(1,2,:) + ...
                r(2,1,:) + ...
                r(1,end,:) + ...
                r(end,1,:))/4;
            p = vm(r);
            p = blur(real(fftshift(p)));
            clear r
            p = p.data;
            %
            [yy, xx] = ndgrid(1:m.rows,1:m.cols);
            cloc = ceil(([m.cols m.rows]+1)/2);
            % gaus = @(x)exp(-((xx-x(1)).^2+(yy-x(2)).^2)/x(3).^2);
            % gausw = gaus([17 14 7]);
            % objf = @(img,x)sum(sum((img./max(img(:)) - gaus(x)).^2.*gausw));
            % fminsearch(@(x)objf(p(:,:,1),x),[17,14,1.5])
            gaus = @(x)exp(-((xx-x(1)).^2+(yy-x(2)).^2)/pi);
            gausw = gaus(cloc).^.25;
            objf = @(img,x)sum(sum((img./max(img(:)) - gaus(x)).^2.*gausw));
            fminsearch(@(x)objf(p(:,:,1),x),cloc);
            %
            addpath '\\cohenfs.rc.fas.harvard.edu\Cohen_Lab\Lab\Labmembers\Vicente Parot\Code\2013\2013-10-21 include'
%             addpath 'X:\Lab\Labmembers\Vicente Parot\Code\2013\2013-10-21 include'
            params = zeros(m.frames,2);
            params(1,:) = fminsearch(@(x)objf(p(:,:,1),x),cloc);
            mlt = tls;
            for it = 2:m.frames % ceil(rand*m.frames):m.frames
%                 params(it,:) = fminsearch(@(x)objf(p(:,:,it),x),params(it-1,:));
                [rmax, cmax] = find(p(:,:,it) == max(max(p(:,:,it))),1);
                params(it,:) = [cmax rmax]; % fminsearch(@(x)objf(p(:,:,it),x),params(it-1,:));
                tlp(it/m.frames,mlt);
            end
            tle(mlt);
            mlt = tls;
            for it = 2:m.frames % ceil(rand*m.frames):m.frames
                params(it,:) = fminsearch(@(x)objf(p(:,:,it),x),params(it,:));
%                 [rmax, cmax] = find(p(:,:,it) == max(max(p(:,:,it))));
%                 params(it,:) = [cmax rmax]; % fminsearch(@(x)objf(p(:,:,it),x),params(it-1,:));
                tlp(it/m.frames,mlt);
            end
            tle(mlt);
            dxy = bsxfun(@minus,params,cloc);
        end
