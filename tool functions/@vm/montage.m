% Creates montage of specified movie frames
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
        function img = montage(obj,idxs)
            % return a matrix arrangement of selected frame indices
            % mov.montage([2 3; 5 7]) returns frame 2 next to frame 3
            % stacked over 5 and 7, all in one matrix.
            img = [];
            for col = 1:size(idxs,2)
                colstrip = [];
                for row = 1:size(idxs,1)
                    colstrip = [colstrip; obj.data(:,:,idxs(row,col))]; %#ok<AGROW>
                end
                img = [img colstrip]; %#ok<AGROW>
            end
        end
