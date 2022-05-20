% Inverse FFT shift along dims 1 and 2 
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ifftshift(obj)
            % fast fourier transform
            obj = vm(ifftshift(ifftshift(obj.data,1),2));
        end
