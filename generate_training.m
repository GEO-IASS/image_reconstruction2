function generate_training( filename, filename_X_out, filename_y_out )


	%	Parse an image
%        I = imread( filename );
%		I = rgb2gray( I );		% Pixel values are unsigned ints
 %       I = uint8(I);
%        dlmwrite('sourceimage.txt', I);



        I = dlmread(filename);
        fprintf(1,'gentrain\n');
        %imshow(I);
        [m,n] = size(I);
		T = zeros(m,n);

		side = 10;			% Side is the height/width of the stencil
%{
		%num_threshold_values = 128;
		%interval_size = 256/num_threshold_values;
        interval_size =128; %int8(interval_size);
		

        for j=1:m
            for k=1:n
                
                tmp1 = bitshift( uint8( I(j,k) ) , -log2(interval_size) );
                %tmp2 = floor(tmp1);
                tmp3 = bitshift( tmp1 , log2(interval_size) );
                
                T(j,k) = tmp3;
                
            end
        end



       imshow(T);
        delete('thresholdmatrix.txt');
		dlmwrite('thresholdmatrix.txt', T, 'delimiter', '\t');	
				
	I = T;			
						
 %}   
    %printf('Image has size %d by %d', m, n);
	
	%if( m < 1 || n < 1 )
	%	printf('Error in image dimensions\n');
	%	exit;
	%end

	X = zeros((m-side)*(n-side),side*side+1);	% last column are intensity values ("labels")
	y = zeros((m-side)*(n-side),1);
	
	stencil = zeros(side,side);
	
	t = 1;
	
    %   Delete any previous data files
    delete(filename_X_out,filename_y_out);
    
	for row_st = 1:(m-side)
        	row_st;
		
		for col_st = 1:(n-side)
			%Create the square stencil
			for i = 1:side
				for j = 1:side
						stencil(i,j) = I(row_st+i-1,col_st+j-1);
				end
			end
			
			%Assign elements of stencil to appropriate data structures
			y(t,1) = stencil(1,1);
			k = 1;
			
			for j=2:side
				X(t,k) = stencil(1,j);
				k = k+1;
			end
			
			for i=2:side
				for j=1:side
					X(t,k) = stencil(i,j);
					k = k+1;
				end
			end
			
			X(t,k) = row_st;
			X(t,k+1) = col_st;
			
			%Increment the index of the training example
			t = t+1;
      		end
	end
	
	dlmwrite(filename_X_out, X, 'delimiter', '\t');
	dlmwrite(filename_y_out, y, 'delimiter', '\t');

end
