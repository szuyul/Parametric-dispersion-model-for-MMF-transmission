% Subscripted assignment
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function obj = subsasgn(obj,s,b)
            % maps array type assignment into the movie data
            switch s(1).type
                case '()'
                    switch numel(s(1).subs)
                        case 1 % one subindex - frames, unless is of class vm
                            if isa(s(1).subs{1},'vm')
%                                 idxs = logical(s(1).subs{1}.data);
%                                 auxdata = obj.data;
%                                 auxdata(idxs) = b;
%                                 obj = vm(auxdata);
                                s(1).subs{1} = logical(s(1).subs{1}.data);
                                obj = vm(builtin('subsasgn',obj.data,s(1),b));
                            else
                                s(1).subs = [{':' ':'} s(1).subs];
                                obj = vm(builtin('subsasgn',obj.data,s(1),b));
                            end
                        case 2 % two subindices - vectorized matrix
                            obj = vm(builtin('subsasgn',obj.tovec.data,s(1),b),obj.imsz);
                        case 3 % three subindices - 3D matrix
                            obj = vm(builtin('subsasgn',obj.data,s(1),b));
                        otherwise
                            error('vm:subsasgn','subscripted reference not supported')
                    end
                otherwise
                    error('vm:subsasgn','subscripted reference not supported')
            end
        end
