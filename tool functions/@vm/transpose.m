% .' Non conjugate tranpose, permutes dims 1 and 2
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = transpose(obj)
            % permutes first two dimensions
            obj.data = permute(obj.toimg.data,[2 1 3]);
            [obj.rows, obj.cols, obj.frames] = size(obj.data);            
        end
