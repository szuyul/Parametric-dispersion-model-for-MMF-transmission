% Removes central row left artifact present in raw data from Hamamatsu Orca Flash 4 V2 cameras
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = correct_blank_marker(obj)
            % replace the sneaky little line in some Hamamatsu datasets by
            % the average of its neighbors.
            crow = ceil(obj.rows/2);
            obj.data(crow,1:4,:) = ...
                (obj.data(crow+1,1:4,:) + ...
                obj.data(crow-1,1:4,:))/2;
        end
