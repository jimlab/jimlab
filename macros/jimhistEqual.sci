 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [equalizedJimage] = jimhistEqual(jimage)
     if (typeof(jimage) == "jimage" | typeof(jimage) == "hypermat" | ..
                                type(jimage) == 1 | type(jimage) == 8) 
        jim = typeof(jimage) == "jimage"
        if jim
            name = jimage.title;
            ext = jimage.format;
            jimage = jimage.image;
        end
        dim = size(jimage);
        gray = length(dim) == 2
        
        //'rgb' and 'rgba' encoded images must be converted into 'gray' encoded images
        if ~gray 
            jimage = jimconvert(jimage, 'gray');
        end
        
        [newLevel, ind] = jimhistEqual_level(jimage);
        //each pixel is assiciated with its new level
        equalizedJimage = newLevel(ind);
        //convertion into 8-bits unsigned intergers
        equalizedJimage = uint8(equalizedJimage)
        //
        equalizedJimage = matrix(equalizedJimage, dim(1), dim(2))
        
        if jim
            equalizedJimage = mlist(['jimage','image','encoding',..
                    'title','format'], equalizedJimage,'gray' , ..
                                                    name, ext);
        end
     else
        msg = _("%s: Argument #%d: M-list or encoded integer(s) of type (%s) "..
        + "or %s expected.\n");
        error(msprintf(msg,"jimhistEqual",1,"uint8","hypermet"));
     end
 endfunction

function [newLevel, ind] = jimhistEqual_level(im)
//This sub-function returns the new levels of an image after histogram equalisation and the indice of each pixel. It is used by the function jimhistEqual()
//newLevel : an array with the new levels
//ind : The indice of each pixel
//im : a 2D matrix with the level of each pixel of an image from 0 to 255

    x = [0:1:256]
    data = double(im)
    [cf, ind] = histc(x, data, normalization = %t)
    tmp = 0
    for i = 1:length(cf)
        tmp = tmp + cf(i)
        newLevel(i) = tmp*255
    end
    
endfunction


