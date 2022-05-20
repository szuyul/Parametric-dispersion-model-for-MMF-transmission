% ' Conjugate tranpose
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = ctranspose(obj)
            % complex conjugate and permutation of first two dims
            obj = conj(transpose(obj));
        end
