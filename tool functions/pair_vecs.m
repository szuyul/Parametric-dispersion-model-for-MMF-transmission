function [B, assignedrows] = pair_vecs(A, B)
% 
% input: 
% A, B are m-by-n matrices where n pairs of m-by-1 column vectors are to be sorted
% 
% output: 
% B is the m-by-n matrices whose m-by-1 column vectors are aligned with those in A
% assignedrows is a n-by-1 array assigning indices on the columns of B

costMat = 1 - abs(A'*B);
% sort the eigenvalues accordingly
[assignment, ~] = munkres(costMat);
[assignedrows, ~] = find(assignment);
B(:, assignedrows) = B;
B = B.*exp(-1i*angle(diag( A'*B ))).';

% uncomment for debugging
% complex_imgplot( A'*B )
end