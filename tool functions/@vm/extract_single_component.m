% Custom extract algorithm
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function [trace, weightimg, offsetimg] = extract_single_component(obj)
            % iterative estimation of a single extracted component
            % together with its weight and residual offset images. 
            %
            % assumes a signal weightimg(x)*trace(t) + offsetimg(x)
            % forces weightimg and offsetimg to be blurry and have 5% negative values (seems to converge much faster than 0% negative values)
            % forces weightimg to have maximum value 1
            %
            % example: crop a movie to a single cell area using
            % submov = crop_rect(mov);
            % then estimate a single component as
            % [intens, weightimg, offsetimg] = extract_single_component(submov);
            % then check results as
            % estmov = vm(weightimg(:)*intens',submov.imsz)+offsetimg;
            % moviefixsc(estmov)
            initintens = obj.totaltrace;
            initintens = initintens(:);
            %%
            itertol = 1e-4; % stop when estimated traces change by less than one count maximum 
            maxiter = 100; % or stop after maxiter iterations if we havent stopped yet
            intens0 = [initintens 1+0*initintens];
            for it = 1:maxiter % max 20 iterations anyway
                disp(it)
                imgs = double(obj.tovec.data)/[intens0(:,1) mean(intens0(:,2),1)+0*intens0(:,1)]';
                vimgs = vm(imgs,obj.imsz);
                bvimgs = vimgs;
%                 bvimgs = blur(bvimgs,.5); % estimate blurry images
%                 bvimgs = bvimgs -permute(prctile(bvimgs.tovec.data,  0),[1 3 2]); % allow 5% of negative values in estimated images
%                 bvimgs = bvimgs./permute(prctile(bvimgs.tovec.data,100),[1 3 2]); % set maximum to 1 in estimated images
            %     moviesc(bvimgs,1)
                intens = (bvimgs.tovec.data\double(obj.tovec.data))';
                if max(abs(intens - intens0)) < itertol % check convergence
                    break % iter
                end
                intens0 = intens;
            end
%             figure(199)
%             moviesc(bvimgs,1)
%             figure(200)
%             plot(intens)
            trace = intens(:,1);
            weightimg = bvimgs.data(:,:,1);
            offsetimg = bvimgs.data(:,:,2).*mean(intens(:,2));
        end
