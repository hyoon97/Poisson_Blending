function image_blended = Poisson_Blending(source, mask, target)

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
                b(e, :) = 4 * source(y, x, :) - source(y-1, x, :) - source(y+1, x, :) - source(y, x-1, :) - source(y, x+1, :);
            else
                A(e, im2var(y, x)) = 1;
                b(e, :) = target(y, x, :);
            end
            e = e + 1;
        end
    end

    v = lscov(A, b);
    image_blended = reshape(v, [H, W, C]);
end

