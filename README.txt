README

neurotic.m:
	neurotic.m is the driver file for neural network training. It should be called from the matlab prompt rather than being run from the editor.
	It takes as an input, an image file, preprocesses it, uses the generate_training function to create a set of training examples
	and trains a NN based on those examples. With respect to the network, many attributes of it can be changed in the code (heavily commented) - training fcn, learning fcn, number of hidden layers, cost function (MSE, SSE).

generate_training.m
	generate_training.m takes an image and generates a set of training examples using a stencil of size side by side. It takes the uppermost left pixel in the stencil to be the y value and the remaining to be features. It additionally encodes the x and y position of the pixel as features in the training example.
