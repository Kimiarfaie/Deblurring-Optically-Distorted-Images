function [ContrastFilteredImage] = ColorContrastFiltering(imageInput,PixelsPerDegree,CperM2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Color Contrast Filtering of images based on the principles of Eli Peli
%(Contrast in Complex Images Journal of the Optical Society of America A,
%1990, 7, 2032-2040). 
%
%%%Code information: 
%ColorContrastFiltering.m is written by Marius Pedersen, Gj�vik University
%College, The Norwegian Color Research Laboratory, Norway. 
%Contact: marius.pedersen@hig.no
%
%OctaveFilter.m is written by Ivar Farup, Gj�vik University College,
%The Norwegian Color Research Laboratory, Norway.
%
%
%%%Usage:
%[ContrastFilteredImage] = ColorContrastFiltering(imageInput,PixelsPerDegree)
%imageInput is the read input image. 
%PixelsPerDegree is the number of pixels per degree. 
%ContrastFilteredImage is the filtered image. 
%
%%%Example:
% imageInput = imread('peppers.png');
% PixelsPerDegree = 60; 
% [ContrastFilteredImage] = ColorContrastFiltering(imageInput,PixelsPerDegree)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin == 0
imageInput = im2double(imread('lena256color.tif')); 
%If Pixels per degree is not set use a standard
%PixelsPerDegree = 59; % 100 cm
PixelsPerDegree = 118; %200 cm
%PixelsPerDegree = 177; %300 cm
%PixelsPerDegree = 236;%400 cm

%CperM2 = 75; %If CSF is changing due to luminance level. CperM2 = cd/m2 %As of now the CSF do not use this parameter
end

%Converting the image from sRGB to CIEXYZ
rgb2xyz = cmatrix('srgb2xy') ;
imXYZ = changeColorSpace(imageInput, rgb2xyz);


%Different parameters etc. that is needed
cc = [1 2 4 8 16 32 64 128 256];%The different bands in spatial frequency
ss = size(imXYZ); %size of the image
fr = 0:256; %the frequency for the contrast threshold

%%%%%%%%%%%%%%%%%%%%%%%
%Y channel - Luminance%
%%%%%%%%%%%%%%%%%%%%%%%
O(:,:,1) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 1, 1); % the LR part
O(:,:,2) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 1, 0);
O(:,:,3) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 2, 0);
O(:,:,4) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 3, 0);
O(:,:,5) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 4, 0);
O(:,:,6) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 5, 0);
O(:,:,7) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 6, 0);
O(:,:,8) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 7, 0);
O(:,:,9) = octavefilter(imXYZ(:,:,2), PixelsPerDegree, 8, 2); %HR part

for i=2:9   
   YL(:,:,i-1) = sum(O(:,:,1:i-1),3); %Lowpass information
   YB(:,:,i) = O(:,:,i); %Bandpass information
end

%ContrastTreshold for Luminance from Peli 2001 (fig 1)
LuminanceContrastThreshold = 0.00033.*fr.^3 - 0.0026.*fr.^2+0.0067.*fr+0.013;


%Other Luminance CSFs below /NOT USED
%LuminanceContrastThreshold= 75.*fr.^(0.8).*exp(-0.2.*fr); %S-CIELAB
%LuminanceContrastThreshold= LuminanceContrastThreshold./max(max(LuminanceContrastThreshold)); %S-CIELAB

%%%ContrastTreshold for Luminance from Daly 1993
%a = 0.801*(1+(0.7./CperM2)).^(-0.2);
%b = 0.3*(1+(100./CperM2)).^(0.15);
%epsilon = 0.9;%frequency scaling constant
%LuminanceContrastThreshold = ((((3.23.*(((fr.^2).*ss(2)).^(-0.3))).^(5))+1).^(-0.2)) .* (a.*epsilon.*fr.*exp(-(b.*epsilon.*fr)).*sqrt((1+0.06.*exp(b.*epsilon.*fr))));

%Barten 1990
%a = 440.*(1 + (0.7./CperM2)).^(0.2);
%b = 0.3.*(1 + (100./CperM2)).^(0.15);
%LuminanceContrastThreshold = a.*fr.*exp(-b.*fr).*(sqrt(1+0.06.*exp(b.*fr)))

%W_SNR CSF
%LuminanceContrastThreshold=2.6*(0.0192+0.114*fr).*exp(-(0.114*fr).^1.1);
%f=find(fr<7.8909); LuminanceContrastThreshold(f)=0.9809+zeros(size(f));


%Performing the filtering
filteredImage = O(:,:,1); %Setting the first part of the image, which is the information below the first band
for i=1:ss(1)
    for j=1:ss(2)
        for jj=2:1:8
            if((abs(O(i,j,jj)./sum(O(i,j,1:jj-1)))) > LuminanceContrastThreshold(cc(jj-1))) %checking if the contrast in one pixel in a band is above the contrast threshold
                filteredImage(i,j) = filteredImage(i,j) + O(i,j,jj); %Adding the band information of the pixel to the filtered image
            end
        end
    end
end
ResultingImage(:,:,2) = filteredImage;%Putting the filtered image into the resulting image

%%%%%%%%%%%%%%%%%%%
%X channel - Color%
%%%%%%%%%%%%%%%%%%%
O(:,:,1) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 1, 1);
O(:,:,2) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 1, 0);
O(:,:,3) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 2, 0);
O(:,:,4) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 3, 0);
O(:,:,5) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 4, 0);
O(:,:,6) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 5, 0);
O(:,:,7) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 6, 0);
O(:,:,8) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 7, 0);
O(:,:,9) = octavefilter(imXYZ(:,:,1), PixelsPerDegree, 8, 2);

for i=2:9   
   XL(:,:,i-1) = sum(O(:,:,1:i-1),3); %setting the lowpass information for each band
   XB(:,:,i) = O(:,:,i); %Extracting the bandpass information 
end

XBL(:,:,1:8) = (XL(:,:,1:8)./YL(:,:,1:8)).*YB(:,:,1:8); %calculating the bandpass lightness information in the X channel
XBC(:,:,1:8) = XB(:,:,1:8) - ((XL(:,:,1:8)./YL(:,:,1:8)).*YB(:,:,1:8)); %Calculating the color information in the X channel
CXL(:,:,1:8) = XBL(:,:,1:8)./XL(:,:,1:8); %Finding the contrast in the X channel (the full signal divided by the lowpass information)
CXC(:,:,1:8) = XBC(:,:,1:8)./XL(:,:,1:8); %Color

%Variables for the contrast threshold
a1 = 109.1413; b1 = -0.00038; c1 = 3.42436;
a2 = 93.59711; b2 = -0.00367; c2 = 2.16771;

%Creating the contrast threshold for X
ColorContrastThreshold = 1./(a1.*exp(b1.*fr.^c1) + a2.*exp(b2.*fr.^c2));

%Performing the filtering
finalXBL = O(:,:,1); %The first information in the X channel for the bandpass luminance information is the first bandpass filtered image .
finalXBC=zeros(ss(1),ss(2)); %Setting the XBC part 
for i=1:ss(1)
    for j=1:ss(2)
        for jj=2:1:8
            if(abs(CXL(i,j,jj)) > LuminanceContrastThreshold(cc(jj-1))) %Contrast for the bandpass luminance is the current luminance information in the current band divided bu the lowpass of the same signal
              finalXBL(i,j) = finalXBL(i,j) + XBL(i,j,jj);
            end
            if(abs(CXC(i,j,jj)) > ColorContrastThreshold(cc(jj-1))) %contrast for the color information
              finalXBC(i,j) = finalXBC(i,j) + XBC(i,j,jj);
            end
        end
    end
end
ResultingImage(:,:,1) = (finalXBL + finalXBC);

%%%%%%%%%%%%%%%%%%%
%Z channel - Color%
%%%%%%%%%%%%%%%%%%%
O(:,:,1) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 1, 1);
O(:,:,2) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 1, 0);
O(:,:,3) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 2, 0);
O(:,:,4) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 3, 0);
O(:,:,5) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 4, 0);
O(:,:,6) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 5, 0);
O(:,:,7) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 6, 0);
O(:,:,8) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 7, 0);
O(:,:,9) = octavefilter(imXYZ(:,:,3), PixelsPerDegree, 8, 2);

for i=2:9   
   ZL(:,:,i-1) = sum(O(:,:,1:i-1),3); %setting the lowpass information for each band
   ZB(:,:,i) = O(:,:,i); %Extracting the bandpass information 
end

ZBL(:,:,1:8) = (ZL(:,:,1:8)./YL(:,:,1:8)).*YB(:,:,1:8); %calculating the bandpass lightness information in the X channel
ZBC(:,:,1:8) = ZB(:,:,1:8) - ((ZL(:,:,1:8)./YL(:,:,1:8)).*YB(:,:,1:8)); %Calculating the color information in the X channel
CZL(:,:,1:8) = ZBL(:,:,1:8)./ZL(:,:,1:8); %Finding the cintrast in the X channel (the full signal divided by the lowpass information)
CZC(:,:,1:8) = ZBC(:,:,1:8)./ZL(:,:,1:8);

%Variables for the contrast threshold
a1 = 7.0328; b1 = 0; c1 = 4.2582;
a2 = 40.6910; b2 = -0.1039; c2 = 1.6487;

%Creating the contrast threshold for Z
ColorContrastThreshold = 1./(a1.*exp(b1.*fr.^c1) + a2.*exp(b2.*fr.^c2));


%Performing the filtering
finalZBL=zeros(ss(1),ss(2));
finalZBL = O(:,:,1); %The first information in the Z channel for the bandpass luminance information is the first bandpass filtered image .
finalZBC=zeros(ss(1),ss(2));
for i=1:ss(1)
    for j=1:ss(2)
        for jj=2:1:8
               if(abs(CZL(i,j,jj)) > LuminanceContrastThreshold(cc(jj-1))) %Contrast for the bandpass luminance is the current luminance information in the current band divided bu the lowpass of the same signal 
                    finalZBL(i,j) = finalZBL(i,j) + ZBL(i,j,jj);
               end
               if(abs(CZC(i,j,jj)) > ColorContrastThreshold(cc(jj-1)))
                    finalZBC(i,j) = finalZBC(i,j) + ZBC(i,j,jj);
               end
        end
    end
end
ResultingImage(:,:,3) = (finalZBL + finalZBC);
ContrastFilteredImage = ResultingImage;

%Just for showing the filtered image
xyz2opp = cmatrix('xyz2srg') ;
ContrastFilteredImage2 = changeColorSpace(ResultingImage, xyz2opp);

%Showing the filtered image
% imshow(ContrastFilteredImage2);
% title(['Filtered color image at ', num2str(PixelsPerDegree) , ' pixels per degree.']);
% imwrite(ContrastFilteredImage2,'lena2m.tif','tiff')
% figure;
% %showing the original image
% imshow(imageInput);
% title('Original')