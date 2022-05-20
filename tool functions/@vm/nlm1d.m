function out1d = nlm1d(in1d,hdom,sigma)
% Non local means 1d filter with default domain 4 and default sigma 3
% A neighborhood of 2*hdom+1 (default 9) samples is analyzed.
%
% 2016 Vicente Parot
% Cohen Lab - Harvard University
%
if ~exist('hdom','var')
    hdom = 4;
end
if ~exist('sigma','var')
    sigma = 3;
end
npts = size(in1d,1);
n1ds = size(in1d,2);
numels = npts*n1ds;
out1d = zeros(size(in1d));
[~,s] = memory;
assert(s.PhysicalMemory.Available > 10*npts^2,'low memory')
if npts > 2e4
    warning 'non local means 1d: vector lengths over 1e4 may be too slow to compute'
end
mlt = tls;
for it = 1:n1ds
    ip = 1:npts;
    fw = zeros(npts);
    ppo = reshape(in1d(min(end,max(1,bsxfun(@plus,ip',(-hdom:hdom)))),it),npts,hdom*2+1);
    ppom = mean(ppo,2);
    ppos = std(ppo,[],2);
    pp = bsxfun(@rdivide,bsxfun(@minus,ppo,ppom),ppos);
    for iq = 1:npts;
        pq = in1d(min(end,max(1,iq+(-hdom:hdom))),1)';
        pq = (pq-mean(pq))/std(pq);
    %     fw(:,iq) = 1./(mean(bsxfun(@minus,pp,pq).^2,2)+10);
        fw(:,iq) = exp(-mean((bsxfun(@minus,pp,pq)/sigma).^2,2));
        tlp(((it-1)*npts+iq)/numels,mlt);
    end
    out1d(:,it) = fw*pp(:,hdom+1)./sum(fw,2).*ppos+ppom;
end
tle(mlt);
