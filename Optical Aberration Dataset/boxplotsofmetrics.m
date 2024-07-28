close all; clear; clc;

NAFNet = 'NAFNet';
Restormer = 'Restormer';
MPRNet = 'MPRNet';
DRBNet = 'DRBNet';
LaKDNet_LFDOF_s = 'LaKDNet/LFDOF - small';
LaKDNet_DPDD_l = 'LaKDNet/DPDD - large';
LaKDNet_DPDD_s = 'LaKDNet/DPDD - small';
LaKDNet_LFDPDD_s = 'LaKDNet/LFDPDD - small';
Stripformer = 'Stripformer';
JDRL = 'JDRL/DPDD';

files = {'rmseValues.mat', 'MSSIMValues.mat', 'lpcValues.mat', 'FSIMValues.mat', 'CPBDValues.mat', ...
         'TVDValues.mat', 'psnrValues.mat', 'brisqueScores.mat', 'JNBValues.mat'};
metricNames = {'RMSE', 'MSSIM', 'LPC', 'FSIM', 'CPBD', 'TVD', 'PSNR', 'BRISQUE', 'JNB'};

% Number of methods
methods = {NAFNet, Restormer, MPRNet, DRBNet, LaKDNet_LFDOF_s, LaKDNet_DPDD_l, LaKDNet_DPDD_s, LaKDNet_LFDPDD_s, Stripformer, JDRL};
numMethods = length(methods);

% length of data
nimg = 276;

imageNames = {'final01_Defocus_0.5.png'
'final01_Defocus_1.png'
'final01_Defocus_1.5.png'
'final01_Defocus_2.png'
'final01_Spherical_Abberation_0.2.png'
'final01_Spherical_Abberation_0.4.png'
'final01_Spherical_Abberation_0.6.png'
'final01_Spherical_Abberation_0.9.png'
'final01_Vertical_Astigmatism_0.5.png'
'final01_Vertical_Astigmatism_1.png'
'final01_Vertical_Astigmatism_1.5.png'
'final01_Vertical_Astigmatism_2.png'
'final02_Defocus_0.5.png'
'final02_Defocus_1.png'
'final02_Defocus_1.5.png'
'final02_Defocus_2.png'
'final02_Spherical_Abberation_0.2.png'
'final02_Spherical_Abberation_0.4.png'
'final02_Spherical_Abberation_0.6.png'
'final02_Spherical_Abberation_0.9.png'
'final02_Vertical_Astigmatism_0.5.png'
'final02_Vertical_Astigmatism_1.png'
'final02_Vertical_Astigmatism_1.5.png'
'final02_Vertical_Astigmatism_2.png'
'final03_Defocus_0.5.png'
'final03_Defocus_1.png'
'final03_Defocus_1.5.png'
'final03_Defocus_2.png'
'final03_Spherical_Abberation_0.2.png'
'final03_Spherical_Abberation_0.4.png'
'final03_Spherical_Abberation_0.6.png'
'final03_Spherical_Abberation_0.9.png'
'final03_Vertical_Astigmatism_0.5.png'
'final03_Vertical_Astigmatism_1.png'
'final03_Vertical_Astigmatism_1.5.png'
'final03_Vertical_Astigmatism_2.png'
'final04_Defocus_0.5.png'
'final04_Defocus_1.png'
'final04_Defocus_1.5.png'
'final04_Defocus_2.png'
'final04_Spherical_Abberation_0.2.png'
'final04_Spherical_Abberation_0.4.png'
'final04_Spherical_Abberation_0.6.png'
'final04_Spherical_Abberation_0.9.png'
'final04_Vertical_Astigmatism_0.5.png'
'final04_Vertical_Astigmatism_1.png'
'final04_Vertical_Astigmatism_1.5.png'
'final04_Vertical_Astigmatism_2.png'
'final05_Defocus_0.5.png'
'final05_Defocus_1.png'
'final05_Defocus_1.5.png'
'final05_Defocus_2.png'
'final05_Spherical_Abberation_0.2.png'
'final05_Spherical_Abberation_0.4.png'
'final05_Spherical_Abberation_0.6.png'
'final05_Spherical_Abberation_0.9.png'
'final05_Vertical_Astigmatism_0.5.png'
'final05_Vertical_Astigmatism_1.png'
'final05_Vertical_Astigmatism_1.5.png'
'final05_Vertical_Astigmatism_2.png'
'final06_Defocus_0.5.png'
'final06_Defocus_1.png'
'final06_Defocus_1.5.png'
'final06_Defocus_2.png'
'final06_Spherical_Abberation_0.2.png'
'final06_Spherical_Abberation_0.4.png'
'final06_Spherical_Abberation_0.6.png'
'final06_Spherical_Abberation_0.9.png'
'final06_Vertical_Astigmatism_0.5.png'
'final06_Vertical_Astigmatism_1.png'
'final06_Vertical_Astigmatism_1.5.png'
'final06_Vertical_Astigmatism_2.png'
'final07_Defocus_0.5.png'
'final07_Defocus_1.png'
'final07_Defocus_1.5.png'
'final07_Defocus_2.png'
'final07_Spherical_Abberation_0.2.png'
'final07_Spherical_Abberation_0.4.png'
'final07_Spherical_Abberation_0.6.png'
'final07_Spherical_Abberation_0.9.png'
'final07_Vertical_Astigmatism_0.5.png'
'final07_Vertical_Astigmatism_1.png'
'final07_Vertical_Astigmatism_1.5.png'
'final07_Vertical_Astigmatism_2.png'
'final08_Defocus_0.5.png'
'final08_Defocus_1.png'
'final08_Defocus_1.5.png'
'final08_Defocus_2.png'
'final08_Spherical_Abberation_0.2.png'
'final08_Spherical_Abberation_0.4.png'
'final08_Spherical_Abberation_0.6.png'
'final08_Spherical_Abberation_0.9.png'
'final08_Vertical_Astigmatism_0.5.png'
'final08_Vertical_Astigmatism_1.png'
'final08_Vertical_Astigmatism_1.5.png'
'final08_Vertical_Astigmatism_2.png'
'final09_Defocus_0.5.png'
'final09_Defocus_1.png'
'final09_Defocus_1.5.png'
'final09_Defocus_2.png'
'final09_Spherical_Abberation_0.2.png'
'final09_Spherical_Abberation_0.4.png'
'final09_Spherical_Abberation_0.6.png'
'final09_Spherical_Abberation_0.9.png'
'final09_Vertical_Astigmatism_0.5.png'
'final09_Vertical_Astigmatism_1.png'
'final09_Vertical_Astigmatism_1.5.png'
'final09_Vertical_Astigmatism_2.png'
'final10_Defocus_0.5.png'
'final10_Defocus_1.png'
'final10_Defocus_1.5.png'
'final10_Defocus_2.png'
'final10_Spherical_Abberation_0.2.png'
'final10_Spherical_Abberation_0.4.png'
'final10_Spherical_Abberation_0.6.png'
'final10_Spherical_Abberation_0.9.png'
'final10_Vertical_Astigmatism_0.5.png'
'final10_Vertical_Astigmatism_1.png'
'final10_Vertical_Astigmatism_1.5.png'
'final10_Vertical_Astigmatism_2.png'
'final11_Defocus_0.5.png'
'final11_Defocus_1.png'
'final11_Defocus_1.5.png'
'final11_Defocus_2.png'
'final11_Spherical_Abberation_0.2.png'
'final11_Spherical_Abberation_0.4.png'
'final11_Spherical_Abberation_0.6.png'
'final11_Spherical_Abberation_0.9.png'
'final11_Vertical_Astigmatism_0.5.png'
'final11_Vertical_Astigmatism_1.png'
'final11_Vertical_Astigmatism_1.5.png'
'final11_Vertical_Astigmatism_2.png'
'final12_Defocus_0.5.png'
'final12_Defocus_1.png'
'final12_Defocus_1.5.png'
'final12_Defocus_2.png'
'final12_Spherical_Abberation_0.2.png'
'final12_Spherical_Abberation_0.4.png'
'final12_Spherical_Abberation_0.6.png'
'final12_Spherical_Abberation_0.9.png'
'final12_Vertical_Astigmatism_0.5.png'
'final12_Vertical_Astigmatism_1.png'
'final12_Vertical_Astigmatism_1.5.png'
'final12_Vertical_Astigmatism_2.png'
'final13_Defocus_0.5.png'
'final13_Defocus_1.png'
'final13_Defocus_1.5.png'
'final13_Defocus_2.png'
'final13_Spherical_Abberation_0.2.png'
'final13_Spherical_Abberation_0.4.png'
'final13_Spherical_Abberation_0.6.png'
'final13_Spherical_Abberation_0.9.png'
'final13_Vertical_Astigmatism_0.5.png'
'final13_Vertical_Astigmatism_1.png'
'final13_Vertical_Astigmatism_1.5.png'
'final13_Vertical_Astigmatism_2.png'
'final14_Defocus_0.5.png'
'final14_Defocus_1.png'
'final14_Defocus_1.5.png'
'final14_Defocus_2.png'
'final14_Spherical_Abberation_0.2.png'
'final14_Spherical_Abberation_0.4.png'
'final14_Spherical_Abberation_0.6.png'
'final14_Spherical_Abberation_0.9.png'
'final14_Vertical_Astigmatism_0.5.png'
'final14_Vertical_Astigmatism_1.png'
'final14_Vertical_Astigmatism_1.5.png'
'final14_Vertical_Astigmatism_2.png'
'final15_Defocus_0.5.png'
'final15_Defocus_1.png'
'final15_Defocus_1.5.png'
'final15_Defocus_2.png'
'final15_Spherical_Abberation_0.2.png'
'final15_Spherical_Abberation_0.4.png'
'final15_Spherical_Abberation_0.6.png'
'final15_Spherical_Abberation_0.9.png'
'final15_Vertical_Astigmatism_0.5.png'
'final15_Vertical_Astigmatism_1.png'
'final15_Vertical_Astigmatism_1.5.png'
'final15_Vertical_Astigmatism_2.png'
'final16_Defocus_0.5.png'
'final16_Defocus_1.png'
'final16_Defocus_1.5.png'
'final16_Defocus_2.png'
'final16_Spherical_Abberation_0.2.png'
'final16_Spherical_Abberation_0.4.png'
'final16_Spherical_Abberation_0.6.png'
'final16_Spherical_Abberation_0.9.png'
'final16_Vertical_Astigmatism_0.5.png'
'final16_Vertical_Astigmatism_1.png'
'final16_Vertical_Astigmatism_1.5.png'
'final16_Vertical_Astigmatism_2.png'
'final17_Defocus_0.5.png'
'final17_Defocus_1.png'
'final17_Defocus_1.5.png'
'final17_Defocus_2.png'
'final17_Spherical_Abberation_0.2.png'
'final17_Spherical_Abberation_0.4.png'
'final17_Spherical_Abberation_0.6.png'
'final17_Spherical_Abberation_0.9.png'
'final17_Vertical_Astigmatism_0.5.png'
'final17_Vertical_Astigmatism_1.png'
'final17_Vertical_Astigmatism_1.5.png'
'final17_Vertical_Astigmatism_2.png'
'final18_Defocus_0.5.png'
'final18_Defocus_1.png'
'final18_Defocus_1.5.png'
'final18_Defocus_2.png'
'final18_Spherical_Abberation_0.2.png'
'final18_Spherical_Abberation_0.4.png'
'final18_Spherical_Abberation_0.6.png'
'final18_Spherical_Abberation_0.9.png'
'final18_Vertical_Astigmatism_0.5.png'
'final18_Vertical_Astigmatism_1.png'
'final18_Vertical_Astigmatism_1.5.png'
'final18_Vertical_Astigmatism_2.png'
'final19_Defocus_0.5.png'
'final19_Defocus_1.png'
'final19_Defocus_1.5.png'
'final19_Defocus_2.png'
'final19_Spherical_Abberation_0.2.png'
'final19_Spherical_Abberation_0.4.png'
'final19_Spherical_Abberation_0.6.png'
'final19_Spherical_Abberation_0.9.png'
'final19_Vertical_Astigmatism_0.5.png'
'final19_Vertical_Astigmatism_1.png'
'final19_Vertical_Astigmatism_1.5.png'
'final19_Vertical_Astigmatism_2.png'
'final20_Defocus_0.5.png'
'final20_Defocus_1.png'
'final20_Defocus_1.5.png'
'final20_Defocus_2.png'
'final20_Spherical_Abberation_0.2.png'
'final20_Spherical_Abberation_0.4.png'
'final20_Spherical_Abberation_0.6.png'
'final20_Spherical_Abberation_0.9.png'
'final20_Vertical_Astigmatism_0.5.png'
'final20_Vertical_Astigmatism_1.png'
'final20_Vertical_Astigmatism_1.5.png'
'final20_Vertical_Astigmatism_2.png'
'final21_Defocus_0.5.png'
'final21_Defocus_1.png'
'final21_Defocus_1.5.png'
'final21_Defocus_2.png'
'final21_Spherical_Abberation_0.2.png'
'final21_Spherical_Abberation_0.4.png'
'final21_Spherical_Abberation_0.6.png'
'final21_Spherical_Abberation_0.9.png'
'final21_Vertical_Astigmatism_0.5.png'
'final21_Vertical_Astigmatism_1.png'
'final21_Vertical_Astigmatism_1.5.png'
'final21_Vertical_Astigmatism_2.png'
'final22_Defocus_0.5.png'
'final22_Defocus_1.png'
'final22_Defocus_1.5.png'
'final22_Defocus_2.png'
'final22_Spherical_Abberation_0.2.png'
'final22_Spherical_Abberation_0.4.png'
'final22_Spherical_Abberation_0.6.png'
'final22_Spherical_Abberation_0.9.png'
'final22_Vertical_Astigmatism_0.5.png'
'final22_Vertical_Astigmatism_1.png'
'final22_Vertical_Astigmatism_1.5.png'
'final22_Vertical_Astigmatism_2.png'
'final23_Defocus_0.5.png'
'final23_Defocus_1.png'
'final23_Defocus_1.5.png'
'final23_Defocus_2.png'
'final23_Spherical_Abberation_0.2.png'
'final23_Spherical_Abberation_0.4.png'
'final23_Spherical_Abberation_0.6.png'
'final23_Spherical_Abberation_0.9.png'
'final23_Vertical_Astigmatism_0.5.png'
'final23_Vertical_Astigmatism_1.png'
'final23_Vertical_Astigmatism_1.5.png'
'final23_Vertical_Astigmatism_2.png'};

% Open one text file for all metrics to save the outliers
fid = fopen('all_metrics_outliers_summary.txt', 'w');

% Iterate over each metric file
for i = 1:length(files)
    % Initialize data container
    allData = [];
    allLabels = [];
    
    % Load data from each method
    for j = 1:numMethods
        % Construct full file path
        filePath = fullfile(methods{j}, files{i});
        
        % Load the data
        data = load(filePath);
        % Get the field names of the loaded structure (assuming each .mat file contains only one field)
        fieldNames = fieldnames(data);
        
        % Extract the data from the cell array
        currentData = data.(fieldNames{1});
        currentData = cell2mat(currentData(:,1));

        % Check and pad currentData if necessary
        if length(currentData) < nimg
            currentData = [currentData(1:144); NaN(12, 1); currentData(145:end)];
        end
        
        % Append data for boxplot
        allData = [allData, currentData(:,1)];
        
    end
    
    % Create a figure for the current metric
    figure;
    
    % Plot all data as a boxplot
    h = boxplot(allData, 'Labels', {'NAFNet', 'Restormer', 'MPRNet', 'DRBNet', 'LaKDNet_LFDOF_s', 'LaKDNet_DPDD_l', 'LaKDNet_DPDD_s', 'LaKDNet_LFDPDD_s', 'Stripfomer','JDRL'});
    
    % Customize the plot
    title(['Boxplot of ', metricNames{i}]);
    ylabel(metricNames{i});
    xlabel('Methods');
    
        % Retrieve boxplot children
    ax = gca();
    bph = ax.Children;
    bpchil = bph.Children;

    % Getting the Outliers 
    outlierHandles = findobj(bpchil, 'Tag', 'Outliers'); 

     % Initialize a variable to store all outlier values
    allOutlierValues = [];

    % Extract YData from each outlier handle (assuming there may be more than one handle)
    for oh = outlierHandles'
        allOutlierValues = [allOutlierValues, get(oh, 'YData')];
    end

   % Log outliers for the current metric to the txt file
    fprintf(fid, '\nOutliers for %s:\n', metricNames{i});

    % Loop over all outlier values
    for outlierValue = allOutlierValues
        outlierIndices = find(allData == outlierValue);  % Get indices of the specific outlier value
        for k = 1:numel(outlierIndices)
            [row, col] = ind2sub(size(allData), outlierIndices(k));
            if col <= numel(methods) && row <= numel(imageNames)
                fprintf(fid, 'Method: %s, Outlier Image: %s\n', methods{col}, imageNames{row});
            else
                fprintf(fid, 'Error: Index out of bounds. Method index: %d, Image index: %d\n', col, row);
            end
        end
    end

    % Add only horizontal grid lines faintly
    set(gca, 'YGrid', 'on');   % Turn on only the horizontal grid lines
    set(gca, 'XGrid', 'off');  
    set(gca, 'GridLineStyle', ':', 'GridColor', [0.8 0.8 0.8], 'GridAlpha', 0.7);  % Set the style and color of the grid lines

    % Save the figure
    saveas(gcf, [metricNames{i}, '_boxplot.png']); % Save as PNG
end

% Close the text file
fclose(fid);
