function s=%jimage_size(jimage)
    image = jimage.image;
    dim = size(image);
    s = dim([1 2]);
endfunction
