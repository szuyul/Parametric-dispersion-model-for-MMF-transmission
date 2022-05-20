function all_plot(out_X, out_Y, w)
    n_f = numel(w);
    figure('Position', [100, 100, 1800, 300])
    img_max = max( [max(abs(out_X),[],'all'), max(abs(out_Y),[],'all')] );
    for ll = 1:n_f
        subplot(2,n_f,ll);
        field = out_X(:,:,ll)/img_max;
        image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], [0 0.8]));  
        axis image
        title(num2str(w(ll)))
        
        subplot(2,n_f,ll+n_f);
        field = out_Y(:,:,ll)/img_max;
        image(HueOverLum(angle(field), abs(field), colormap(gca, cmap('C6')), [-pi, pi], [0 0.8]));  
        axis image
    end
end