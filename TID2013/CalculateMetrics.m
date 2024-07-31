%% Analyze the image quality using different metrics

close all; clear; clc;
% Path to reference and deblurred images
addpath(genpath('../Metrics'));
reference_folder = 'Reference Images';
deblurred_folder = 'ESM/Deblurred Images';
output_folder = 'ESM/Kernelsize_5';

% List of reference image names
refImages = arrayfun(@(x) sprintf('i%02d.png', x), 1:25, 'UniformOutput', false);

% Define each distortion and their respective levels
aberrationCode = '08';
aberrationLevels = {'1', '2', '3', '4', '5'};

% Initialize arrays to store the results
psnrValues = {};
rmseValues = {};
MSSIMValues = {};
brisqueScores = {};
TVDValues = {};
FSIMValues = {};
JNBValues = {};
CPBDValues = {};
lpcValues = {};

% Loop through each reference image
for i = [4,13,17,8]
    % Read the reference image
    refImgPath = fullfile(reference_folder, refImages{i});
    refImg = imread(refImgPath);

    % Loop over all levels of aberration
    for level = aberrationLevels
        % Construct the filename of the deblurred image
        deblurredImgName = sprintf('%s_%s_%s_5.png', refImages{i}(1:end-4), aberrationCode, level{:});
        deblurredImgPath = fullfile(deblurred_folder, deblurredImgName);
        deblurredImg = imread(deblurredImgPath);

        % Calculate metrics
        % Full Reference (FR) Metrics
        psnrValues{end+1, 1} = psnr(deblurredImg, refImg);
        psnrValues{end, 2} = deblurredImgName;
        rmseValues{end+1, 1} = sqrt(mean((im2double(deblurredImg(:)) - im2double(refImg(:))).^2));
        rmseValues{end, 2} = deblurredImgName;
        TVDValues{end+1, 1} = tvdiff(im2double(refImg), im2double(deblurredImg), 1, 1, 1);
        TVDValues{end, 2} = deblurredImgName;
        [FSIM, FSIMc] = FeatureSIM(refImg, deblurredImg);
        FSIMValues{end+1, 1} = FSIMc;
        FSIMValues{end, 2} = deblurredImgName;
        MSSIMValues{end+1, 1} = mean(multissim(deblurredImg, refImg));
        MSSIMValues{end, 2} = deblurredImgName;
        % No Reference (NR) Metrics
        [lpc, ~] = lpc_si(deblurredImg);
        lpcValues {end+1, 1} = lpc;
        lpcValues {end, 2} = deblurredImgName;
        CPBDValues{end+1, 1} = CPBD_compute(deblurredImg);
        CPBDValues{end, 2} = deblurredImgName;
        JNBValues{end+1, 1} = JNBM_compute(rgb2gray(deblurredImg));
        JNBValues{end, 2} = deblurredImgName;
        brisqueScores{end+1, 1} = brisque(deblurredImg);
        brisqueScores{end, 2} = deblurredImgName;
    end
end

% Calculate mean and max values of each metric
meanPSNR = mean(cell2mat(psnrValues(:, 1))); maxPSNR = max(cell2mat(psnrValues(:, 1)));
meanRMSE = mean(cell2mat(rmseValues(:, 1))); maxRMSE = max(cell2mat(rmseValues(:, 1)));
meanBRISQUE = mean(cell2mat(brisqueScores(:, 1))); maxBRISQUE = max(cell2mat(brisqueScores(:, 1)));
meanlpc = mean(cell2mat(lpcValues(:, 1))); maxlpc = max(cell2mat(lpcValues(:, 1)));
meanCPBD = mean(cell2mat(CPBDValues(:, 1))); maxCPBD = max(cell2mat(CPBDValues(:, 1)));
meanJNB = mean(cell2mat(JNBValues(:, 1))); maxJNB = max(cell2mat(JNBValues(:, 1)));
meanFSIM = mean(cell2mat(FSIMValues(:, 1))); maxFSIM = max(cell2mat(FSIMValues(:, 1)));
meanMSSIM = mean(cell2mat(MSSIMValues(:, 1))); maxMSSIM = max(cell2mat(MSSIMValues(:, 1)));
meanTVD = mean(cell2mat(TVDValues(:, 1))); maxTVD = max(cell2mat(TVDValues(:, 1)));

% Display results
fprintf('\n\nSummary of Image Quality Metrics:\n');
fprintf('Mean PSNR: %.2f, Max PSNR: %.2f\n', meanPSNR, maxPSNR);
fprintf('Mean RMSE: %.4f, Max RMSE: %.4f\n', meanRMSE, maxRMSE);
fprintf('Mean BRISQUE: %.4f, Max BRISQUE: %.4f\n', meanBRISQUE, maxBRISQUE);
fprintf('Mean LPC_si: %.4f, Max LPC_si: %.4f\n', meanlpc, maxlpc);
fprintf('Mean CPBD: %.4f, Max CPBD: %.4f\n', meanCPBD, maxCPBD);
fprintf('Mean JNB: %.4f, Max JNB: %.4f\n', meanJNB, maxJNB);
fprintf('Mean FSIM: %.4f, Max FSIM: %.4f\n', meanFSIM, maxFSIM);
fprintf('Mean MSSIM: %.4f, Max MSSIM: %.4f\n', meanMSSIM, maxMSSIM);
fprintf('Mean TVD: %.4f, Max TVD: %.4f\n', meanTVD, maxTVD);

% Save results to files
save(fullfile(output_folder, 'psnrValues.mat'), 'psnrValues');
save(fullfile(output_folder, 'rmseValues.mat'), 'rmseValues');
save(fullfile(output_folder, 'MSSIMValues.mat'), 'MSSIMValues');
save(fullfile(output_folder, 'brisqueScores.mat'), 'brisqueScores');
save(fullfile(output_folder, 'TVDValues.mat'), 'TVDValues');
save(fullfile(output_folder, 'FSIMValues.mat'), 'FSIMValues');
save(fullfile(output_folder, 'JNBValues.mat'), 'JNBValues');
save(fullfile(output_folder, 'CPBDValues.mat'), 'CPBDValues');
save(fullfile(output_folder, 'lpcValues.mat'), 'lpcValues');

% Save summary results to a text file
summary_file = fullfile(output_folder, 'Summary.txt');
fileID = fopen(summary_file, 'w');
fprintf(fileID, 'Summary of Image Quality Metrics:\n');
fprintf(fileID, 'Mean PSNR: %.2f, Max PSNR: %.2f\n', meanPSNR, maxPSNR);
fprintf(fileID, 'Mean RMSE: %.4f, Max RMSE: %.4f\n', meanRMSE, maxRMSE);
fprintf(fileID, 'Mean BRISQUE: %.4f, Max BRISQUE: %.4f\n', meanBRISQUE, maxBRISQUE);
fprintf(fileID, 'Mean CPBD: %.4f, Max CPBD: %.4f\n', meanCPBD, maxCPBD);
fprintf(fileID, 'Mean JNB: %.4f, Max JNB: %.4f\n', meanJNB, maxJNB);
fprintf(fileID, 'Mean FSIM: %.4f, Max FSIM: %.4f\n', meanFSIM, maxFSIM);
fprintf(fileID, 'Mean MSSIM: %.4f, Max MSSIM: %.4f\n', meanMSSIM, maxMSSIM);
fprintf(fileID, 'Mean TVD: %.4f, Max TVD: %.4f\n', meanTVD, maxTVD);
fprintf(fileID, 'Mean lpc: %.4f, Max lpc: %.4f\n', meanlpc, maxlpc);
fclose(fileID);