function D1 = D1_from_msTM(Mn)
% D1_from_msTM calculates the estimated D1 matrix from a msTM with constant spectral sampling rate 
% 
% output:
%   Mn is the input msTM
% 
% input: 
%   D1 is the estimated linear dispersion matrix
%

Nw = size(Mn,3);

temp1 = zeros(size(Mn,1), 'like', 1+1i);
temp2 = zeros(size(Mn,1), 'like', 1+1i);
for ll = 1:Nw-1
    temp1 = temp1 + Mn(:,:,ll+1)*Mn(:,:,ll)';
    temp2 = temp2 + Mn(:,:,ll)*Mn(:,:,ll)';
end
temp = temp1/temp2;
D1 = sqrtm(temp*temp')\temp;

end
