% Write a matlab file with the movie data in a variable
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function savemat(obj,fname)
            % save to variable data in mat file
            if nargin > 1
                pname = '';
            else
                [fname, pname] = uiputfile('*.mat');
            end
            fullname = fullfile(pname,fname);
            tic
            fprintf('saving %s ...\n',fullname)
            movie_data = obj.data; 
            save(fullname,'movie_data','-v7.3')
            disp(['saving took ' num2str(toc) ' s']);
        end
