clc;clear;close all;


inputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/Distorted Images';
outputDir = '/Users/kimiaarfaie/Desktop/Internship/Internship/TID2013/deconvblind/iteration10/Deblurred Images';

% TID
aberrationCode = '08';
aberrationLevels = {'1','2', '3', '4', '5'};
numImages = 25;

kernel_sizes = 10;
damp = 0.4;

% Loop over each image, process it, and save the output
for i = 1:numImages
   for j = 1:numel(aberrationLevels)
        for k = 1:length(kernel_sizes)
            % Construct the filename
            filename = sprintf('i%02d_%s_%s.png', i, aberrationCode, aberrationLevels{j});
            % Full path to the image file
            inputFile = fullfile(inputDir, filename);
            % Read the image
            disp(['========================== ',filename,' =========================='])
            intial_kernel = ones(kernel_sizes(k));
            I = im2double(imread(inputFile));
            tic
            [Deblurred, psf] = deconvblind(I, intial_kernel, 10);
            toc

            % Construct the output filename including the kernel size
            outputFilename = sprintf('%s_%d.png', filename(1:end-4), kernel_sizes(k));
            outputFile = fullfile(outputDir, outputFilename);

            % Write the deblurred image to the output directory
            imwrite(Deblurred, outputFile);
            % end
        end
   end
end