function [h,w]=%jimage_size(jimage)
    
    image = jimage.image;
    dim = size(image);
    if argn(1) == 1 then
        h = dim([1 2]);
    elseif argn(1) == 2 then
        h = dim(1);
        w = dim(2);
    end

endfunction
