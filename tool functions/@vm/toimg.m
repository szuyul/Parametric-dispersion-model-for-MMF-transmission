% Reshapes internal data representation to dimensions [rows cols frames]
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = toimg(obj)
            % reshape movie data into image format
            if size(obj.data,1) ~= obj.rows
                obj.data = reshape(obj.data,obj.rows,obj.cols,[]);
            end
        end
