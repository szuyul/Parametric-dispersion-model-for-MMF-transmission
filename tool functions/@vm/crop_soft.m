% Crops movie to a smaller polygon ROI and sets smooth borders
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = crop_soft(obj,poly)
            % crop movie around polygon with soft borders
            sigmasoft = 2;
            if nargin > 1 && isequal(class(poly),'impoly')
                roipoly = poly;
            else
                moviesc(obj)
                imshow(std(single(obj.data(:,:,ceil(rand(min(obj.frames,2000),1)*obj.frames))),0,3),[])
                roipoly = impoly;
            end
            polymask = roipoly.createMask;
            cr1 = max(floor(min(roipoly.getPosition)),1);
            cr2 = min(ceil(max(roipoly.getPosition)),[obj.cols obj.rows]);
            obj.data = obj.data(cr1(2):cr2(2),cr1(1):cr2(1),:);
            [obj.rows, obj.cols, obj.frames] = size(obj.data);
            polymask = polymask(cr1(2):cr2(2),cr1(1):cr2(1));
            polymask = imgaussfilt(double(polymask),sigmasoft);
            polymask = min(max(polymask,0),1);
            bgmask = max(imgaussfilt(polymask,3),polymask)-polymask;
%             bgmask = imdilate(polymask,ones(5))-polymask;
            bgvalue = sum(sum(mean(obj.*bgmask)))./sum(sum(bgmask));
            obj = obj.*polymask + bgvalue.*(1-polymask);
            moviefixsc(obj,[0 max(max(mean(obj)))])
        end
