# Poisson Blending

## Toy Problem

In this section, the image "toy_problem.png" will be reconstructed by matching x and y gradients and one pixel.  
The pixels are mapped to variable using the variable `im2var`.
As recommended in the assignment sheet, `sparse` funciton is used to initialize large variable 

```matlab
toy_img = imread('data/toy_problem.png');
toy_double = im2double(toy_img);

[H, W, C] = size(toy_img);

im2var = zeros(H, W);
im2var(1:H*W) = 1:H*W;

A = sparse((H-1)*W+(W-1)*H, H * W);
b = zeros(H*W, C);
e = 1;
```

After initializing the variables, the difference between the x-gradients of v and the x-gradients of s is calculated
```matlab
for y=1:H
    for x=1:W-1
        A(e, im2var(y, x+1)) = 1;
        A(e, im2var(y, x)) = -1;
        b(e) = toy_double(y, x+1) - toy_double(y, x);
        e = e + 1;
    end
end
```

Using the same method the difference between the y-gradients of v and the x-gradients of s is calculated
```matlab
for x=1:W
    for y=1:H-1
        A(e, im2var(y+1, x)) = 1;
        A(e, im2var(y, x)) = -1;
        b(e) = toy_double(y+1, x) - toy_double(y, x);
        e = e + 1;
    end
end
```

We use `lscov` function to solve least square problem to obtain `v`. 
Once `v` is computed, `v` is reshaped as an reconstructed image.
```matlab
A(e, im2var(1,1)) = 1;
b(e) = toy_double(1,1);

v = lscov(A, b);
toy_recon = reshape(v, [H, W]);

figure;
imshow(toy_recon);
```
