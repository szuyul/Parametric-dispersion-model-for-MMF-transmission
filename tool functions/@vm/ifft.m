% Two-dimensional inverse discrete Fourier Transform in each frame
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ifft(obj)
            % fast fourier transform
            obj = vm(ifft2(obj.data));
        end
