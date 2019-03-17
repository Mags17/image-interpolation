clc; 
clear all;
close all;

% Load the high resolution image
imageFolder = 'images';         
targetImage = 'bday.bmp';%'step.bmp';%'bday.bmp';%'man.bmp';%'X1.bmp';%'square.bmp';%'lena512.bmp';%'mandril_gray.tif';%'livingroom.tif';%'cameraman.tif';%'lena512.bmp';
targetImage = strcat(imageFolder, '\', targetImage);    %image path & name
image_HighRes = imread(targetImage);  % high resolutiom image
[W, H] = size(image_HighRes);     % width & height of image
%***********************************************************************


D = 4;              % up/downsampling factor


%test_Image = image_HighRes(1:D:end,1:D:end);  % downsample the image


% form a low resolution image
mode= 'sym';        %symmetric mode for DWT
dwtmode(mode);
wname = 'haar';%'db9';

cA1 = image_HighRes;
for i = 1:log2(D)
    [cA1,cH,cV,cD] = dwt2(cA1,wname);   % downsample using DWT
end
mMax = max(max(cA1));
mMin = min(min(cA1));

test_Image = 255 * (cA1 - mMin) / (mMax - mMin); % map values in between 0 & 255 

class_of_I = class(image_HighRes);
test_Image = cast(test_Image,class_of_I);   % final low resolution image
imwrite(test_Image,'images\down_Image.bmp');
%*************************************************************************

figure
subplot(2,1,1); imshow(image_HighRes,[]);
title(['Original Image size ',num2str(W),' X ',num2str(H)])
subplot(2,1,2); imshow(test_Image,[]);
title(['Downsampled Image by factor ',num2str(D)]);


Conv_Interp(image_HighRes, test_Image, D, W);
DwtSR(image_HighRes, test_Image, D, W);
recImage_DwtSwt = Dwt_SwtSR(image_HighRes, test_Image, D, W);
recImage_Wzp = Wzp(image_HighRes, test_Image, D, W);
recImage_WzpCs = Wzp_Cs(image_HighRes, test_Image, D, W);

CombImg_DwtSwt_Wzp = (uint16(recImage_DwtSwt) + uint16(recImage_Wzp))/2;
CombImg_DwtSwt_Wzp = cast(CombImg_DwtSwt_Wzp,'uint8');
peaksnr_comb_DwtSwt_Wzp = psnr(CombImg_DwtSwt_Wzp,image_HighRes)
imageDiff_combined = uint8(abs(double(image_HighRes) - double(CombImg_DwtSwt_Wzp)));


imwrite(CombImg_DwtSwt_Wzp,'images\CombImg_DwtSwt_Wzp.bmp');
imwrite(imageDiff_combined,'images\imageDiff_combined_DwtSwt_Wzp.bmp');
    
figure
subplot(1,3,1); imshow(image_HighRes,[]);
title('Input Image');
subplot(1,3,2); imshow(CombImg_DwtSwt_Wzp,[]);
title('WZP-DWT-SWT Scaled Image');
subplot(1,3,3); imshow(imageDiff_combined,[]);
title('Difference Image Combined SR');

CombImg_DwtSwt_WzpCs = (uint16(recImage_DwtSwt) + uint16(recImage_WzpCs))/2;
CombImg_DwtSwt_WzpCs = cast(CombImg_DwtSwt_WzpCs,'uint8');
peaksnr_comb_DwtSwt_WzpCs = psnr(CombImg_DwtSwt_WzpCs,image_HighRes)
imageDiff_combined = uint8(abs(double(image_HighRes) - double(CombImg_DwtSwt_WzpCs)));

imwrite(CombImg_DwtSwt_WzpCs,'images\CombImg_DwtSwt_WzpCs.bmp');
imwrite(imageDiff_combined,'images\imageDiff_combined_DwtSwt_WzCsp.bmp');

figure
subplot(1,3,1); imshow(image_HighRes,[]);
title('Input Image');
subplot(1,3,2); imshow(CombImg_DwtSwt_WzpCs,[]);
title('WZP-CS-DWT-SWT Scaled Image');
subplot(1,3,3); imshow(imageDiff_combined,[]);
title('Difference Image Combined SR');
