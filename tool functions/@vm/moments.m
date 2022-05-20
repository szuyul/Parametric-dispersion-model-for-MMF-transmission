% moments along 3rd dim
%
% vm: Vectorized movie class
%
% 2016-2018 Vicente Parot
% Cohen Lab - Harvard University
%
function obj = moments(obj)
    % Apply function to {blocks of length n frames}
    zax = permute(1:obj.frames,[1 3 2]);
    r0 = sum(obj.*zax.^0); % raw integral
    r1 = sum(obj.*zax.^1); % raw 1st moment
    c = r1./r0; % centroid, could have NaNs
    stdz = real(sum(obj.*(zax-c).^2)./r0);
    skz = sum(obj.*(zax-c).^3)./stdz.^3./r0;
    kurz = sum(obj.*(zax-c).^4)./stdz.^4./r0;
    obj = vm(cat(3,r0,c,stdz,skz,kurz));
end
