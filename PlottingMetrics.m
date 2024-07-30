%%
% Plot against reference 
close all; clear; clc;

% Reference
referencefolder = 'Optical Aberration Dataset/ReferenceVSBlurred';
% referencefolder = 'TID2013/ReferenceVSBlurred';

% List of file names and metric names
files = {'rmseValues.mat', 'MSSIMValues.mat', 'lpcValues.mat', 'FSIMValues.mat', 'CPBDValues.mat', ...
         'TVDValues.mat'};
metricNames = {'RMSE', 'MSSIM', 'LPC', 'FSIM', 'CPBD', 'TVD'};

% Preallocate array to store averages
referenceAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(referencefolder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    referenceAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Outputs
% Reference
folder = 'Optical Aberration Dataset/PMP/Kernelsize_25';
% folder = 'TID2013/PMP/Metrics/Kernelsize_25';


% Preallocate array to store averages
Averages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(folder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    Averages(i) = mean(cell2mat(numericData(:, 1)));
end

% Create a bar plot
Y = [referenceAverages; Averages]'; 
X = 1:length(files); 

% Create a bar plot with grouped bars
figure;
b = bar(X, Y, 1);  % The '1' here makes the bars group together tightly

% Set colors after creating the bar
% % Default colors for all bars: blue for 'Reference Vs Blurred' and orange for 'Reference Vs Deblurred'
% set(b(1), 'FaceColor', 'b'); % For 'Reference Vs Blurred'
% set(b(2), 'FaceColor', 'r'); % For 'Reference Vs Deblurred' - typically orange or similar

% Change specific metrics to green for 'Reference Vs Deblurred'
greenMetrics = {'RMSE', 'TVD'}; % Metrics to turn green
for i = 1:length(metricNames)
    if any(strcmp(greenMetrics, metricNames{i}))
        set(b(2), 'FaceColor', 'flat');
        b(2).CData(i, :) = [0 1 0]; % Green color
    end
end

% Enhance the plot
set(gca, 'XTick', X, 'XTickLabel', metricNames);
xtickangle(45);

% Create custom legend
hold on;
h1 = bar(nan, nan, 'b');  % Dummy bar for blue
h2 = bar(nan, nan, 'r');  % Dummy bar for red
h3 = bar(nan, nan, 'g');  % Dummy bar for green

legend([h1 h2 h3], {'Reference Vs Blurred', 'Reference Vs Deblurred', 'Reference Vs Deblurred'}, 'Location', 'Best');
ylabel('Average Value');
hold off;

% Save the figure in the specified directory
saveas(gcf, fullfile(folder, 'metric_comparison_plot.png'));

%%


% List of file names and metric names
files = {'psnrValues.mat', 'brisqueScores.mat', 'JNBValues.mat'};
metricNames = {'PSNR', 'BRISQUE', 'JNB'};

% Preallocate array to store averages
referenceAverages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(referencefolder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    referenceAverages(i) = mean(cell2mat(numericData(:, 1)));
end

% Preallocate array to store averages
Averages = zeros(1, length(files));

% Loop through each file, load the data, and calculate the mean
for i = 1:length(files)
    data = load(fullfile(folder, files{i}));
    fieldName = fieldnames(data); % Automatically get the field name
    % Extract the numeric data from the cell
    numericData = data.(fieldName{1});
    Averages(i) = mean(cell2mat(numericData(:, 1)));
end

% Create a bar plot
Y = [referenceAverages; Averages]'; 
X = 1:length(files); 

% Create a bar plot with grouped bars
figure;
b = bar(X, Y, 1);  % The '1' here makes the bars group together tightly

% Set colors after creating the bar
% Default colors for all bars: blue for 'Reference Vs Blurred' and orange for 'Reference Vs Deblurred'
% set(b(1), 'FaceColor', 'b'); % For 'Reference Vs Blurred'
% set(b(2), 'FaceColor', 'r'); % For 'Reference Vs Deblurred' - typically orange or similar

% Change specific metrics to green for 'Reference Vs Deblurred'
greenMetrics = {'BRISQUE'}; % Metrics to turn green
for i = 1:length(metricNames)
    if any(strcmp(greenMetrics, metricNames{i}))
        set(b(2), 'FaceColor', 'flat');
        b(2).CData(i, :) = [0 1 0]; % Green color
    end
end

% Enhance the plot
set(gca, 'XTick', X, 'XTickLabel', metricNames);
xtickangle(45);

% Create custom legend
hold on;
h1 = bar(nan, nan, 'b');  % Dummy bar for blue
h2 = bar(nan, nan, 'r');  % Dummy bar for red
h3 = bar(nan, nan, 'g');  % Dummy bar for green

legend([h1 h2 h3], {'Reference Vs Blurred', 'Reference Vs Deblurred', 'Reference Vs Deblurred'}, 'Location', 'Best');

ylabel('Average Value');
hold off;

% Save the figure in the specified directory
saveas(gcf, fullfile(folder, 'metric_comparison_plot2.png'));