% Write a compressed movie file
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function saveavi(obj,fname)
            % save compressed avi movie
            if nargin > 1
                pname = '';
            else
                [fname, pname] = uiputfile('*.avi');
            end
            fullname = fullfile(pname,fname);
            tic
            fprintf('saving %s ...\n',fullname)
            v = VideoWriter(fullname);
            if isreal(obj.data)
                v.FrameRate = 25;
                v.Quality = 95;
                v.open
                dat = single(permute(obj.toimg.data,[1 2 4 3]));
                obj = obj.setSaturationLimits;
                dat = dat - single(obj.SortedFew(ceil(obj.DisplaySaturationFraction*end)));
                dat = dat./single(diff(obj.SortedFew(ceil([obj.DisplaySaturationFraction 1-obj.DisplaySaturationFraction]*end))'));
                dat = min(1,max(0,dat));
                writeVideo(v,uint8(dat*256))
            else
                v.FrameRate = 4;
                v.Quality = 100;
                v.open
                cplxdat = single(permute(obj.toimg.data,[1 2 4 3]));
                rgbimg = zeros(size(repmat(cplxdat,[1 1 3])));
                rgbimg(:,:,1,:) = abs(cplxdat);
                rgbimg(:,:,2,:) = -imag(cplxdat);
                rgbimg(:,:,3,:) = -real(cplxdat);
                if isempty(obj.SaturationLimits)
                    obj = obj.setSaturationLimits;
                    lims = double(obj.SaturationLimits);
                else
                    lims = double(obj.SaturationLimits);
                end
                ps = prctile(abs(obj.tovec.data),99.999);
                rgbimg = lab2rgb(rgbimg./lims(2)./permute(ps,[1 4 3 2])*2300);
                rgbimg = min(1,max(0,rgbimg));
                writeVideo(v,uint8(rgbimg*256))
            end
            v.close
            disp(['saving took ' num2str(toc) ' s']);
        end
