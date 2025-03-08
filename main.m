clc;
clear all;
close all;


img = imread('./image/8.jpg');
figure,imshow(img),title('original image');

% red channel recover
img1 = redCompensate(img,5);
figure, subplot(2,2,1)
imshow(img1);
xlabel('red channel compensate');


% white balance enhancement
img2 = simple_color_balance(img1);
subplot(2,2,2)
imshow(img2);
xlabel('white balance');

% gamma correction
input_1 = gammaCorrection(img2,1,1.2);
subplot(2,2,3)
imshow(input_1);
xlabel('gamma correction');

% sharpen
input_2 = sharp(img2);
subplot(2,2,4)
imshow(input_2);
xlabel('sharp');

%.................................................%
% calculate weight
%.................................................%
labr1 = rgb_to_lab(input_1);
labr2 = rgb_to_lab(input_2);
RI1 = double(labr1(:, :, 1)/255);
RI2 = double(labr2(:, :, 1)/255);

% 1. Laplacian contrast weight
WLC1 = abs(imfilter(RI1, fspecial('Laplacian'), 'replicate', 'conv')); 
WLC2 = abs(imfilter(RI2, fspecial('Laplacian'), 'replicate', 'conv')); 

% 2. Saliency weight
WSC1 = saliency_detection(input_1);
WSC2 = saliency_detection(input_2);

% 3. Saturation weight
WSatimg1 = Saturation_weight(input_1);
WSatimg2 = Saturation_weight(input_2);

% normalized weight
[W1, W2] = norm_weight(WLC1, WSC1, WSatimg1, WLC2 , WSC2, WSatimg2);

%.................................................%

%.................................................%
level = 3;

% weight gaussian pyramid
Weight_g1 = gaussian_pyramid(W1, level);
Weight_g2 = gaussian_pyramid(W2, level);


% input1
r_img1 = laplacian_pyramid(double(double(input_1(:, :, 1))), level);
g_img1 = laplacian_pyramid(double(double(input_1(:, :, 2))), level);
b_img1 = laplacian_pyramid(double(double(input_1(:, :, 3))), level);
% input2
r_img2 = laplacian_pyramid(double(double(input_2(:, :, 1))), level);
g_img2 = laplacian_pyramid(double(double(input_2(:, :, 2))), level);
b_img2 = laplacian_pyramid(double(double(input_2(:, :, 3))), level);

% Enhancement
for i = 1 : level
    R_r{i} = Weight_g1{i} .* r_img1{i} + Weight_g2{i} .* r_img2{i};
    G_g{i} = Weight_g1{i} .* g_img1{i} + Weight_g2{i} .* g_img2{i};
    B_b{i} = Weight_g1{i} .* b_img1{i} + Weight_g2{i} .* b_img2{i};
end

% image reconstruct
R_img = pyramid_reconstruct(R_r);
G_img = pyramid_reconstruct(G_g);
B_img = pyramid_reconstruct(B_b);

restore = cat(3, R_img,G_img,B_img);
iqm = IQM(restore)
irqe = IRQE(restore)

figure,imshow(restore),title('Restored Image');


