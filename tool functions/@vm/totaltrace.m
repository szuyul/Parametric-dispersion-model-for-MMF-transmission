% Returns a vector with the sum intensity per frame with size [1 1 frames]
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function tr = totaltrace(obj)
            % total intensity of movie per frame
            tr = sum(sum(obj.toimg.data,1),2);
        end
