function image_blended = Mix_Blending(source, mask, target)

    [H, W, C] = size(source);
    
    im2var = zeros(H, W);
    im2var(1:H*W) = 1:H*W;

    A = sparse(H*W, H*W);
    b = zeros(H*W, C);
    e = 1;

    for y=1:H
        for x=1:W
            if mask(y, x) == 1
                A(e, im2var(y, x)) = 4;
                A(e, im2var(y-1, x)) = -1;
                A(e, im2var(y+1, x)) = -1;
                A(e, im2var(y, x-1)) = -1;
                A(e, im2var(y, x+1)) = -1;
                
                d1 = 0;
                d2 = 0;
                d3 = 0;
                d4 = 0;
                
                grad_s = source(y, x, :) - source(y-1, x, :);
                grad_t = target(y, x, :) - target(y-1, x, :);
                if abs(grad_s) > abs(grad_t)
                    d1 = grad_s;
                else
                    d1 = grad_t;
                end
                
                grad_s = source(y, x, :) - source(y+1, x, :);
                grad_t = target(y, x, :) - target(y+1, x, :);
                if abs(grad_s) > abs(grad_t)
                    d2 = grad_s;
                else
                    d2 = grad_t;
                end
                
                grad_s = source(y, x, :) - source(y, x-1, :);
                grad_t = target(y, x, :) - target(y, x-1, :);
                if abs(grad_s) > abs(grad_t)
                    d3 = grad_s;
                else
                    d3 = grad_t;
                end
                
                grad_s = source(y, x, :) - source(y, x+1, :);
                grad_t = target(y, x, :) - target(y, x+1, :);
                if abs(grad_s) > abs(grad_t)
                    d4 = grad_s;
                else
                    d4 = grad_t;
                end
                
                b(e, :) = d1 + d2 + d3 + d4;
            else
                A(e, im2var(y, x)) = 1;
                b(e, :) = target(y, x, :);
            end
            e = e + 1;
        end
    end

    v = lscov(A, b);
    image_blended = reshape(v, [H, W, C]);
    
    figure;
    imshow(image_blended)
end

