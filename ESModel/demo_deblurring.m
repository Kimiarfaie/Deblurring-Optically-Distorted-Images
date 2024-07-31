clc;
clear;
close all;
addpath(genpath('image'));
addpath(genpath('whyte_code'));
addpath(genpath('cho_code'));
opts.prescale = 1; %%downsampling, same as pmp
opts.xk_iter = 5; %% the iterations, same as pmp
opts.gamma_correct = 1.0; % same as pmp
opts.k_thresh = 20; % same as pmp
opts.theta = 1; % not in pmp

inputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/Distorted Images';
outputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/ESM/Deblurred Images';

% TID
aberrationCode = '08';
aberrationLevels = {'1','2', '3', '4', '5'};
numImages = 25;
%% Note:
%% lambda_tv, lambda_l0, weight_ring are non-necessary, they are not used in kernel estimation.
%%
opts.kernel_size = 10;
saturation = 0;
lambda_data = 4e-3; % 0.1 in pmp
lambda_grad = 4e-3; % same in pmp
opts.gamma_correct = 1;
lambda_tv = 0.002; %1e-3 in pmp
lambda_l0 = 2e-4; %1e-3 in pmp
%%
% Loop over each image, process it, and save the output
for i = numImages
   for j = 1:numel(aberrationLevels)
        % Construct the filename
        filename = sprintf('i%02d_%s_%s.png', i, aberrationCode, aberrationLevels{j});
        % filename = sprintf('final%02d_%s_%s.png', i, distortionType, levels{l});
        % Full path to the image file
        inputFile = fullfile(inputDir, filename);
        % Read the image
        disp(['========================== ',filename,' =========================='])

        y = imread(inputFile);
        if size(y,3)==3
            yg = im2double(rgb2gray(y));
        else
            yg = im2double(y);
        end
        tic;
        [kernel, interim_latent] = blind_deconv(yg, lambda_data, lambda_grad, opts);
        toc
   end
end
%% Algorithm is done!

y = im2double(y);
% Final Deblur: 
if ~saturation
    % 1. TV-L2 denoising method
    Latent = deconv_outlier(y, kernel, 5/255, 0.003); % From cho code
%   Latent = deconv_RL_sat(y,kernel); % From whyte code
else
    % 2. Whyte's deconvolution method (For saturated images)
     Latent = ringing_artifacts_removal(y, kernel, lambda_tv, lambda_l0, 1); % From pan 2014
%    Latent = whyte_deconv(y, kernel);
end
%
k = kernel - min(kernel(:));
k = k./max(k(:));
imwrite(Latent,'enhance.png');
imwrite(k,'enhance_kernel.png');

