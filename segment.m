%iGrowney_Analysis('C:\Users\Andrew\Desktop\PHSX_503\thunknown.jpg');

function Growney_Analysis(filepath)
    %% Read In Image
    img_input = imread(filepath);


    %% Segment Image L/R
    n_1 = fix(size(img_input,2)/2);
    left_seg = img_input(:,1:n_1,:);
    right_seg = img_input(:,n_1+1:end,:);

    %% Show Segmented Images

    figure;
    subplot(1,2,1)
    imshow(left_seg);
    subplot(1,2,2)
    imshow(right_seg);

    %% Use Edge Detection to determine best method

    left_gray = rgb2gray(left_seg);
    right_gray = rgb2gray(right_seg);

    [l_edge1,l_edge2,l_edge3] = edgeImg(left_gray);
    [r_edge1,r_edge2,r_edge3] = edgeImg(right_gray);

    %% Determine Entropy of Each side

    left_entropy = entropy(left_gray);
    right_entropy = entropy(right_gray);
    %l_kurt_1 = kurtosis(left_gray_1);
    %r_kurt_1 = kurtosis(right_gray_1);

    %% Find average RGB Values to determine if valuable

    [left_red,left_green,left_blue] = getRGB(left_seg);
    [right_red,right_green,right_blue] = getRGB(right_seg);


    %% Select Red data to analyze and Isolate Cases

    figure;

    subplot(2,2,1)
    imhist(left_red);
    subplot(2,2,3)
    imshow(left_red);

    subplot(2,2,2)
    imhist(right_red);
    subplot(2,2,4)
    imshow(right_red);


    for i= 1:size(right_red,1)
        for j = 1:size(right_red,2)
            if(right_red(i,j,1) > 230)
                right_red(i,j,1) = 0;
            end
        end
    end
    figure;
    imshow(right_red);


    % Masking

    [full_analysis_left] = img_analysis(left_seg);
    [full_analysis_right] = img_analysis(right_seg);

    figure;
    subplot(2,2,1)
    imshow(full_analysis_left);
    subplot(2,2,2)
    imshow(full_analysis_right);
    subplot(2,2,3)
    imshow(left_seg);
    subplot(2,2,4)
    imshow(right_seg);

    %% Sorenson Dice Method
    figure;
    imshow(right_gray);
    bw_gray = imbinarize(right_gray);

    mask =  false(size(right_gray));
    mask(25:end-25,25:end-25) = true;
    BW = activecontour(right_gray,mask);
    similarity = dice(bw_gray, BW);
    figure
    imshowpair(right_gray,BW);

end


%% Functions Used 
function[e_sob,e_can,e_prew] = edgeImg(img_in)
    e_sob = edge(img_in,'Sobel');
    e_can = edge(img_in,'Canny');
    e_prew = edge(img_in,'Prewitt');
    e_rob = edge(img_in, 'Roberts');
    e_lap = edge(img_in, 'log');
    figure;
    subplot(1,5,1)
    imshow(e_sob);
    subplot(1,5,2)
    imshow(e_can);
    subplot(1,5,3)
    imshow(e_prew);
    subplot(1,5,4)
    imshow(e_rob);
    subplot(1,5,5)
    imshow(e_lap);
end

function [R,G,B] = getRGB(img_in)
    I_r = img_in(:,:,1);
    I_g = img_in(:,:,2);
    I_b = img_in(:,:,3);
    R = I_r;
    G = I_g;
    B = I_b;
    figure
    subplot(1,3,1);
    imshow(R);
    subplot(1,3,2);
    imshow(G);
    subplot(1,3,3);
    imshow(B);
    
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
    mask2 = (h > 0.2) & (h < 0.8);
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
