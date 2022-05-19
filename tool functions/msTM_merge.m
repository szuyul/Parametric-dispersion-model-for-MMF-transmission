function [M, w] = msTM_merge(M1, M2, w1, w2)
% function msTM_merge.m merges two multispectral TMs with sorted order based on
% descending frequencies
% 
% input:
% M1 and M2 are 3D multispectral TM with the 3rd dim as the spectral dim
% w1, and w2 are 1D arrays of frequencies of TMs
% 
% output:
% M is a sorted 3D multispectral TM after merging
% w is a 1D array with sorted frequencies

M = cat(3, M1, M2);
w = cat(2, w1, w2);

[w, I] = sort(w, 'descend');
M = M(:,:, I);

end

