function [] = %jimage_p(jimage)
    //This function overloads disp(). 
    //Title, encoding, mime type and size of the jimage object are displayed.
    
    image = jimage.image;
    dim = size(image);
    height = string(dim(1));
    width = string(dim(2));
    tColor = string(jimage.transparencyColor)
    
    if size(tColor, 3) == 3 then
        disp([ 'title : ' + jimage.title ; ['encoding : ' + jimage.encoding ; ..
 ['MIME type : ' + jimage.mime ; ['size : ' + width + 'x' + height ; ..
 ['transparency Color : ' + tColor(1) + ' ' + tColor(2) + ' ' + tColor(3)]]]]])
    else
        disp([ 'title : ' + jimage.title ; ['encoding : ' + ..
jimage.encoding ; ['MIME type : ' + jimage.mime ; ['size : ' + width ..
+ 'x' + height ; ['transparency Color : ' + tColor]]]]])
    end
    

endfunction

