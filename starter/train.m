%% CS294A/CS294W Programming Assignment Starter Code

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  programming assignment. You will need to complete the code in sampleIMAGES.m,
%  sparseAutoencoderCost.m and computeNumericalGradient.m. 
%  For the purpose of completing the assignment, you do not need to
%  change the code in this file. 
%
%%======================================================================
%% STEP 0: Here we provide the relevant parameters values that will
%  allow your sparse autoencoder to get good filters; you do not need to 
%  change the parameters below.

visibleSize = 8*8;   % number of input units 
hiddenSize = 25;     % number of hidden units 
sparsityParam = 0.01;   % desired average activation of the hidden units.
                     % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		     %  in the lecture notes). 
lambda = 0.0001;     % weight decay parameter       
beta = 3;            % weight of sparsity penalty term       

%%======================================================================
%% STEP 1: Implement sampleIMAGES
%  随机采样出10000个小的patch，并且显示出其中的204个patch图像
%  After implementing sampleIMAGES, the display_network command should
%  display a random sample of 200 patches from the dataset

patches = sampleIMAGES;
display_network(patches(:,randi(size(patches,2),204,1)),8);
%randi函数在0到10000之间随机生成204*1的矩阵
%patches（）表示从64*10000个patches随机取出204个patches，也就是64*204的矩阵
%  Obtain random parameters theta
theta = initializeParameters(hiddenSize, visibleSize);

%%======================================================================
%% STEP 2: Implement sparseAutoencoderCost
%  进行损失函数的计算
%  You can implement all of the components (squared error cost, weight decay term,
%  sparsity penalty) in the cost function at once, but it may be easier to do 
%  it step-by-step and run gradient checking (see STEP 3) after each step.  We 
%  suggest implementing the sparseAutoencoderCost function using the following steps:
%  完成前向传播，实现损失函数的方误差项。实现反向传播来计算偏离项。然后运行梯度检查来证明
%  与方误差项对应的计算是否正确。（梯度检查在pdf第十页）
%  (a) Implement forward propagation in your neural network, and implement the 
%      squared error term of the cost function.  Implement backpropagation to 
%      compute the derivatives.   Then (using lambda=beta=0), run Gradient Checking 
%      to verify that the calculations corresponding to the squared error cost 
%      term are correct.
%  加入权值衰减项（在损失函数和偏离计算中），然后重新运行梯度检查来验证正确率
%  (b) Add in the weight decay term (in both the cost function and the derivative
%      calculations), then re-run Gradient Checking to verify correctness. 
%  加入稀疏惩罚项，然后重新运行梯度检查来验证正确性
%  (c) Add in the sparsity penalty term, then re-run Gradient Checking to 
%      verify correctness.
%
%  Feel free to change the training settings when debugging your
%  code.  (For example, reducing the training set size or 
%  number of hidden units may make your code run faster; and setting beta 
%  and/or lambda to zero may be helpful for debugging.)  However, in your 
%  final submission of the visualized weights, please use parameters we 
%  gave in Step 0 above.

[cost, grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, lambda, ...
                                     sparsityParam, beta, patches);
%cost = J + (beta * KL);是损失函数的总表达式。grad = [W1grad(:) ; W2grad(:) ; b1grad(:) ; b2grad(:)];
%%======================================================================
%% STEP 3: Gradient Checking
% 进行梯度函数的计算
% Hint: If you are debugging your code, performing gradient checking on smaller models 
% and smaller training sets (e.g., using only 10 training examples and 1-2 hidden 
% units) may speed things up.
%使用少一点的样本可以减少时间，增加速度。
% First, lets make sure your numerical gradient computation is correct for a
% simple function.  After you have implemented computeNumericalGradient.m,
% run the following: 
%%%%%%%checkNumericalGradient();%这段代码定义了一个简单的二次函数，计算梯度的偏离程度
% 
% % Now we can use it to check your cost function and derivative calculations
% % for the sparse autoencoder.  
%%%%% numgrad = computeNumericalGradient( @(x) sparseAutoencoderCost(x, visibleSize, ...
%%%%%                                                   hiddenSize, lambda, ...
%%%%%                                                   sparsityParam, beta, ...
%%%%%                                                   patches), theta);
%s = @(x) x-----定义了一个自变量为x、因变量为s的函数，函数表达式为 x，即定义的函数是 s=x。 
%numgrad为计算出的偏离率。
% % Use this to visually compare the gradients side by side
% disp([numgrad grad]); 
% 
% % Compare numerically computed gradients with the ones obtained from backpropagation
%%%% diff = norm(numgrad-grad)/norm(numgrad+grad);
%%%% disp(diff); % Should be small. In our implementation, these values are
            % usually less than 1e-9.

            % When you got this working, Congratulations!!! 

%%======================================================================
%% STEP 4: After verifying that your implementation of
%训练稀疏自编码
%  sparseAutoencoderCost is correct, You can start training your sparse
%  autoencoder with minFunc (L-BFGS).
%  接着用优化算法来求参数了，本程序给的是优化算法是L-BFGS。
%  Randomly initialize the parameters
theta = initializeParameters(hiddenSize, visibleSize);
%theta为包含矩阵权值和偏差项的矩阵
%  Use minFunc to minimize the function
addpath minFunc/  
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';


[opttheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   visibleSize, hiddenSize, ...
                                   lambda, sparsityParam, ...
                                   beta, patches), ...
                              theta, options);

%%======================================================================
%% STEP 5: Visualization 

W1 = reshape(opttheta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
display_network(W1', 12); 

print -djpeg weights.jpg   % save the visualization to a file 
%表示保存为jpeg图片，且文件名为weights.jpg

