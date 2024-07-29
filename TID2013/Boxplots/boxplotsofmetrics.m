close all; clear; clc;

NAFNet = 'NAFNet - TID2013';
Restormer = 'Restormer - TID2013';
MPRNet = 'MPRNet';
DRBNet = 'DRBNet - TID2013';
LaKDNet_LFDOF_s = 'LaKDNet/LFDOF - small';
LaKDNet_DPDD_l = 'LaKDNet/DPDD - large';
LaKDNet_DPDD_s = 'LaKDNet/DPDD - small';
LaKDNet_LFDPDD_s = 'LaKDNet/LFDPDD - small';
Stripformer = 'Stripformer';
JDRL = 'JDRL/DPDD';

files = {'rmseValues.mat', 'MSSIMValues.mat', 'lpcValues.mat', 'FSIMValues.mat', 'CPBDValues.mat', ...
         'TVDValues.mat', 'psnrValues.mat', 'brisqueScores.mat', 'JNBValues.mat'};
metricNames = {'RMSE', 'MSSIM', 'LPC', 'FSIM', 'CPBD', 'TVD', 'PSNR', 'BRISQUE', 'JNB'};

imageNames = {'i01_08_1.png'
'i01_08_2.png'
'i01_08_3.png'
'i01_08_4.png'
'i01_08_5.png'
'i02_08_1.png'
'i02_08_2.png'
'i02_08_3.png'
'i02_08_4.png'
'i02_08_5.png'
'i03_08_1.png'
'i03_08_2.png'
'i03_08_3.png'
'i03_08_4.png'
'i03_08_5.png'
'i04_08_1.png'
'i04_08_2.png'
'i04_08_3.png'
'i04_08_4.png'
'i04_08_5.png'
'i05_08_1.png'
'i05_08_2.png'
'i05_08_3.png'
'i05_08_4.png'
'i05_08_5.png'
'i06_08_1.png'
'i06_08_2.png'
'i06_08_3.png'
'i06_08_4.png'
'i06_08_5.png'
'i07_08_1.png'
'i07_08_2.png'
'i07_08_3.png'
'i07_08_4.png'
'i07_08_5.png'
'i08_08_1.png'
'i08_08_2.png'
'i08_08_3.png'
'i08_08_4.png'
'i08_08_5.png'
'i09_08_1.png'
'i09_08_2.png'
'i09_08_3.png'
'i09_08_4.png'
'i09_08_5.png'
'i10_08_1.png'
'i10_08_2.png'
'i10_08_3.png'
'i10_08_4.png'
'i10_08_5.png'
'i11_08_1.png'
'i11_08_2.png'
'i11_08_3.png'
'i11_08_4.png'
'i11_08_5.png'
'i12_08_1.png'
'i12_08_2.png'
'i12_08_3.png'
'i12_08_4.png'
'i12_08_5.png'
'i13_08_1.png'
'i13_08_2.png'
'i13_08_3.png'
'i13_08_4.png'
'i13_08_5.png'
'i14_08_1.png'
'i14_08_2.png'
'i14_08_3.png'
'i14_08_4.png'
'i14_08_5.png'
'i15_08_1.png'
'i15_08_2.png'
'i15_08_3.png'
'i15_08_4.png'
'i15_08_5.png'
'i16_08_1.png'
'i16_08_2.png'
'i16_08_3.png'
'i16_08_4.png'
'i16_08_5.png'
'i17_08_1.png'
'i17_08_2.png'
'i17_08_3.png'
'i17_08_4.png'
'i17_08_5.png'
'i18_08_1.png'
'i18_08_2.png'
'i18_08_3.png'
'i18_08_4.png'
'i18_08_5.png'
'i19_08_1.png'
'i19_08_2.png'
'i19_08_3.png'
'i19_08_4.png'
'i19_08_5.png'
'i20_08_1.png'
'i20_08_2.png'
'i20_08_3.png'
'i20_08_4.png'
'i20_08_5.png'
'i21_08_1.png'
'i21_08_2.png'
'i21_08_3.png'
'i21_08_4.png'
'i21_08_5.png'
'i22_08_1.png'
'i22_08_2.png'
'i22_08_3.png'
'i22_08_4.png'
'i22_08_5.png'
'i23_08_1.png'
'i23_08_2.png'
'i23_08_3.png'
'i23_08_4.png'
'i23_08_5.png'
'i24_08_1.png'
'i24_08_2.png'
'i24_08_3.png'
'i24_08_4.png'
'i24_08_5.png'
'i25_08_1.png'
'i25_08_2.png'
'i25_08_3.png'
'i25_08_4.png'
'i25_08_5.png'};

% Number of methods
methods = {NAFNet, Restormer, MPRNet, DRBNet, LaKDNet_LFDOF_s, LaKDNet_DPDD_l, LaKDNet_DPDD_s, LaKDNet_LFDPDD_s, Stripformer, JDRL};
numMethods = length(methods);

% Open one text file for all metrics to save the outliers
fid = fopen('all_metrics_outliers_summary.txt', 'w');

% Iterate over each metric file
for i = 1:length(files)
    % Initialize data container
    allData = [];
    
    % Load data from each method
    for j = 1:numMethods
        % Construct full file path
        filePath = fullfile(methods{j}, files{i});
        
        % Load the data
        data = load(filePath);

        % Get the field names of the loaded structure
        fieldNames = fieldnames(data);
        
        % Extract the data
        currentData = data.(fieldNames{1}); % Numeric data is in the first column
        
        % Append data for boxplot
        allData = [allData, currentData(:,1)];  % Ensure data is a column vector
    end

    allData = cell2mat(allData);

    % Create a boxplot for the current metric
    figure;
    h = boxplot(allData, 'Labels', methods);
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

    % Dynamically adjust y-axis limits
    dataMin = min(allData(:));  % Find minimum data value
    dataMax = max(allData(:));  % Find maximum data value
    ylim([dataMin - 0.01*abs(dataMin), dataMax + 0.01*abs(dataMax)]);  % Set y-axis limits with 1% buffer

    % Add only horizontal grid lines faintly
    set(gca, 'YGrid', 'on');   % Turn on only the horizontal grid lines
    set(gca, 'XGrid', 'off');  
    set(gca, 'GridLineStyle', ':', 'GridColor', [0.8 0.8 0.8], 'GridAlpha', 0.7);  % Set the style and color of the grid lines

    % Save the figure
    saveas(gcf, [metricNames{i}, '_boxplot.png']); % Save as PNG
end

% Close the text file
fclose(fid);

