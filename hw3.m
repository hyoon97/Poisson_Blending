clear all; clc; close all;

addpath('./src')
%% Toy Problem
toy_img = imread('data/toy_problem.png');
toy_double = im2double(toy_img);

[H, W, C] = size(toy_img);

im2var = zeros(H, W);
im2var(1:H*W) = 1:H*W;

A = sparse((H-1)*W+(W-1)*H, H * W);
b = zeros(H*W, C);
e = 1;

for y=1:H
    for x=1:W-1
        A(e, im2var(y, x+1)) = 1;
        A(e, im2var(y, x)) = -1;
        b(e) = toy_double(y, x+1) - toy_double(y, x);
        e = e + 1;
    end
end

for x=1:W
    for y=1:H-1
        A(e, im2var(y+1, x)) = 1;
        A(e, im2var(y, x)) = -1;
        b(e) = toy_double(y+1, x) - toy_double(y, x);
        e = e + 1;
    end
end

A(e, im2var(1,1)) = 1;
b(e) = toy_double(1,1);

v = lscov(A, b);
toy_recon = reshape(v, [H, W]);

figure;
imshow(toy_recon);

%% Poisson Blending
clear all; clc; close all;

addpath('./src')

hiking_img = imread('./data/hiking.jpg');
penguin1_img = imread('./data/penguin-chick.jpeg');
penguin2_img = imread('./data/penguin.jpg');

hiking_double = im2double(hiking_img);
penguin1_double = im2double(penguin1_img);
penguin2_double = im2double(penguin2_img);

hiking_resized = imresize(hiking_double, 0.25, 'bilinear');
penguin1_resized = imresize(penguin1_double, 0.25, 'bilinear');
penguin2_resized = imresize(penguin2_double, 0.25, 'bilinear');

penguin1_mask = getMask(penguin1_resized);
penguin2_mask = getMask(penguin2_resized);

[source1, mask1] = alignSource(penguin1_resized, penguin1_mask, hiking_resized);
image_blended1 = Poisson_Blending(source1, mask1, hiking_resized);

[source2, mask2] = alignSource(penguin2_resized, penguin2_mask, image_blended1);
image_blended2 = Poisson_Blending(source2, mask2, image_blended1);

figure;
imshow(image_blended2)

%% Blending with Mixed Gradients
clear all; clc; close all;

addpath('./src')

hiking_img = imread('./data/hiking.jpg');
penguin1_img = imread('./data/penguin-chick.jpeg');
penguin2_img = imread('./data/penguin.jpg');

hiking_double = im2double(hiking_img);
penguin1_double = im2double(penguin1_img);
penguin2_double = im2double(penguin2_img);

hiking_resized = imresize(hiking_double, 0.25, 'bilinear');
penguin1_resized = imresize(penguin1_double, 0.25, 'bilinear');
penguin2_resized = imresize(penguin2_double, 0.25, 'bilinear');

penguin1_mask = getMask(penguin1_resized);
penguin2_mask = getMask(penguin2_resized);

[source1, mask1] = alignSource(penguin1_resized, penguin1_mask, hiking_resized);
image_blended1 = Mix_Blending(source1, mask1, hiking_resized);

[source2, mask2] = alignSource(penguin2_resized, penguin2_mask, image_blended1);
image_blended2 = Mix_Blending(source2, mask2, image_blended1);

figure;
imshow(image_blended2)

%% My own

clear all; clc; close all;

addpath('./src')

desert_img = imread('./data/810 Arabian Sand Desert - D Olson.jpg');
shark_img = imread('./data/final_image00002-1.jpg');

desert_double = im2double(desert_img);
shark_double = im2double(shark_img);

desert_resized = imresize(desert_double, 0.15, 'bilinear');
shark_resized = imresize(shark_double, 0.5, 'bilinear');

shark_mask = getMask(shark_resized);

[source1, mask1] = alignSource(shark_resized, shark_mask, desert_resized);
image_poisson = Poisson_Blending(source1, mask1, desert_resized);
image_mixed = Mix_Blending(source1, mask1, desert_resized);


figure;
imshow(image_poisson)
figure;
imshow(image_mixed)
