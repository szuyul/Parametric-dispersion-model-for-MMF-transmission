% Crops movie to a smaller polygon ROI
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = crop(obj,poly)
            % crop movie around polygon
            if nargin > 1 && isequal(class(poly),'impoly')
                roipoly = poly;
                polymask = roipoly.createMask;
%                 polyroi = roipoly.getPosition;
            elseif nargin > 1 
                [x, y] = meshgrid(1:obj.cols, 1:obj.rows);
                xv = poly(:,1);
                yv = poly(:,2);
                polymask = inpolygon(x,y,xv,yv);
%                 polyroi = poly;
            else
                obj.moviesc
                roipoly = impoly;
                polymask = roipoly.createMask;
%                 polyroi = roipoly.getPosition;
            end
            obj = obj.*polymask;
            obj = obj.trim;
%             cr1 = max(floor(min(polyroi)),1);
%             cr2 = min(ceil(max(polyroi)),[obj.cols obj.rows]);
%             obj.data = obj.data(cr1(2):cr2(2),cr1(1):cr2(1),:);
%             [obj.rows, obj.cols, obj.frames] = size(obj.data);
%             obj = obj.*polymask(cr1(2):cr2(2),cr1(1):cr2(1));
        end
        
        
