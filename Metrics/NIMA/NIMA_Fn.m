function score = NIMA_Fn(im)
% This function analyzes the image quality using the NIMA method.
% ---- Input -----:
% im: Input image
% ---- Output -----:
% score: Quality score of the image
% ----------------------------------

% This part of code is adopted from MATLAB website under the title of
% "Evaluate Image Quality Using Trained NIMA Model"
% More information about NIMA could be found in:
% https://doi.org/10.1109/TIP.2018.2831899

F=load(fullfile("trainedNIMA.mat")) ;

[score,~] = predictNIMAScore(F.dlnet,im);
end