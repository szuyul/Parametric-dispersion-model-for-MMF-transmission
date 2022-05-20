% Returns a vector with the average intensity per frame with size [frames 1]
%
% vm: Vectorized movie class
%
% 2016-2017 Vicente Parot
% Cohen Lab - Harvard University
%
function fr = frameAverage(obj)
    fr = mean(obj.tovec.data,1)';
end