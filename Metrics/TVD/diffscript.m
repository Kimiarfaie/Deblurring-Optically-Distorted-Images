
function [d]=diffscript(im_orig, im_gma,lam,nrm,TVopt,PixelsPerDegree)


[im_orig_xyz] = ColorContrastFiltering(im_orig,PixelsPerDegree);
[im_gma_xyz] = ColorContrastFiltering(im_gma,PixelsPerDegree);

% cform = makecform('srgb2xyz');
% im_orig_xyz = applycform(im_orig,cform); 
% im_gma_xyz = applycform(im_gma,cform);

%TO OSAUCS ORIGINAL
YYO=im_orig_xyz(:,:,2);
XYZO =sum(im_orig_xyz,3);
im_orig_xyz(:,:,1)=im_orig_xyz(:,:,1)./XYZO;
im_orig_xyz(:,:,2)=im_orig_xyz(:,:,2)./XYZO;
im_orig_xyz(:,:,3)=im_orig_xyz(:,:,3)./XYZO;

        
[Losa,LE,GE,JE]=XYZtoOSAlog_fullImage(im_orig_xyz(:,:,1),im_orig_xyz(:,:,2),im_orig_xyz(:,:,3),YYO);
 
clear im_orig
im_orig(:,:,1) = LE;
im_orig(:,:,2) = GE;
im_orig(:,:,3) = JE;

%TO OSAUCS GMA
YYR=im_gma_xyz(:,:,2);
XYZR =sum(im_gma_xyz,3);
im_gma_xyz(:,:,1)=im_gma_xyz(:,:,1)./XYZR;
im_gma_xyz(:,:,2)=im_gma_xyz(:,:,2)./XYZR;
im_gma_xyz(:,:,3)=im_gma_xyz(:,:,3)./XYZR;

[Losa,LE,GE,JE]=XYZtoOSAlog_fullImage(im_gma_xyz(:,:,1),im_gma_xyz(:,:,2),im_gma_xyz(:,:,3),YYR);

clear im_gma
im_gma(:,:,1) = LE;
im_gma(:,:,2) = GE;
im_gma(:,:,3) = JE;

d = tvdiff(im_orig, im_gma, lam, nrm,TVopt);
%disp(['Difference ', num2str(d)]); 
