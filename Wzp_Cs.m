function [ WZP_CSImage ] = Wzp_Cs(im_HighRes, im_Test, D, W)

    mode= 'sym';        %symmetric mode for DWT
    dwtmode(mode);
    wname = 'haar';%'db9';
    
    temp_Image1 = im_Test;
    iter = log2(D);
    k = W/D;
    num_Shift = 2;
    
    for i = 1:iter
        cH = zeros(k*2^(i-1));
        cV = zeros(k*2^(i-1));
        cD = zeros(k*2^(i-1));
        temp_Image1 = idwt2(temp_Image1,cH,cV,cD,wname);
    end 


    % map recovered image intensities in between 0 to 255
    max_temp = max(max(temp_Image1));
    min_temp = min(min(temp_Image1));

    max_test = 255;%max(max(double(I))) * 1.05
    min_test = 0;%min(min(double(I))) * 0.95

    K = (max_test - min_test) / (max_temp - min_temp);

    WZP_Image = min_test + K * (temp_Image1 - min_temp);
    WZP_Image = cast(WZP_Image,'uint8');
    
    i = 0;
    for a = -num_Shift:1:num_Shift
        for b = -num_Shift:1:num_Shift
            
            i =i+1;
            im_shifted{i} = circshift(WZP_Image,[a b]);   
        end
    end
    
    for a = 1:i
       [A,H,V,D] = dwt2(im_shifted{a},wname);   % downsample using DWT 
       cA{a} = A;
       temp_Image2{a} = idwt2(cA{a},cH,cV,cD,wname);
    end
    
    i = 0;
    for a = num_Shift:-1:-num_Shift
        for b = num_Shift:-1:-num_Shift
            
            i =i+1;
            temp_Image2{i} = circshift(temp_Image2{i},[a b]);   
        end
    end
    
    
    rec_Image = zeros(W);
    for a = 1:i
        image = temp_Image2{1,a};
        rec_Image =  image + rec_Image;
    end
    
    rec_Image = rec_Image/i;
    
    % map recovered image intensities in between 0 to 255
    max_temp = max(max(rec_Image));
    min_temp = min(min(rec_Image));

    max_test = 255;%max(max(double(I))) * 1.05
    min_test = 0;%min(min(double(I))) * 0.95

    K = (max_test - min_test) / (max_temp - min_temp);

    WZP_CSImage = min_test + K * (rec_Image - min_temp);
    WZP_CSImage = cast(WZP_CSImage,'uint8');
        
      
    peaksnr_WzpCs = psnr(WZP_CSImage,im_HighRes)
    imageDiff_WzpCs = uint8(abs(double(im_HighRes) - double(WZP_CSImage)));
    
    imwrite(WZP_CSImage,'images\WZP_CSImage.bmp');
    imwrite(imageDiff_WzpCs,'images\imageDiff_WzpCs.bmp');
    
    figure
    subplot(1,3,1); imshow(im_HighRes,[]);
    title('Ground Truth Image');
    subplot(1,3,2); imshow(WZP_CSImage,[]);
    title('WZP-CS Scaled Image');
    subplot(1,3,3); imshow(imageDiff_WzpCs,[]);
    title('Difference Image WZP-CS SR');


end

