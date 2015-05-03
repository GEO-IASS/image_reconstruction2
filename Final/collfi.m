%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%Collaborative filtering code%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%Read in an image
I = imread('A1.jpg');
I = ind2gray(I,gray(255));

%I = im2bw(I,0.5);

I = double(I);

%Take a small chunk of the image
Y = I;%(50:100,100:150);

mu = mean(mean(Y));
Y = Y - mu;

%Create the matrix R
[n_m,n_u] = size(Y);
R = ones(n_m,n_u);
F = ones(n_m,n_u);
%Block out a piece of this matrix R
R(50:60,60:70) = 0;

%Create the matrices X and THETA
n = 15; %Number of features
lam = 0.5; %Regularization parameter
alpha = 0.00001; %Learning rate
X = randn(n_m,n);
THETA = randn(n_u,n);

%Start the iteration
J = Cost(X,THETA,Y,R,lam);
iter = 0
while iter < 5000
    
    iter = iter + 1;
    for i = 1:n_m
        for k = 1:n
            sum = 0;
            for j = 1:n_u
                sum = sum + (((THETA(j,:) * X(i,:)' - Y(i,j))*THETA(j,k)) + lam * X(i,k))*R(i,j);
            end
            X(i,k) = X(i,k) - alpha * sum;
        end
    end
    
    for j = 1:n_u
        for k = 1:n
            sum = 0;
            for i = 1:n_m
                sum = sum + (((THETA(j,:) * X(i,:)' - Y(i,j))*X(i,k)) + lam * THETA(j,k))*R(i,j);
            end
            THETA(j,k) = THETA(j,k) - alpha * sum;
        end
    end
    
    J = Cost(X,THETA,Y,R,lam)
    F = (X*THETA')+mu;
    if mod(iter,200) == 0
        alpha = alpha*10;
    end
    
        
    if mod(iter,50) == 0
        Z = Z + mu;
        A = Z;
        B = Z;
        A(50:60,60:70) = F(50:60,60:70);

        for j = 1:n_u
            A(1,j) = 0;
            A(n_m,j) = 0;
        end

        for i = 1:n_m
            A(i,1) = 0;
            A(i,n_u) = 0;
        end

        B(50:60,60:70) = 0;
        for j = 1:n_u
            B(1,j) = 0;
            B(n_m,j) = 0;
        end

        for i = 1:n_m
            B(i,1) = 0;
            B(i,n_u) = 0;
        end
        Predicted = I;
        Predicted(50:60,60:70) = A(50:60,60:70);
        BoundingBox = I;
        BoundingBox(50:60,60:70) = B(50:60,60:70);

        dlmwrite('Predicted.txt',Predicted,'delimiter','\t');
        dlmwrite('BoundingBox.txt',BoundingBox,'delimiter','\t');
    end
    alpha
    iter 
end
F = (X*THETA')+mu;
Y = Y + mu;
A = Y;
B = Y;
A(50:60,60:70) = F(50:60,60:70);

for j = 1:n_u
    A(1,j) = 0;
    A(n_m,j) = 0;
end

for i = 1:n_m
    A(i,1) = 0;
    A(i,n_u) = 0;
end

B(50:60,60:70) = 0;
for j = 1:n_u
    B(1,j) = 0;
    B(n_m,j) = 0;
end

for i = 1:n_m
    B(i,1) = 0;
    B(i,n_u) = 0;
end
Predicted = I;
Predicted(50:60,60:70) = A(50:60,60:70);
BoundingBox = I;
BoundingBox(50:60,60:70) = B(50:60,60:70);

dlmwrite('Predicted.txt',Predicted,'delimiter','\t');
dlmwrite('BoundingBox.txt',BoundingBox,'delimiter','\t');




