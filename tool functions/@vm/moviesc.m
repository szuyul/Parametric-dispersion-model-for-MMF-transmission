% Display movie with scaled intensity
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function moviesc(obj,fr,scalingmode)
            % display movie with auto scale
            % optionally input the initially displayed frame, defaults to 1
            if ~exist('fr','var')
                fr = 1;
            end
            if ~exist('scalingmode','var')
                scalingmode = 'frame';
            end
            
            obj = obj.toimg;
            fi = gcf;
            clf reset;
            ax = gca;
            sliderHeight = 20;
            uf = uicontrol(fi,'style','slider');
            uf.Value = (fr-.5)/obj.frames;
            if obj.frames > 1
                addlistener(uf,'Value','PostSet',@(hObj,event)moviescUpdateFrame(hObj,event,ax));
                fi.SizeChangedFcn = @moviescFigResize;
                fi.WindowScrollWheelFcn = @moviescScrollWheel;
            end

            ax.Units = 'pixels';
            ax.Position(2) = ax.Position(2) + sliderHeight;
            ax.Position(4) = ax.Position(4) - sliderHeight;
            ax.Units = 'normalized';
            uf.Units = 'normalized';
            uf.Position([1 3]) = ax.Position([1 3]);
            uf.Units = 'pixels';
            uf.Position([2 4]) = [1 sliderHeight];
            uf.Units = 'normalized';
            
            
            if isreal(obj.data)
                im = obj.frame(fr);
                if ~isempty(obj.SaturationLimits)
                    lims = double(obj.SaturationLimits);
                else
                    lims = sort(im(:))';
                    lims = lims(~isnan(lims));
                    lims = lims(~isinf(lims));
                    lims = double(lims);
                    lims = lims([1 end]);
                    lims = lims + [0 eps(lims(2))];
                end
                if ~isempty(obj.xscale)
                    imagesc(obj.xscale,obj.yscale,im,lims)
                else
                    imagesc(im,lims)
                end
            else
                ofr = obj.frame(fr);
                if ~isempty(obj.SaturationLimits)
                    lims = double(obj.SaturationLimits);
                else
                    lims = sort(abs(ofr(:)))';
                    lims = lims(~isnan(lims));
                    lims = lims(~isinf(lims));
                    lims = double(lims);
                    lims = lims([1 end]);
                    lims = lims + [0 eps(lims(2))];
                end
                switch scalingmode
                    case 'log'
                        im = cplx2rgbLog(ofr,lims);
                    otherwise
                        im = cplx2rgb(ofr,lims);
                end
                if ~isempty(obj.xscale)
                    imagesc(obj.xscale,obj.yscale,im,lims)
                else
                    imagesc(im,lims)
                end
            end

            ut = uicontrol('style','text','FontSize',10,'HorizontalAlignment','left');
            ut.Units = 'pixels';
            uf.Units = 'pixels';
            ut.Position(1) = uf.Position(1);
            ut.Position(3) = ut.Position(3) + 20;
            ut.Position(2) = sum(uf.Position([2 4]));
            uf.Units = 'normalized';

            if obj.frames > 1
                addlistener(uf,'Value','PostSet',@(hObj,event)moviescUpdateFrame(hObj,event,ax));
            else
                ut.Visible = 'off';
                uf.Visible = 'off';
            end

            cb = colorbar;
            cax = axes;
            cax.Visible = false;

            setappdata(fi,'scalingmode',scalingmode)
            setappdata(fi,'ut',ut)
            setappdata(fi,'uf',uf)
            setappdata(fi,'ax',ax)
            setappdata(fi,'sliderHeight',sliderHeight)
            setappdata(fi,'myMov',obj)
            setappdata(fi,'fr',fr)
            setappdata(fi,'cb',cb)
            setappdata(fi,'cax',cax)

            moviescRedraw(fi)
            colormap(ax,gray(2^11))
            axis(ax,'equal','tight')
            
            switch scalingmode
                case 'log'
                    if isreal(obj.data)
                    else
                        % draw intensity phase colorbar
                        cm = cplx2rgbLog(10.^(linspace(lims(1),lims(2),100)/10).*exp(1i*linspace(-pi,pi,100)'),lims);
                        cax.Visible = true;
                        cb.Visible = false;
                        cax.Position = cb.Position;
                        cax.Position = cax.Position.*[1.02 1 1.5 1];
                        imagesc(lims,[-pi,pi],cm)
                        axis xy
                        cax.YAxisLocation = 'right';
                        cax.XTick = lims;
                        cax.YTick = [-pi:pi/2:pi];
                        cax.YTickLabel = {'-\pi','-\pi/2',0,'\pi/2','\pi'};
                        xlabel 'Log(Intensity)'
                        ylabel 'Angle'
                        cax.FontSize = 9;
                        cax.XLabel.FontSize = 9; 
                        cax.YLabel.FontSize = 9;
                        fi.SizeChangedFcn = @moviescFigResize;
                    end
            end
            fi.CurrentAxes = ax;
        end

function moviescRedraw(src)
% update figure image data when advancing frames
% 2016 Vicente Parot
% Cohen Lab - Harvard University
    sm = getappdata(src,'scalingmode');
    ut = getappdata(src,'ut');
    ax = getappdata(src,'ax');
    myMov = getappdata(src,'myMov');
    fr = getappdata(src,'fr');
    imh = findall(ax.Children,'Type','Image');
    if isreal(myMov.data)
        imh(1).CData = myMov.frame(fr);
        switch sm
            case 'frame'
                % change scaling for every frame
                lims = sort(imh(1).CData(:));
                lims = lims(~isnan(lims));
                lims = lims(~isinf(lims));
                lims = double(lims);
                lims = lims(max(1,ceil([myMov.DisplaySaturationFraction 1-myMov.DisplaySaturationFraction]*end)));
                if numel(lims) < 2
                    lims = [0 1];
                end            
                if ~diff(lims)
                    lims = lims + [0 eps(lims(2))]';
                end
                ax.CLim = lims;
            case {'fixed','log'}
                % scaling was initially set already
                ax.CLim = myMov.SaturationLimits;
        end
    else
        ofr = myMov.frame(fr);
        switch sm
            case 'frame'
                % change scaling for every frame
                lims = sort(abs(ofr(:)));
                lims = lims(~isnan(lims));
                lims = lims(~isinf(lims));
                lims = double(lims);
                lims = lims(max(1,ceil((1-myMov.DisplaySaturationFraction)*end)));
                if lims
                    lims = [0 lims];
                else
                    lims = [0 1];
                end
                im = cplx2rgb(ofr,lims);
            case 'fixed'
                % scaling was initially set already
                lims = myMov.SaturationLimits;
                im = cplx2rgb(ofr,lims);
            case 'log'
                % scaling was initially set already
                lims = myMov.SaturationLimits;
                im = cplx2rgbLog(ofr,lims);
        end
        imh(1).CData = im;
        ax.CLim = lims;
    end
    ut.String = sprintf('frame %d',fr);
    src.CurrentAxes = ax;
end

function moviescUpdateFrame(~,event,ax)
% advance frames when slider moves
% 2016 Vicente Parot
% Cohen Lab - Harvard University
    myMov = getappdata(ax.Parent,'myMov');
    fr = max(1,min(ceil(event.AffectedObject.Value*(myMov.frames)),myMov.frames));
    setappdata(ax.Parent,'fr',fr)
    moviescRedraw(ax.Parent)
end

function moviescScrollWheel(src,callbackdata)
% advance frames when wheel-scrolling
% 2016 Vicente Parot
% Cohen Lab - Harvard University
    fr = getappdata(src,'fr');
    uf = getappdata(src,'uf');
    myMov = getappdata(src,'myMov');
    switch callbackdata.VerticalScrollCount
        case -1
            fr = max(1,fr-1);
        case 1
            fr = min(myMov.frames,fr+1);
    end
    uf.Value = (fr-1)/(myMov.frames-1);
    setappdata(src,'fr',fr)
    moviescRedraw(src)
end

function moviescFigResize(src,~)
% reorganize movie figure when resizing
% 2016 Vicente Parot
% Cohen Lab - Harvard University
    uf = getappdata(src,'uf');
    ut = getappdata(src,'ut');
    sliderHeight = getappdata(src,'sliderHeight');
    uf.Units = 'pixels';
    uf.Position(4) = sliderHeight;
    uf.Units = 'normalized';
    ut.Units = 'pixels';
    uf.Units = 'pixels';
    ut.Position(1) = uf.Position(1);
    ut.Position(2) = sum(uf.Position([2 4]));
    uf.Units = 'normalized';
    ax = getappdata(src,'ax');
    cb = getappdata(src,'cb');
    cax = getappdata(src,'cax');
    cax.Position = cb.Position;
    cax.Position = cax.Position.*[1.02 1 1.5 1];
    src.CurrentAxes = ax;
end

function rgbimg = cplx2rgb(cplximg,lims)
    assert(ismatrix(cplximg),'input must be a 2D matrix')
    assert(~~exist('lims','var'),'limits must be provided')
    
% % hue colormap
%     rgbimg = zeros([size(cplximg) 3]);
%     rgbimg(:,:,1) = angle(cplximg)/pi/2+.5;
%     rgbimg(:,:,2) = rgbimg(:,:,2)*0 + 1;
%     rgbimg(:,:,3) = abs(cplximg);
%     rgbimg(:,:,3) = max(0,rgbimg(:,:,3));
%     rgbimg(:,:,3) = rgbimg(:,:,3)./lims(2);
%     rgbimg(:,:,3) = min(1,rgbimg(:,:,3));
%     rgbimg = hsv2rgb(rgbimg);    

% Lab colorspace
    rgbimg = zeros([size(cplximg) 3]);
    rgbimg(:,:,1) = abs(cplximg);
    rgbimg(:,:,2) = -imag(cplximg);
    rgbimg(:,:,3) = -real(cplximg);
    rgbimg = lab2rgb(rgbimg./lims(2)*60);
end

function rgbimg = cplx2rgbLog(cplximg,lims)
    assert(ismatrix(cplximg),'input must be a 2D matrix')
    assert(~~exist('lims','var'),'limits must be provided')
    clippedData = 10*log10(abs(cplximg));
    clippedData = clippedData-lims(1);
    clippedData = clippedData/(lims(2)-lims(1));
    clippedData = min(1,clippedData);
    clippedData = max(0,clippedData);
    clippedData = clippedData.*cplximg./abs(cplximg);
    rgbimg = zeros([size(clippedData) 3]);
    rgbimg(:,:,1) = abs(clippedData);
    rgbimg(:,:,2) = -imag(clippedData);
    rgbimg(:,:,3) = -real(clippedData);
    rgbimg = lab2rgb(rgbimg*50);
end