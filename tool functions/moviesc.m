function moviesc(varargin)
% Display movie with scaled intensity
% optionally input the initially displayed frame, defaults to 1
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
    varargin{1} = vm(varargin{1});
    moviesc(varargin{:});
end