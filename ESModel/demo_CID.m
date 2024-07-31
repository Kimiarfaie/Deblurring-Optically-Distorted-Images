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

inputDir = 'CID/Distorted Images';
outputDir = 'CID/Deblurred Images';

% CID
distortions = struct();
distortions.Defocus = {'0.5', '1', '1.5', '2'};
distortions.Spherical_Abberation = {'0.2', '0.4', '0.6', '0.9'};
distortions.Vertical_Astigmatism = {'0.5', '1', '1.5', '2'};
numImages = 23;
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
for i = 1:numImages-1
    % Loop over all distortion types
    distortionFields = fieldnames(distortions);
    for j = 1:numel(distortionFields)
        distortionType = distortionFields{j};
        levels = distortions.(distortionType);

        % Loop over all levels for this distortion
        for l = 1:numel(levels)
            
            % Construct the filename
            filename = sprintf('final%02d_%s_%s.png', i, distortionType, levels{l});
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
    
            % Algorithm is done!
    
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
    
            % Construct the output filename including the kernel size
            outputFilename = sprintf('%s_%d.png', filename(1:end-4), opts.kernel_size);
            outputFile = fullfile(outputDir, outputFilename);
    
            % Write the deblurred image to the output directory
            imwrite(Latent, outputFile);
        end
        
   end
end

