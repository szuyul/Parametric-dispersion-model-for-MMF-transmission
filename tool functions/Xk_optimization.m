function [Xk, C_trace, loss, step] = Xk_optimization(Mn, Mo, w, Xk, max_iter, step)
%
%
%
%
%
%
%
%
%
n_dof = size(Xk,1);
dispersion_order = size(Xk,3);
n_f = numel(w);
c = 0.9; % adaptive step size grow/shrink ratio

tt = 1;
loss = 0;
X_j = zeros(n_dof, n_dof, n_f);
D_j = zeros(n_dof, n_dof, n_f);
fullgrad = zeros(n_dof, n_dof, n_f);
gradmean = zeros(n_dof, n_dof, dispersion_order);
C_temp = zeros(1, n_f);
Xk_temp = Xk;

ii = 1;
while (ii < max_iter) 
    % evaluate current loss
    for jj = 1:n_f
        X_j(:,:,jj) = X_from_Xk(Xk_temp, w(jj));
        D_j(:,:,jj) = expm(X_j(:,:,jj));
        
        C_temp(jj) = TM_correlation( Mn(:,:,jj), D_j(:,:,jj)*Mo );
    end
    loss_temp = sum(1-abs(C_temp).^2);
    
    % update Xk and metrics
    if (ii==1) || ( loss_temp <= loss(tt-1) )
        % calculate current gradient
        for jj = 1:n_f
            % regular Euclidean gradient of f(B), which is 1-C(Mn, B*M0)
            nablaB = -2*trace(Mn(:,:,jj)'*D_j(:,:,jj)*Mo)*Mn(:,:,jj)*Mo'; 
            
            % Proposition 4.1 in "Cheap orthogonal constraints in NN" by Lezcano-Casado et al.
            direction = 1/2*(D_j(:,:,jj)'*nablaB-nablaB'*D_j(:,:,jj)); 
            dexpA = expm(cat(1,cat(2,-X_j(:,:,jj),direction),cat(2,zeros(n_dof),-X_j(:,:,jj))));
            fullgrad(:,:,jj) = D_j(:,:,jj)*dexpA(1:n_dof,n_dof + (1:n_dof));
        end

        for order = 1:dispersion_order
            gradmean(:,:,order) = mean(fullgrad.*shiftdim(w.^order,-1),3);
        end
        
        fprintf('\nXk update %d, loss = %.8g, step = %.4g \n', tt, loss_temp, step)
        Xk = Xk_temp;
        C_trace(tt,:) = C_temp;
        loss(tt) = loss_temp;
        
        tt = tt + 1;
        step = step/c; % step grows
    else
        step = c*step; % step shrinks
    end
    
    % update Xk
    Xk_temp = Xk - step*gradmean;
    
    fprintf('iteration %d/%d, loss = %.8g, step = %.4g \n', ii, max_iter, loss(tt-1), step)
    ii = ii+1;
end    

end
