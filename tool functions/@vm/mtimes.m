% * Special matrix multiplication
% Movie object multiplied by numeric matrix operates as a matrix
% multiplication in the vectorized movie representation. Movie object
% multiplied by Movie object calculates the covariance matrix between
% frames in each movie.
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function newobj = mtimes(obj,objmat)
            if isequal(class(objmat),'vm')
                % special matrix operation between movies
                % covm = vm' * vm
                % return as [nf nf]-sized matrix
                newobj = double(obj.tovec.data.')*double(objmat.tovec.data);
            else
                % vm2 = vm1 * traces
                % matrix multiplication
                % return as image matrix
                objdata = toimg(double(obj.tovec.data)*objmat,obj.rows,obj.cols);
                newobj = vm(objdata);
            end
        end
