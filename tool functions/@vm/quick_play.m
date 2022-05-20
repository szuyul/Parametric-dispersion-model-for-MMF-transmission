% Plays a movie as fast as possible in a new figure
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
function quick_play(mov,nr,nc)
%quick_play quickly plays frames in a movie.
%   quick_play(mov,nr,nc) plays the movie mov. mov can be in vector
%   format of size [nr*nc nt]; if it is in image format of size [nr nc nt],
%   the second and third input arguments are ignored. Frames are played in
%   a new figure as fast as possible. The contrast is adjusted to saturate
%   approximately .05% of the highest and lowest values.
%
%   2014 Vicente Parot
%   Cohen Lab - Harvard University
%
    mov = mov.data; % double(mov);
    if numel(size(mov)) > 2;
        [nr nc nt] = size(mov);
    else
        nt = size(mov,2);
        mov = reshape(mov,nr,nc,nt);
    end
    ns = min(1e4,numel(mov));
    sval = sort(mov(ceil(rand(ns,1)*end)));
    figure
    ih = imshow(zeros(nr,nc),[sval(ceil(.0005*ns)) sval(ceil(.9995*ns))]);
    try
        for it = 1:nt
            set(ih,'CData',mov(:,:,it));
            title(['frame: ' num2str(it)])
            drawnow
        end
    catch me
        warning(getReport(me,'extended','hyperlinks','on'))
    end
end