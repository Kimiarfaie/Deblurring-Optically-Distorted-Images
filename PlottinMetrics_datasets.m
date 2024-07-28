%%
% Plot against reference 
close all; clear; clc;

% Reference
referencefolder = 'ReferenceVSBlurred-TID2013';

% List of file names and metric names
files = {'rmseValues.mat', 'MSSIMValues.mat', 'lpcValues.mat', 'FSIMValues.mat', 'CPBDValues.mat', ...
         'TVDValues.mat'};
metricNames = {'RMSE', 'MSSIM', 'LPC', 'FSIM', 'CPBD', 'TVD'};

% Preallocate array to store averages
TIDAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(referencefolder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    TIDAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Outputs
% Reference
folder = 'ReferenceVSBlurred-CID';

% Preallocate array to store averages
CIDAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(folder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    CIDAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Create a bar plot
Y = [TIDAverages; CIDAverages]'; 
X = 1:length(files); 

% Create a bar plot with grouped bars
figure;
bar(X, Y, 1);  % The '1' here makes the bars group together tightly

% Enhance the plot
set(gca, 'XTick', X, 'XTickLabel', metricNames);
xtickangle(45);
legend('Reference Vs Blurred - TID', 'Reference Vs Blurred - CID:OA', 'Location', 'Best');
ylabel('Average Value');
hold off;

% Save the figure in the specified directory
saveas(gcf, fullfile(folder, 'dataset_comparison_plot.png'));

%%


% List of file names and metric names
files = {'psnrValues.mat', 'brisqueScores.mat', 'JNBValues.mat'};
metricNames = {'PSNR', 'BRISQUE', 'JNB'};

% Preallocate array to store averages
TIDAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(referencefolder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    TIDAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Outputs
% Reference

% Preallocate array to store averages
CIDAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(folder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    CIDAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Create a bar plot
Y = [TIDAverages; CIDAverages]'; 
X = 1:length(files); 

% Create a bar plot with grouped bars
figure;
bar(X, Y, 1);  % The '1' here makes the bars group together tightly

% Enhance the plot
set(gca, 'XTick', X, 'XTickLabel', metricNames);
xtickangle(45);
legend('Reference Vs Blurred - TID', 'Reference Vs Deblurred - CID:OA', 'Location', 'Best');
ylabel('Average Value');
hold off;

% Save the figure in the specified directory
saveas(gcf, fullfile(folder, 'dataset_comparison_plot2.png'));