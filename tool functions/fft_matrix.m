function [T_fft_H, T_fft_V, xy_pos_in_FOV, F_pos_in_NA] = fft_matrix(img_size, H, V)
% generate inverse fft matrix that maps from F domain to real space
%
% outputs:
%   T_fft_H and T_fft_V are fft matrices
%   xy_pos_in_FOV is the indices of selected spatial channels in real space
%   F_pos_in_NA is the indices of selected F channels in F domain
%
% inputs:
%   img_size is the arbitrary number of sampling points along an output dimension
%   H and V are structures including experimental attributes

    [x, y] = meshgrid(1:img_size);
    FOV = sqrt( (x-round(img_size/2)).^2 + (y-round(img_size/2)).^2 ) < img_size/0.5;
    xy_pos_in_FOV = find(FOV == 1);
    
    [T_fft_H, F_pos_in_NA.H] = T_fft_assemble(H, xy_pos_in_FOV, img_size);
    [T_fft_V, F_pos_in_NA.V] = T_fft_assemble(V, xy_pos_in_FOV, img_size);
end

%% self-defined functions
function [T_fft, F_pos_in_NA] = T_fft_assemble(P, xy_pos_in_FOV, img_digital_size)
% input:
% P is a structure of experimental variables
% xy_pos_in_FOV is index of selected spatial chs at the output
% img_digital_size  is the number of sampling points along an output dimension
% 
% output:
% T_fft is a fft matrix transforming between output spatial chs to freq. chs
% F_pos_in_NA is a list of counted freq. chs

    delta = size(P.dis_SF,1)-1;
    n_dis_pos = numel(xy_pos_in_FOV);
    DC_aperture = circshift(P.dis_SF, [P.dis_kxshift, P.dis_kyshift]);      % shift the F aperture to DC
    
    F_pos_in_NA = find( DC_aperture == 1 );
    F_size = delta+1;
    
    n_F = numel(F_pos_in_NA);

    T_fft = complex(zeros(n_F, n_dis_pos));
    for ii = 1:n_dis_pos
        img_out = zeros(img_digital_size);
        img_out( xy_pos_in_FOV(ii) ) = 1;
        temp = fftshift(fft2( imresize(img_out, [F_size, F_size]) ));       % interpolate in real-space pads 0s in F domain
        
        T_fft(:, ii) = temp(F_pos_in_NA);
    end
end
