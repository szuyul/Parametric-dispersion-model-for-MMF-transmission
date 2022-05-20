% Two-dimensional discrete Fourier Transform in each frame
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = fft(obj)
            % fast fourier transform
            obj = vm(fft2(obj.data));
        end
