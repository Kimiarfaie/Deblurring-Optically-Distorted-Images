clear; close all; clc;

addpath(genpath('cho_code'));
inputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/Optical Aberration Dataset/Distorted Images';
outputDir = '/Users/kimiaarfaie/Desktop/Internship/Optical Aberration Dataset/PMP/Deblurred Images/';

% CID
distortions = struct();
distortions.Defocus = {'0.5', '1', '1.5', '2'};
distortions.Spherical_Abberation = {'0.2', '0.4', '0.6', '0.9'};
distortions.Vertical_Astigmatism = {'0.5', '1', '1.5', '2'};
numImages = 23;

% kernel_sizes = [25, 35, 45, 55, 65];
kernel_sizes = [110, 130, 150];

opts.prescale = 1; % downsampling
opts.xk_iter = 5;  % the iterations
opts.k_thresh = 20;
opts.gamma_correct = 1.0;

% Loop over each image, process it, and save the output
for i = []
    % Loop over all distortion types
    distortionFields = fieldnames(distortions);
    for j = 1:numel(distortionFields)
        distortionType = distortionFields{j};
        levels = distortions.(distortionType);

        % Loop over all levels for this distortion
        for l = 1:numel(levels)
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
            end
        end
    end
end
