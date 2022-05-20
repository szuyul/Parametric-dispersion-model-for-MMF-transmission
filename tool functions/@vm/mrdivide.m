% / Interpreted as linear system solution
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = mrdivide(obj,denom_traces)
%             obj.data = bsxfun(@rdivide,double(obj.data),denom_img);
            obj = vm(obj.tovec.data/denom_traces,obj.imsz);
        end
