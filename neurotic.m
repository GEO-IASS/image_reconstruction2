% Pass in original image

function neurotic( image_file )

A = imread( image_file );
A = double(A);
[m,n] = size(A);
meanofa = mean(A);

for i=1:m
    for j=1:n
        A(i,j) = A(i,j) / meanofa(j);
    end
end

A = rgb2gray(A);

imshow(A);
figure;
[m,n] = size(A)



dlmwrite( 'meanmodifiedimage.txt', A );

% Generate training examples based on the modified A

fprintf(1,'\nGenerating training examples\n');
generate_training( 'meanmodifiedimage.txt', 'meanmodifiedX.txt', 'meanmodifiedy.txt' );


% Training examples labels are stored in meanmodifiedX.txt, meanmodifiedy.txt
% Read them in for NN training

X = dlmread('meanmodifiedX.txt');
y = dlmread('meanmodifiedy.txt');


% Examples are in rows...
X = X';
y = y';



%{

fprintf(1,'\nTraining Neural Network\n');
% Train NN 

    % Define the neural net 
    net = feedforwardnet([2 2]);
    
    net.trainFcn = 'traingdx';
    % Other options for training functions
        %   trainrp (resilent backpropagation)
        %   trainbfgc (quasi-Newtpon backpropagation)
        
    net.performFcn = 'mse';
    %Other options for performance functions
        %   mae (Mean Absolute1 Error)
        %   mse (Mean Squared Error)


    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'logsig';
    net.layers{3}.transferFcn = 'logsig';
    % Other options for transfer functions
        %   tansig (tangent sigmoid)
        %   purelin (linear function)
        %   logsig (exponential sigmoid)
        
    [net,tr,Y,E,Pf,Af] = train( net, X, y );
    % Outputs are:
        % net: trained network
        % tr: training record (epoch & perf)
        % Y: network outputs
        % E: network errors
fprintf(1,'\nNeural Net trained\n');        
%}



% Save neural network
%save net;
load net;

%{
X = dlmread('meanmodifiedX.txt');
y = dlmread('meanmodifiedy.txt');
X = X';
y = y';
%}

% Generate testing examples on the broken image

    brokenH = 150;
    brokenW = 30;
    
    broken_x_width = 10;
    broken_y_width = 10;
    
    R = A;
    
    for i=brokenH:brokenH + broken_y_width
        for j=brokenW:brokenW + broken_x_width
            R(i,j) = 0;
        end
    end
   
    
    col_avg = ones(n);
    
    
   for i=1:n
    for j=1:m
        col_avg(i) = col_avg(i) + R(j,i);
    end
   end
   
   for i=1:n
       col_avg(i) = col_avg(i) / ( m - broken_y_width );
   end
   
   
for j=brokenW:brokenW + broken_x_width 
   for i=brokenH:brokenH + broken_y_width
            R(i,j) = col_avg(j);
            if( col_avg(j) == 0 )
                   j
            end
        end
end
    
    imshow(R);
    figure
    
    dlmwrite('brokenimage.txt', R);
    
    fprintf(1,'\nGenerating Broken Image testing set\n');
    generate_training( 'brokenimage.txt', 'brokenX.txt', 'brokeny.txt' );
    
    BX = dlmread('brokenX.txt');
    
    BX = BX';
    
    
    
% Pass broken image to trained NN 

    fprintf(1,'\nTesting on Neural Network\n');
    [BY,Pf,Af,E,perf] = sim( net, BX );
    % Outputs are:
        % BY: outputs of NN
        % Pf: Final input delay conditions (irrelevant...)
        % Af: Final layer delay conditions (irrel..)
        % E: Network errors
        % perf: network performance
    fprintf(1,'\nTesting Complete\n');
        
% Construct Neural Network Predicted Image


        fprintf(1,'\nReconstructing Image\n');
        
        
%        BX = BX';
        BY = BY';
        
        % Define side in neurotic.m AND generate_training.m
        side = 10;
        
        
        
        Y = reshape( BY, n, m );
        
%           for i=1:n
 %      col_avg(i) = col_avg(i) / ( m - broken_y_width );
  %         end        
  
        
  
        imshow(Y);

end   