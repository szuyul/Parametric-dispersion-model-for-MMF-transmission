% FFT friendly zero pad or crop
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ffzpad(obj,ts)
            % resize canvas to centered target size ts = [rows cols]
            m = obj.data;
            m = permute(ffzpadrows(m,ts(1)),[2 1 3:ndims(m)]);
            m = permute(ffzpadrows(m,ts(2)),[2 1 3:ndims(m)]);
            obj = vm(m);
            function m = ffzpadrows(m,rows)
                [sr, sc, sf] = size(m);
                dr = rows - sr;
                if dr < 0
                    m = m(1-floor(dr/2):end+ceil(dr/2),:,:);
                elseif dr > 0
                    m = [zeros(ceil(dr/2),sc,sf); m; zeros(floor(dr/2),sc,sf)];
                end    
            end
        end
