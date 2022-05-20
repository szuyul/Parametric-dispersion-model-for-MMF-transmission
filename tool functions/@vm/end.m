% Last index in indexing expression
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function num = end(obj,k,n)
            % provides length of subindex domains
            switch n
                case 1 % one subindex - frames
                    num = obj.frames;
                case 2 % two subindices - vectorized matrix
                    num = size(obj.tovec.data,k);
                case 3 % three subindices - 3D matrix
                    num = size(obj.data,k);
                otherwise
                    error('vm:end','subscripted reference not supported')
            end
        end
