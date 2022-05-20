% Write 32 bit floating point raw data
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function savebin(obj,fname)
            % save data in binary uint16 format
            if nargin > 1
                pname = '';
            else
                [fname, pname] = uiputfile('*.bin');
            end
            fullname = fullfile(pname,fname);
            tic
            fprintf('saving %s ...\n',fullname)
            fid = fopen(fullname,'w');
            fwrite(fid,uint16(obj.data),'uint16');
            fclose(fid);
            disp(['saving took ' num2str(toc) ' s']);
        end
