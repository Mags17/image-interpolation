function [ output_args ] = Conv_Interp(image_HighRes, test_Image, D, W)

    I = test_Image;
    class_of_I = class(test_Image);
    
    [x, y] = meshgrid(1:W/D);
    [xi, yi] = meshgrid(1:1/D:W/D);


    % nearest neighbour interpolation
    Up_Image_nearest = interp2(x,y,double(I),xi,yi,'nearest');
    Up_Image_nearest = padarray(Up_Image_nearest,[D-1 D-1],'replicate','post');
    Up_Image_nearest = cast(Up_Image_nearest,class_of_I);
    peaksnr_nearest = psnr(Up_Image_nearest,image_HighRes)
    imageDiff_nearest = uint8(abs(double(image_HighRes) - double(Up_Image_nearest)));


    % bilinear interpolation
    Up_Image_linear = interp2(x,y,double(I),xi,yi,'linear');
    Up_Image_linear = padarray(Up_Image_linear,[D-1 D-1],'replicate','post');
    Up_Image_linear = cast(Up_Image_linear,class_of_I);
    peaksnr_linear = psnr(Up_Image_linear,image_HighRes)
    imageDiff_linear = uint8(abs(double(image_HighRes) - double(Up_Image_linear)));


    % bicubic interpolation
    Up_Image_cubic = interp2(x,y,double(I),xi,yi,'cubic');
    Up_Image_cubic = padarray(Up_Image_cubic,[D-1 D-1],'replicate','post');
    Up_Image_cubic = cast(Up_Image_cubic,class_of_I);
    peaksnr_cubic = psnr(Up_Image_cubic,image_HighRes)
    imageDiff_cubic = uint8(abs(double(image_HighRes) - double(Up_Image_cubic)));


    % spline interpolation
    Up_Image_spline = interp2(x,y,double(I),xi,yi,'spline');
    Up_Image_spline = padarray(Up_Image_spline,[D-1 D-1],'replicate','post');
    Up_Image_spline = cast(Up_Image_spline,class_of_I);
    peaksnr_spline = psnr(Up_Image_spline,image_HighRes)
    imageDiff_spline = uint8(abs(double(image_HighRes) - double(Up_Image_spline)));

    
    imwrite(Up_Image_nearest,'images\Up_Image_nearest.bmp');
    imwrite(Up_Image_linear,'images\Up_Image_linear.bmp');
    imwrite(Up_Image_cubic,'images\Up_Image_cubic.bmp');
    imwrite(Up_Image_spline,'images\Up_Image_spline.bmp');
    
    figure
    subplot(2,2,1); imshow(Up_Image_nearest,[]);
    title('Nearest Neighbour Scaled Image');
    subplot(2,2,2); imshow(Up_Image_linear,[]);
    title('Bilinear Interpolation Scaled Image');
    subplot(2,2,3); imshow(Up_Image_cubic,[]);
    title('Bicubic Interpolation Scaled Image');
    subplot(2,2,4); imshow(Up_Image_spline,[]);
    title('Spline Interpolation Scaled Image');

    imwrite(imageDiff_nearest,'images\imageDiff_nearest.bmp');
    imwrite(imageDiff_linear,'images\imageDiff_linear.bmp');
    imwrite(imageDiff_cubic,'images\imageDiff_cubic.bmp');
    imwrite(imageDiff_spline,'images\imageDiff_spline.bmp');
    
    figure
    subplot(2,2,1); imshow(imageDiff_nearest,[]);
    title('Difference Image Linear Interpolation');
    subplot(2,2,2); imshow(imageDiff_linear,[]);
    title('Difference Image Bilinear Interpolation');
    subplot(2,2,3); imshow(imageDiff_cubic,[]);
    title('Difference Image Bicubic Interpolation');
    subplot(2,2,4); imshow(imageDiff_spline,[]);
    title('Difference Image Spline Interpolation');

end

