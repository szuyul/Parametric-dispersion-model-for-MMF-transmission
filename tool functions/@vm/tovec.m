% Reshapes internal data representation to dimensions [rows*cols frames]
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = tovec(obj)
            % reshape movie data into vector format
            [r, c, f] = size(obj.data);
            size_rcf = [r, c, f];
            if isequal(size_rcf,[obj.rows obj.cols obj.frames])
                obj.data = reshape(obj.data,obj.rows*obj.cols,obj.frames);
            end
        end
