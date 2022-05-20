% Write 16 bit floating point raw data
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function savebinsingle(obj,fname)
            % save fata in binary float32 format
            if nargin > 1
                pname = '';
            else
                [fname, pname] = uiputfile('*.bin');
            end
            fullname = fullfile(pname,fname);
            tic
            fprintf('saving %s ...\n',fullname)
            fid = fopen(fullname,'w');
            fwrite(fid,single(obj.data),'float32');
            fclose(fid);
            disp(['saving took ' num2str(toc) ' s']);
        end
