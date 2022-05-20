% Number of arguments for indexing methods
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function n = numArgumentsFromSubscript(obj,s,~)
            % calculates subsref varargout dimension
            switch s(end).type
                case '.'
                    try
%                         n = builtin('numArgumentsFromSubscript',obj,s,matlab.mixin.util.IndexingContext.Statement);
                        n = abs(nargout(['vm>vm.' s(end).subs]));
                    catch
                        n = 1;
%                         n = builtin('numArgumentsFromSubscript',obj,s,matlab.mixin.util.IndexingContext.Statement);
                    end
                case '()'
                    if numel(s) == 1
                        n = 1;
                    else
                        if isa(obj,'vm')
                            n = 1;
                        else
                            n = builtin('numArgumentsFromSubscript',obj,s,matlab.mixin.util.IndexingContext.Statement);
                        end
                    end
                otherwise
                    n = length(s(1).subs{:});
            end
        end
