function [ rec_Image ] = Wzp(im_HighRes, im_Test, D, W)

    mode= 'sym';        %symmetric mode for DWT
    dwtmode(mode);
    wname = 'haar';%'db9';
    
    temp_Image = im_Test;
    iter = log2(D);
 k = W/D;
    for i = 1:iter
        cH = zeros(k*2^(i-1));
        cV = zeros(k*2^(i-1));
        cD = zeros(k*2^(i-1));
        temp_Image = idwt2(temp_Image,cH,cV,cD,wname);
    end 


    % map recovered image intensities in between 0 to 255
    max_temp = max(max(temp_Image));
    min_temp = min(min(temp_Image));

    max_test = 255;%max(max(double(I))) * 1.05
    min_test = 0;%min(min(double(I))) * 0.95

    K = (max_test - min_test) / (max_temp - min_temp);

    rec_Image = min_test + K * (temp_Image - min_temp);
    rec_Image = cast(rec_Image,'uint8');
    peaksnr_Wzp = psnr(rec_Image,im_HighRes)
    imageDiff_Wzp = uint8(abs(double(im_HighRes) - double(rec_Image)));
   
    imwrite(rec_Image,'images\WZP_Image.bmp');
    imwrite(imageDiff_Wzp,'images\imageDiff_Wzp.bmp');
    
    
    figure
    subplot(1,3,1); imshow(im_HighRes,[]);
    title('Ground Truth Image');
    subplot(1,3,2); imshow(rec_Image,[]);
    title('WZP Scaled Image');
    subplot(1,3,3); imshow(imageDiff_Wzp,[]);
    title('Difference Image WZP SR');

end

