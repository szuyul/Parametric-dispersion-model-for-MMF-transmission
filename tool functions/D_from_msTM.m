function D = D_from_msTM(Mn)
% D_from_msTM calculates the D matrix from a msTM with constant spectral sampling rate 
% 
% output:
%   Mn is the input msTM
% 
% input: 
%   D is the linear dispersion matrix
%

n_f = size(Mn,3);

temp1 = zeros(size(Mn,1), 'like', 1+1i);
temp2 = zeros(size(Mn,1), 'like', 1+1i);
for ll = 1:n_f-1
    temp1 = temp1 + Mn(:,:,ll+1)*Mn(:,:,ll)';
    temp2 = temp2 + Mn(:,:,ll)*Mn(:,:,ll)';
end
temp = temp1/temp2;

D = sqrtm(temp*temp')\temp; % force D to be unitary

end
