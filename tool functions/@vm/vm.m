classdef vm
% vm Vectorized Movie class
% The vectorized movie encapsulates a 3D dataset, provides read/write and
% display methods, and streamlines common movie operations. This class (in
% particular the moviesc method) is compatible with R2014b or later.
%
% 2016-2018 Vicente Parot
% Cohen Lab - Harvard University
%
% + - * / ^ .* ./ .^ ' .' Math and common functions are overloaded in the
% spirit of using the movie object as a regular variable. The design rule
% is that matrix operations are applied to the [nrows*ncols nframes]-
% dimension movie matrix, while scalar notation operations are bsxfun-ed 
% (i.e. operand dimensions can either match or be 1) and applied to the
% [nrows ncols nframes]-dimension 3D movie. Matrix operations between two
% vectorized movies are customarily defined for particular cases.
% 
% Array indexing for access and assignment is overloaded to provide access
% to movie subsets. This only works in the first level of indexing, and all
% other indexing behavior is meant to be preserved. a movie object can be
% indexed with 1, 2, or 3 subscripts. 1 subscript: indexes frames of the
% movie like vm(mov.data(:,:,frames)). 2 subscripts: indexes the vectorized
% matrix data in (rowcol, frames), like mov.tovec.data(rowcol,frames). 3
% subscripts: indexes the movie data in (columns, rows, frames).
% 
% How to use it: 
% 
%   %% create object from existing matrix, display, save movie for slides,
%   transpose and save binary file to open in ImageJ
%   mov = vm(my_3d_matrix)
%   mov.moviesc
%   mov.saveavi('A:\updates\for_presentation.avi')
%   mov.transpose.savebin('A:\analysis\processed_movie.bin')
%   
%   %% hadamard reconstruction
%   cal = vm('A:\calibration\') % assumes directory includes a binary
                                % file and format of the experimental
                                % parameters file for image dimensions
%   raw = vm('A:\experiment\Sq_camera.bin',512,512) % or, specify them
%   spots = raw*patterns
%   spots.moviesc
%   hadamard_img = cal*spots;
%   reference_img = raw.mean;
% 
%   %% note that matlab accepts multiple notations. if you prefer, you can
%   choose to use the good old syntax and avoid dots ... 
%   %% alternate notation for commands above
%   moviesc(spots)
%   reference_img = mean(raw);
% 
% More examples:  
%   %% normalize movie object mov by its time average
%   mov = mov./mov.mean
% If mov was instead a 3D matrix, the following command would have worked:
%   %% normalize 3D matrix movie mov by its time average
%   mov = bsxfun(@rdivide,mov,mean(mov,3));
% 
% Tired of the tedious handling of movies dimensions for linear algebra and
% image processing? Not anymore -- this class encapsulates a movie and its
% dimensions in order to perform routine tasks more intuitively.
% This class should cover all the tasks that one wants to apply to a movie.
% As an evolving project, this class needs to be expanded for common needs
% of different users (if any), and bugs need to be fixed. Methods will
% change in future versions. Please let me know at vparot at gmail dot com
% if you have suggestions for improvement. Updated at least on: 2017-04-08.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
% Copyright 2016-2018 Vicente Parot
% 
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:      
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.    
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.      
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
    properties (SetAccess = private)
        data    % array with movie values
        rows    % number of rows in all movie frames
        cols    % number of columns in all movie frames
        frames  % number of frames in the movie
    end
    properties (SetAccess = private, GetAccess = private)
        SortedFew % reduced number of movie values to sample its histogram
        DisplaySaturationFraction % fraction of the movie saturated for display
        SaturationLimits % calculated colormap limits considering the saturation fraction
        xscale % optional column coordinates of the movie
        yscale % optional row coordinates of the movie
    end
    methods
% constructor
        function obj = vm(varargin)
            % Creates a vectorized movie object
            % The argument can be 1) a movie stored in a matrix, with
            % syntax vm(m3d) or vm(m2d,[nrows ncols]), 2) folder name to
            % load a binary file optionally specifying frame indexes, 3)
            % file or folder information to read from, with any syntax that
            % works on the load_movie_uint function (bin, dcimg, tiff
            % folder), or 4) tiff file name, which requires the loadtiff
            % function.
            if ~isempty(varargin)
                if isnumeric(varargin{1}) || islogical(varargin{1})
                    if nargin > 1
                        obj.data = reshape(varargin{1},varargin{2}(1),varargin{2}(2),[]);
                    else
                        obj.data = varargin{1};
                    end
                    obj.rows = size(obj.data,1);
                    obj.cols = size(obj.data,2);
                else
                    % if isdir, look for bin in that dir, in that case try
                    % to find the dims and open the bin
                    if isdir(varargin{1})
                        expfile = fullfile(varargin{1},'experimental_parameters.txt');
                        binfile = fullfile(varargin{1},'Sq_camera.bin');
                        expfile2 = fullfile(varargin{1},'camera-parameters-Flash.txt');
                        binfile2 = fullfile(varargin{1},'frame.bin');
                        if exist(expfile,'file') && exist(binfile,'file')
                            numcell = strsplit(fileread(expfile),'[\D]','DelimiterType','RegularExpression');
                            obj.rows = str2double(numcell{3});
                            obj.cols = str2double(numcell{2});
                            if nargin > 1
                                % also pass frame indices to read only those
                                [obj.data] = load_movie_uint(binfile,varargin{2},obj.rows,obj.cols);
                            else
                                [obj.data] = load_movie_uint(binfile,obj.rows,obj.cols);
                            end
                            obj.data = reshape(obj.data, obj.rows, obj.cols,[]);
                        elseif exist(expfile2,'file') && exist(binfile2,'file')
                            numcell = strsplit(fileread(expfile2),'[\D]','DelimiterType','RegularExpression');
                            obj.rows = str2double(numcell{11});
                            obj.cols = str2double(numcell{10});
                            if nargin > 1
                                % also pass frame indices to read only those
                                [obj.data] = load_movie_uint(binfile2,varargin{2},obj.rows,obj.cols);
                            else
                                [obj.data] = load_movie_uint(binfile2,obj.rows,obj.cols);
                            end
                            obj.data = reshape(obj.data, obj.rows, obj.cols,[]);
                        else % if no bin file in dir, pass on to load_movie
                            [obj.data, obj.rows, obj.cols] = load_movie_uint(varargin{:});
                            obj.data = reshape(obj.data, obj.rows, obj.cols,[]);
                        end
                    % elseif istif, load that tif specifically as a stack
                    elseif strcmp(varargin{1}(end-3:end),'.tif')
                        tic
                        disp 'reading tif file ...'
                        obj = vm(loadtiff(varargin{1}));
                        disp(['reading took ' num2str(toc) ' s']);
                    else
                        [obj.data, obj.rows, obj.cols] = load_movie_uint(varargin{:});
                        obj.data = reshape(obj.data, obj.rows, obj.cols,[]);
                    end
                end
            else
                [~, bname] = uigetfile('X:\Lab\Labmembers\Vicente Parot\Data\*.bin');
                obj = vm(bname);
            end
            obj.frames = (obj.rows|obj.cols)*size(obj.data,3); % sets frames to zero is image dimensions are [0 0]
            obj.DisplaySaturationFraction = 1e-3; % default saturation
            obj.xscale = [];
            obj.yscale = [];
        end
% class fundamentals        
        n = numArgumentsFromSubscript(obj,s,~) % Number of arguments for indexing methods
        num = end(obj,k,n) % Last index in indexing expression
        varargout = subsref(obj,s) % Subscripted reference
        obj = subsasgn(obj,s,b) % Subscripted assignment
        varargout = size(obj,varargin) % Size of movie
        newobj = horzcat(varargin) % Horizontal concatenation
        newobj = vertcat(varargin) % Vertical concatenation
        newobj = framecat(varargin) % Concatenation along 3rd dimension
        newobj = cat(dim,varargin) % Concatenation along any dimension
        sz = imsz(obj) % Image size of movie frames
% class utils        
        obj = setDisplaySaturationFraction(obj,sat) % Sets the fraction of intensity values to be saturated for display
        tr = totaltrace(obj) % Returns a vector with the sum intensity per frame with size [1 1 frames]
        tr = frameAverage(obj) % Returns a vector with the average intensity per frame with size [frames 1]
        obj = setScale(obj,xscale,yscale) % Sets scales alond row and column dimensions
        obj = setSaturationLimits(obj,lim) % Sets the colormap limits for display
        img = frame(obj,fr) % Extract the image data of a single frame
        obj = toimg(obj) % Not recomended. Reshapes internal data representation to dimensions [rows cols frames]
        % by convention, internal data is kept in image format unless
        % specified otherwise
        obj = tovec(obj) % Not recomended. Reshapes internal data representation to dimensions [rows*cols frames]
        % tovec has been replaced by the movie indexing syntax mov(:,:)
        % which returns the internal data in 2D matrix format
% display        
        moviesc(obj,fr,scalingmode) % Display movie with scaled intensity
        moviefixsc(obj,lim,fr) % Display movie with fixed scale intensity
        movielogsc(obj,lim,fr) % Display movie with Log scale intensity
% save
        savebin(obj,fname) % Write 32 bit floating point raw data
        savebinsingle(obj,fname) % Write 16 bit floating point raw data
        savemat(obj,fname) % Write a matlab file with the movie data in a variable
        saveavi(obj,fname) % Write a compressed movie file
        savetiffstack(obj,fname) % Write a tiff stack using saveastiff
% movie ops
        obj = moments(obj) % Moments along 3rd dim
        obj = blnfun(obj,fun,n) % Block-n function along 3rd dim
        obj = evnfun(obj,fun,n) % Every-n function along 3rd dim
        obj = trim(obj) % Remove constant borders from movie
        obj = crop(obj,poly) % Crops movie to a smaller polygon ROI
        obj = crop_rect(obj,rect) % Crops movie to a smaller rectangular ROI
        obj = crop_soft(obj,poly) % Crops movie to a smaller polygon ROI and sets smooth borders
        quick_play(obj) % Plays a movie as fast as possible in a new figure
% image ops
        [trace, weightimg, offsetimg] = extract_single_component(obj) % Custom extract algorithm
        varargout = correct_motion(obj,dxy) % Custom motion correction algorithm
        dxy = estimate_displacement(m) % Custom motion correction
        obj = apply_displacement(obj,dxy) % Independent xy translation applied to each frame by phase shifting
        obj = imscale(obj,sat) % Scale intensity values to 0-1 range
        varargout = gradient(obj) % Approximate gradient
        obj = medfilt2(obj,varargin) % Median filter each frame
        obj = imresize(obj,varargin) % Resize the frame size of the movie
        obj = permute(obj,varargin) % Permute movie dimensions
        obj = blur(obj,sigma) % Gaussian blur performed with imfilter
        obj = imfilter(obj,varargin) % Wrapper for imfilter
        obj = ffzpad(obj,ts) % FFT friendly zero pad or crop
        obj = fft(obj) % Two-dimensional discrete Fourier Transform in each frame
        obj = ifft(obj) % Two-dimensional inverse discrete Fourier Transform in each frame
        obj = fftshift(obj) % Shift zero-frequency component to center of spectrum along dims 1 and 2 
        obj = ifftshift(obj) % Inverse FFT shift along dims 1 and 2 
%         [obj, scaleImgs] = SeeResiduals(obj,varargin) % SeeResiduals on movie
% clickyies % no special clicky methods, these external clickies support vm.
%         [roi_points, intens] = clicky_faster(obj, refimg)
%         intens = apply_clicky_faster(obj, roi, disp_img, every_n)
%         [roi_points, intens] = clicky_rects(obj, refimg, separatefigures)
%         [roi_points, intens] = nested_clicky_rects(obj, refimg)
%         [roi_points, intens] = extract_clicky_rects(obj, refimg, separatefigures)
% specials
        obj = correct_blank_marker(obj) % Removes central row left artifact present in raw data from Hamamatsu Orca Flash 4 V2 cameras
        obj = pblc(obj,skip,stop) % Removes photobleaching dividing by a fitted exponential
        img = montage(obj,idxs) % Creates montage of specified movie frames
% math
        obj = transpose(obj) % .' Non conjugate tranpose, permutes dims 1 and 2
        obj = ctranspose(obj) % ' Conjugate tranpose
        trans = mldivide(obj1,obj2) % Solve linear system of projection along frame dimension
        % ldivide % undefined
        obj = mrdivide(obj,denom_img) % / Interpreted as right array divide
        obj = rdivide(oi1,oi2) % ./ Right array divide
        obj = mtimes(obj,objmat) % * Special matrix multiplication
        obj = times(oi1,oi2) % .* Times
        obj = plus(oi1,oi2) % + Plus
        obj = minus(oi1,oi2) % - Minus
        obj = uminus(oi1) % - Unary minus
        obj = uplus(oi1) % + Unary plus
        obj = any(obj) % any
        obj = all(obj) % all
        obj = not(obj) % ~ Not
        obj = eq(obj,ex) % == Equal
        obj = ne(obj,ex) % ~= Not equal
        obj = lt(obj,ex) % < Less than 
        obj = gt(obj,ex) % > Greater than
        obj = le(obj,ex) % <= Less or equal than 
        obj = ge(obj,ex) % >= Greater or equal than
        obj = power(obj,ex) % .^ Element wise power
        obj = mpower(obj,ex) % ^ Also element wise power
        objdata = double(obj) % Return movie data as a double array
        objdata = single(obj) % Return movie data as a single array
        objdata = uint16(obj) % Return movie data as a uint16 array
        img = mean(obj) % Mean along frame dimension
        img = sum(obj) % Sum along frame dimension
        img = min(obj) % Minimum intensity projection
        img = max(obj) % Maximum intensity projection
        img = std(obj) % Std along frame dimension
        img = var(obj) % Var along frame dimension
        img = median(obj) % Median along frame dimension, excluding NaNs
        img = prctile(obj,p) % Prctile along frame dimension
        img = nanmean(obj) % Mean along frame dimension, excluding NaNs
        img = nansum(obj) % Sum along frame dimension, excluding NaNs
        img = nanstd(obj) % Std along frame dimension, excluding NaNs
        img = nanvar(obj) % Var along frame dimension, excluding NaNs
        img = nanmedian(obj) % Mean along frame dimension, excluding NaNs
        obj = abs(obj) % Absolute value
        obj = angle(obj) % Angle of complex value
        obj = conj(obj) % Complex conjugate
        obj = real(obj) % Real part
        obj = imag(obj) % Imaginary part
        obj = sign(obj) % Sign
    end % methods
end % classdef
