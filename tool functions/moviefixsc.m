function moviefixsc(varargin)
% Display movie with fixed scale intensity
% optionally input scale limits, then initially displayed frame
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
    varargin{1} = vm(varargin{1});
    moviefixsc(varargin{:});
end