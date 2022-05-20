function [corr, ang] = TM_correlation(A, B)
% function TM_correlation computes the normalized correlation between A and B
% 
% input:
% A and B are 2D complex matrices
% 
% output:
% corr is the amplitude of the correaltion
% ang is the phase offset between A and B

temp = tovec(A)'*tovec(B)/(norm(tovec(A),'fro')*norm(tovec(B),'fro'));
corr = abs( temp );
ang = angle( temp );
end

