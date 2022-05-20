% Shift zero-frequency component to center of spectrum along dims 1 and 2 
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = fftshift(obj)
            % fast fourier transform
            obj = vm(fftshift(fftshift(obj.data,1),2));
        end
