
I = imread('C:\Users\Andrew\Desktop\PHSX_503\th1-new-L.jpg');


S = uint8(zeros(size(I,1),size(I,2)));

figure
imshow(I);
figure
imhist(I);

total_sum = 0;
bins = 255;
num_pixels = size(I,1)*size(I,2);
frequency = zeros(256,1);
prob_freq = zeros(256,1);
prob_cum = zeros(256,1);
cum = zeros(256,1);
output = zeros(256,1);

for i=1:size(I,1)
    for j=1:size(I,2)
        tmp = I(i,j);
        frequency(tmp+1) = frequency(tmp+1)+1;
        prob_freq(tmp+1) = frequency(tmp+1)/num_pixels;
    end
end

for i=1:size(prob_freq)
    total_sum = total_sum + frequency(i);
    cum(i) = total_sum;
    prob_cum(i) = cum(i)/num_pixels;
    output(i) = round(prob_cum(i)*bins);
end

for i=1:size(I,1)
    for j=1:size(I,2)
       S(i,j) = output(I(i,j)+1); 
    end
end

figure
imshow(S);
figure
imhist(S);
figure
imshow(R);