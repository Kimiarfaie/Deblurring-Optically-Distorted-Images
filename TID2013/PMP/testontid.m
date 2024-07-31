clear; close all; clc;

addpath(genpath('cho_code'));
inputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/Distorted Images';
outputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/PMP/Deblurred Images/NewKernelSizes/110';

% TID
aberrationCode = '08';
aberrationLevels = {'1','2', '3', '4', '5'};
numImages = 25;

% kernel_sizes = [25, 35, 45, 55, 65];
kernel_sizes = 110;

opts.prescale = 1; % downsampling
opts.xk_iter = 5;  % the iterations
opts.k_thresh = 20;
opts.gamma_correct = 1.0;

% Loop over each image, process it, and save the output
for i = numImages
   for j = 1:numel(aberrationLevels)
        for k = 1:length(kernel_sizes)
            % Construct the filename
            filename = sprintf('i%02d_%s_%s.png', i, aberrationCode, aberrationLevels{j});
            % filename = sprintf('final%02d_%s_%s.png', i, distortionType, levels{l});
            % Full path to the image file
            inputFile = fullfile(inputDir, filename);
            % Read the image
            disp(['========================== ',filename,' =========================='])
            y = im2double(imread(inputFile));
            yg = im2double(rgb2gray(y));

            opts.kernel_size = kernel_sizes(k);

            lambda = 0.1; lambda_grad = 4e-3;
            lambda_tv = 1e-3; lambda_l0 = 1e-3; weight_ring = 0; % lambda_tv, lambda_l0, weight_ring are not used in kernel estimation.

            tic;
            [kernel, interim_latent] = blind_deconv(yg, lambda, lambda_grad, opts);
            toc

            % Final Deblur: TV-L2 denoising method
            y = im2double(y);
            Latent = ringing_artifacts_removal(y, kernel, lambda_tv, lambda_l0, weight_ring);

            k_norm = kernel - min(kernel(:));
            k_norm = k_norm./max(k_norm(:));

            % Construct the output filename including the kernel size
            outputFilename = sprintf('%s_%d.png', filename(1:end-4), kernel_sizes(k));
            outputFile = fullfile(outputDir, outputFilename);

            % Write the deblurred image to the output directory
            imwrite(Latent, outputFile);
            % end
        end
    end
end
