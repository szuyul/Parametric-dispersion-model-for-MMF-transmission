% Independent xy translation applied to each frame by phase shifting
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = apply_displacement(obj,dxy)
            [yy, xx] = ndgrid(ifftshift(1:obj.rows)-1,ifftshift(1:obj.cols)-1);
            yy = yy - yy(1);
            xx = xx - xx(1);
            dx = permute(-dxy(:,1),[3 2 1]);
            dy = permute(-dxy(:,2),[3 2 1]);
            ph = exp(-1i*2*pi*(bsxfun(@times,dy,yy)/obj.rows+bsxfun(@times,dx,xx)/obj.cols));
            obj = real(ifft(fft(obj).*ph));
        end
