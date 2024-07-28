lena = imread('lena256color.tif');
lena2 = imnoise(lena,'salt & pepper',0.02);

diffscript(im2double(lena), im2double(lena2), 1,1,1,30)


