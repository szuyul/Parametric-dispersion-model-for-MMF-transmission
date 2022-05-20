% Image size of movie frames
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function sz = imsz(obj)
            % movie frames dimensions
            sz = [obj.rows obj.cols];
        end
