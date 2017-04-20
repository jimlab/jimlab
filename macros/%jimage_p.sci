function [] = %jimage_p(jimage)
    //This function overloads disp(). 
    //Title, encoding, mime type and size of the jimage object are displayed.
    
    image = jimage.image;
    dim = size(image);
    height = string(dim(1));
    width = string(dim(2));
    
    disp([ 'title : ' + jimage.title ; ['encoding : ' + ..
jimage.encoding ; ['MIME type : ' + jimage.mime ; ['size : ' + width ..
                                                    + 'x' + height]]]])
endfunction

