#include <iostream>
#include "CImg.h"

using namespace std;
using namespace cimg_library;

int main(int argc, char* argv[])
{
	if(argc < 2)
	{
		cout << "Please specify input image (jpeg)" << endl;
		exit(EXIT_FAILURE);
	}

	CImg<double> image;
	image.load_jpeg(argv[1]);
	
	CImg<double> grey(image.width(),image.height() , 1,1,0);
	CImg<double> output_image(image.width() , image.height() , 1 , 1 ,0);
	CImg<double> missing(image.width() , image.height() , 1 , 1 ,0);
	
	//Convert to grayscale
	for(int j=0;j<image.width();j++)
	{
		for(int i=0;i<image.height();i++)
		{
		grey(j,i,0,0)=0.299*image(j,i,0,0)+0.587*image(j,i,0,1)+0.114*image(j,i,0,2);
		output_image(j,i,0,0) = grey(j,i,0,0);
		missing(j,i,0,0) = grey(j,i,0,0);
		}
	}
	
	//The original image
	CImgDisplay dark_disp(grey , "Original" , 0);	
	
	//The limits of the missing region
	int x1 = 200;
	int x2 = 230;
	int y1 = 90;
	int y2 = 120;
	
	//Blank out this portion of the image to simulate the "MISSING DATA"	
	for(int i = y1 ; i <= y2 ; i++)
	{
		for(int j = x1 ; j <=x2 ; j++)
		{
			grey(j,i,0,0) = 0.0;
			missing(j,i,0,0) = 0.0;
		}
	}	
	
	//Compute row average
	double* r = (double *)malloc(image.height() * sizeof(double));
	for(int i = 0 ; i <image.height() ; i++)
	{
		double sum = 0.0;
		for(int j = 0 ; j < image.width() ; j++)
		{
			 sum = sum + grey(j,i,0,0);
		}
	
		r[i] = sum/((double)image.width() - (x2 - x1 + 1));
	}
	
	//Compute collumn average
	double *c = (double *)malloc(image.width() * sizeof(double));
	for(int j = 0 ; j < image.width() ; j++)
	{
		double sum = 0;
		for(int i = 0 ; i < image.height() ; i++)
		{
			sum = sum + grey(j,i,0,0);
		}
		c[j] = sum/((double)image.height() - (y2 - y1 + 1));
	}
	
	
	//Replace the missing regions with the column averages	
	for(int i = y1 ; i <= y2 ; i++)
	{
		for(int j = x1 ; j <=x2 ; j++)
		{
			grey(j,i,0,0) = c[j];
		}
	}
	
	CImgDisplay  column_replaced(grey,"Column Replaced",0);
	
	//CImgDisplay col_disp(grey , "Cols subtracted",0);
		
	//Subtract the corresponding row averages from the matrix
	for(int i = 0 ; i < image.height() ; i++)
	{
		for(int j = 0 ; j < image.width() ; j++)
		{
			grey(j,i,0,0) = grey(j,i,0,0) - r[i];
		}
	}
	
	//Start iterations
	CImg<double> Pred;
	//Compute the SVD
	CImgList<double> USV = grey.get_SVD();

	//Fill in the values into the matrix
	int k = 120;
	CImg<double> S(k,k,1,1,0);
	CImg<double> U(k,image.height(),1,1,0);
	CImg<double> V(image.width(),k,1,1,0);
	for(int i = 0 ; i < k ; i++)
	{
		S(i,i,0,0) = USV[1](0,i,0,0);
	}

	for(int i = 0 ; i < image.height() ; i++)
	{
		for(int j = 0 ; j < k ; j++)
		{
			U(j,i,0,0) = USV[0](j,i,0,0);
		}
	}


	for(int i = 0 ; i < k ; i++)
	{
		for(int j = 0 ; j < image.width() ; j++)
		{
			U(j,i,0,0) = USV[2](j,i,0,0);
		}
	}	

	Pred = U * (S.transpose()).sqrt() * S.sqrt() * V;

	//Fill in the missing portion of the output image with the predicted image
	for(int i = y1 ; i <= y2 ; i++)
	{
		for(int j = x1 ; j <=x2 ; j++)
		{
			grey(j,i,0,0) = Pred(j,i,0,0);
		}
	}

	
	//Add the row averages to the predicted matrix
	for(int i = 0 ; i < image.height() ; i++)
	{
		for(int j = 0 ; j < image.width() ; j++)
		{
			Pred(j,i,0,0) = Pred(j,i,0,0) + r[i];
			grey(j,i,0,0) = grey(j,i,0,0) + r[i];
		}
	}	
	
	CImgDisplay broken(missing,"Broken Image",0);
	CImgDisplay pred(grey,"Predicted",0);
	
	while(!dark_disp.is_closed())
	{	
		dark_disp.wait();
	}
	
	return 0;
}
