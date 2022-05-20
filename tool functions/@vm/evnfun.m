% Every-n function along 3rd dim
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = evnfun(obj,fun,n)
            % Apply function to {every n frames}
            obj = vm(reshape(fun(reshape(obj.toimg.data,obj.rows,obj.cols,n,obj.frames/n),4),obj.rows,obj.cols,n));
        end
