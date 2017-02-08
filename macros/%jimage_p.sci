function [] = %jimage_p(jimage)
    disp([ 'file name : ' + jimage.title + jimage.format; ['encoding : ' + ..
                                jimage.encoding]; 'size : ' + size(jimage))])
endfunction
