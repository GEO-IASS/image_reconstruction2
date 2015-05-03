%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%COST FUNCTION FOR COLLABORATIVE FILTERING%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function J = Cost(X,THETA,Y,R,lam)

[n_m,n_u] = size(Y);
[garb,n] = size(X);

%Calculate the first term A

J = 0.5*norm((((X*THETA')-Y).*R),2)^2 + 0.5*lam*(norm(X,2)^2)+ 0.5*lam*(norm(THETA,2)^2);


end