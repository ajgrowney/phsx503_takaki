clc; clear all ;
img = imread('C:\Users\Andrew\Desktop\PHSX_503\thermal1.png');
figure ; imshow(img);

% Segment the Image into Two Regions of Interest
n = fix(size(img,2)/2);
left_img = img(:,1:n,:);
right_img = img(:,n+1:end,:);


%Run Image Analysis Function
[updated_left] = img_analysis(left_img);
[updated_right] = img_analysis(right_img);

%Display Image Analysis Data
figure;
subplot(2,1,1)
imshow(updated_left);
subplot(2,1,2);
imhist(updated_left);

figure;
subplot(2,1,1);
imshow(updated_right);
subplot(2,1,2);
imhist(updated_right);

%Grab the RGB 'histogram'
[x_cor,y_red,y_green,y_blue] = rgb_hist(updated_left);
figure;
plot(x_cor,y_red,'Red',x_cor,y_green,'Green',x_cor,y_blue,'Blue');


%Function Defintions
function[x,yRed,yGreen,yBlue] = rgb_hist(img_in)
    Red = img_in(:,:,1);
    Green = img_in(:,:,2);
    Blue = img_in(:,:,3);
    [yRed,x] = imhist(Red);
    [yGreen,x] = imhist(Green);
    [yBlue,x] = imhist(Blue);

end

function [out] = img_analysis(img_in)
    % Convert RGB image into HSV color space.
    hsvImage = rgb2hsv(img_in);
    % Extract individual Hue, Saturation, and value images.
    h = hsvImage(:,:, 1);
    s = hsvImage(:,:, 2);
    v = hsvImage(:,:, 3);
    % Threshold to find vivid colors.
    mask = v < 0.5;
    % Threshold to find the correct hues
    mask2 = (h > 0.5) & (h < 0.8);
    % Make image white in value selection:
    h(mask) = 0;
    s(mask) = 0;
    v(mask) = 1;
    %Make image white in the hue selection
    h(mask2) = 0;
    s(mask2) = 0;
    v(mask2) = 1;

    % Convert back to RGB
    hsvImage = cat(3, h, s, v);
    newRGB = hsv2rgb(hsvImage);

    out = newRGB;
end

