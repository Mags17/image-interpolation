function [ output_args ] = DwtSR(im_HighRes, im_Test, D, W)

    mode= 'sym';        %symmetric mode for DWT
    dwtmode(mode);
    wname = 'haar';%'db9';
    
    [cA,cH,cV,cD] = dwt2(im_Test,wname); % DWT of test image

    figure
    subplot(2,2,1); imshow(cA,[]);
    title('Approximation');
    subplot(2,2,2); imshow(cH,[]);
    title('Horizontal Detail');
    subplot(2,2,3); imshow(cV,[]);
    title('Vertical Detail');
    subplot(2,2,4); imshow(cD,[]);
    title('Diagonal Detail');


    [x, y] = meshgrid(1:W/(2*D));
    [xi, yi] = meshgrid(1:1/D:W/(2*D));

    % bicubic interpolation of detail subbands
    Up_cH_cubic = interp2(x,y,double(cH),xi,yi,'cubic');
    Up_cH_cubic = padarray(Up_cH_cubic,[D-1 D-1],'replicate','post');

    Up_cV_cubic = interp2(x,y,double(cV),xi,yi,'cubic');
    Up_cV_cubic = padarray(Up_cV_cubic,[D-1 D-1],'replicate','post');

    Up_cD_cubic = interp2(x,y,double(cD),xi,yi,'cubic');
    Up_cD_cubic = padarray(Up_cD_cubic,[D-1 D-1],'replicate','post');


    [x, y] = meshgrid(1:W/D);
    [xi, yi] = meshgrid(1:2/D:W/D);

    % maxcA1 = max(max(cA1))
    % mincA1 = min(min(cA1))

    % map test image intensities to expected approximation coefficients
     maxcA = max(max(cA))*2;
     mincA = min(min(cA))*2;

     im_Test = cast(im_Test,'double');
     min_test = min(min(im_Test));
     max_test = max(max(im_Test)); 

     K = (maxcA - mincA) / (max_test - min_test); 
     im_Test = mincA + K*(im_Test - min_test);

    % bilinear interpolation of test image
    Up_cAnew_cubic = interp2(x,y,double(im_Test),xi,yi,'cubic');
    Up_cAnew_cubic = padarray(Up_cAnew_cubic,[(D/2)-1 (D/2)-1],'replicate','post');

    temp_Image = idwt2(Up_cAnew_cubic,Up_cH_cubic,Up_cV_cubic,Up_cD_cubic,wname);

    % map recovered image intensities in between 0 to 255
    max_temp = max(max(temp_Image));
    min_temp = min(min(temp_Image));

    max_test = 255;%max(max(double(I))) * 1.05
    min_test = 0;%min(min(double(I))) * 0.95

    K = (max_test - min_test) / (max_temp - min_temp);

    rec_Image = min_test + K * (temp_Image - min_temp);
    rec_Image = cast(rec_Image,'uint8');
    peaksnr_DWT = psnr(rec_Image,im_HighRes)
    imageDiff_DWT = uint8(abs(double(im_HighRes) - double(rec_Image)));
   
    imwrite(rec_Image,'images\Dwt_Image.bmp');
    imwrite(imageDiff_DWT,'images\imageDiff_DWT.bmp');
    
    
    figure
    subplot(1,3,1); imshow(im_HighRes,[]);
    title('Ground Truth Image');
    subplot(1,3,2); imshow(temp_Image,[]);
    title('DWT Scaled Image');
    subplot(1,3,3); imshow(imageDiff_DWT,[]);
    title('Difference Image DWT SR');

end

