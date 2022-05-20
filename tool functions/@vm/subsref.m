% Subscripted reference
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function varargout = subsref(obj,s)
            % maps array type indexing into the movie data
            switch s(1).type
                case '()'
                    switch numel(s(1).subs)
                        case 1 % one subindex - subsref frames, unless input is vm
                            if isa(s(1).subs{1},'vm')
                                s(1).subs{1} = logical(s(1).subs{1}.data);
                                s1obj = builtin('subsref',obj.data,s(1));
                            else
                                s(1).subs = [{':' ':'} s(1).subs];
                                s1obj = vm(builtin('subsref',obj.data,s(1)));
                            end
                            if ~isempty(s(2:end))
                                if numArgumentsFromSubscript(obj,s(2:end));
                                    varargout = {subsref(s1obj,s(2:end))};
                                else
                                    varargout = {};
                                    subsref(s1obj,s(2:end));
                                end
                            else
                                varargout = {s1obj};
                            end
                        case 2 % two subindices - subsref vectorized matrix
                            varargout = {builtin('subsref',obj.tovec.data,s(1))};
                        case 3 % three subindices - subsref all, return vm
                            s1obj = vm(builtin('subsref',obj.data,s(1)));
                            if ~isempty(s(2:end))
                                if numArgumentsFromSubscript(obj,s(2:end));
                                    varargout = {subsref(s1obj,s(2:end))};
                                else
                                    varargout = {};
                                    subsref(s1obj,s(2:end));
                                end
                            else
                                varargout = {s1obj};
                            end
                        otherwise
                            error('vm:subsref','subscripted reference not supported')
                    end
                otherwise
                    try
                        switch nargout
                            case 0
                                varargout = {};
                                builtin('subsref',obj,s)
                            otherwise
                                eval(['[' sprintf('v%d, ',1:nargout) '] = builtin(''subsref'',obj,s);'])
                                varargout = eval(['{' sprintf('v%d, ',1:nargout) '}']);
                        end
                    catch me
                        if strcmp(me.identifier,'MATLAB:maxlhs')
                            varargout = {};
                            try
                                builtin('subsref',obj,s);
                            catch this
                                if strcmp(this.identifier,'MATLAB:noSuchMethodOrField')
                                    rethrow(this)
        %                                 warning(this.message)
        %                                 fprintf('calling external %s ...\n',s(1).subs)
        %                                 fh = eval(sprintf('@%s',s(1).subs));
        %                                 fh(obj.data)
                                else
                                    rethrow(this)
                                end
                            end
                        elseif strcmp(me.identifier,'MATLAB:noSuchMethodOrField')
                            rethrow(me)
        %                         warning(me.message)
        %                         fprintf('calling external %s ...\n',s(1).subs)
        %                         fh = eval(sprintf('@%s',s(1).subs));
        %                         fh(obj.data)
                        else
                            rethrow(me)
                        end
                    end
            end
        end
