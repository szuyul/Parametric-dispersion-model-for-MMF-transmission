% Write a tiff stack using saveastiff
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function savetiffstack(obj,fname)
            % save multipage tiffs that imagej can read in float32 format
            if nargin > 1
                pname = '';
            else
                [fname, pname] = uiputfile('*.bin');
            end
            fullname = fullfile(pname,fname);
            tic
            fprintf('saving %s ...\n',fullname)
            if isa(obj.data,'double')
                obj.data = single(obj.data);
            end
            clear opts
            opts.overwrite = true;
            saveastiff(obj.data,fullname,opts);
            disp(['saving took ' num2str(toc) ' s']);
        end
