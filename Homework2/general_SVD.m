function e = general_SVD(A, d, index_truncated)
[U, D, V] = svd(A);
switch index_truncated
    case 'standard'
        % do standard SVD
        D_inv = 1./D'; 
        D_inv(D_inv == Inf) = 0; 
        e = V*D_inv*U'*d;
    otherwise
        % do truncated SVD
        % only use the (index_truncated)-largest singular values in D
        D_inv = 1./D; 
        D_inv(D_inv == Inf) = 0; 
        D_inv(index_truncated+1:end, index_truncated+1:end) = 0;
        e = (V*D_inv'*U')*d;
end