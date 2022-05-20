% Scale intensity values to 0-1 range
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = imscale(obj,sat)
            obj = vm(max(0,min(1,bsxfun(@rdivide,obj.tovec.data,prctile(obj.tovec.data,100*(1-sat))))),[obj.rows obj.cols]);
        end
