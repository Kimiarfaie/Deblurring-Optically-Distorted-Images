%% Analyze the image quality of deblurred images using metrics

close all; clear; clc;
% Path to the deblurred images
addpath(genpath('../Metrics'));
deblurred_folder = 'NAFNet/Deblurred Images';
output_folder = 'NAFNet';

% Define each distortion and their respective levels
distortions = struct();
distortions.Defocus = {'0.5', '1', '1.5', '2'};
distortions.Spherical_Abberation = {'0.2', '0.4', '0.6', '0.9'};
distortions.Vertical_Astigmatism = {'0.5', '1', '1.5', '2'};

% List of image base names
image_base_names = arrayfun(@(x) sprintf('final%02d', x), 1:23, 'UniformOutput', false);

% Initialize the 3D matrix to store MSSIM values
mssim_matrices = zeros(12, 12, 23);

% Iterate over each image base name
for img_idx = 1:numel(image_base_names)
    image_base_name = image_base_names{img_idx};
    image_variations = {};
    
    % Load all variations of the current image
    for field = fieldnames(distortions)'
        distortion_type = field{1};
        levels = distortions.(distortion_type);
        for level_idx = 1:numel(levels)
            level = levels{level_idx};
            image_filename = sprintf('%s/%s_%s_%s.png', deblurred_folder, image_base_name, distortion_type, level);
            image_variations{end+1} = imread(image_filename); %#ok<SAGROW>
        end
    end

    % Initialize a matrix to store MSSIM values for current image set
    mssim_matrix = zeros(12, 12);
    
    % Calculate PSNR for all pairs
    for i = 1:12
        for j = i:12
            if i == j
                mssim_value = 1; 
            else
                mssim_value = mean(multissim(image_variations{i}, image_variations{j}));
            end
            mssim_matrix(i, j) = mssim_value;
            mssim_matrix(j, i) = mssim_value; 
        end
    end

    % Store the PSNR matrix in the 3D matrix
    mssim_matrices(:, :, img_idx) = mssim_matrix;
end

% Save the 3D matrix to a file
% save(fullfile(output_folder, 'mssim_matrices_OnlyDeblurredImages.mat'), 'mssim_matrices');

%%
load(fullfile(output_folder, 'mssim_matrices_OnlyDeblurredImages.mat'), 'mssim_matrices');

% Iterate over each image's PSNR matrix
for img_idx = 1:23
    mssim_matrix = mssim_matrices(:, :, img_idx);

    % Initialize a vector to store off-diagonal values
    off_diagonal_values = [];
    
    % Extract the off-diagonal values manually
    for i = 1:size(mssim_matrix, 1)
        for j = 1:size(mssim_matrix, 2)
            if i ~= j
                off_diagonal_values = [off_diagonal_values, mssim_matrix(i, j)];
            end
        end
    end
    
    % Calculate the variance of the off-diagonal values
    variances(img_idx) = var(off_diagonal_values);
    averages(img_idx) = mean(off_diagonal_values);
end







