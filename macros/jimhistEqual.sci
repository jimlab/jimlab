 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [equalizedJimage] = jimhistEqual(jimage, transparencyColor, varargin)
     
     //test of transparencyColor argument
     //must in the intervalle [0:255]
     if (isdef('transparencyColor',"l") & type(transparencyColor) ~= 0) then
         if (size(transparencyColor, 3) ~= 3. & size(transparencyColor) ~= 1.)
             msg = _("%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n");
             error(msprintf(msg,"jimconvert", 3));
         end
         if (size(transparencyColor, 3) == 3.)
             transparencyColor = 0.299 .* transparencyColor(:,:,1) + ..
        0.587 .* transparencyColor(:,:,2) + 0.114 .* transparencyColor(:,:,3);
         end
         if (transparencyColor > 255 | transparencyColor < 0)
             msg = _("%s: Argument #%d: Components of transparencyColor must be in the intervalle [0:255].\n");
             error(msprintf(msg,"jimconvert", 3));
         end
     else
         transparencyColor = -1;
     end
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(jimage) == "jimage") then
           mime = jimage.mime;
           name = jimage.title;
           if jimage.encoding ~= 'gray'
               jimage = jimconvert(jimage, 'gray')
           end
           transparencyColor = jimage.transparencyColor;
           ext = '.' + mime;
           jimage = jimage.image;
           jim = %t;
     else 
         [jimage, originalType] = jimstandard(jimage, varargin(:));
         name = 'your ';
         ext = 'image';
         jim = %f;
         if (type(jimage) == 4) then
             if (jimage == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimhistEqual", 1));
            end
         end
         dim = size(jimage);
         gray = length(dim) == 2
        
         //'rgb' and 'rgba' encoded images must be converted into 'gray' encoded images
         if ~gray 
             jimage = jimconvert(jimage, 'gray', transparencyColor);
         end
     end

    
    if transparencyColor == -1 then
        [newLevel, ind] = jimhistEqual_level(jimage);
    else
        [newLevel, ind] = jimhistEqual_level(jimage, transparencyColor);
    end

    //each pixel is assiciated with its new level
    equalizedJimage = newLevel(ind);
    //convertion into 8-bits unsigned intergers
    equalizedJimage = uint8(equalizedJimage)
    //formatting the data
    equalizedJimage = matrix(equalizedJimage, dim(1), dim(2))
        
    if jim
        equalizedJimage = mlist(['jimage','image','encoding',..
                    'title','mime','transparencyColor'], equalizedJimage,'gray' , ..
                                                name, mime, transparencyColor);
    end

 endfunction

function [newLevel, ind] = jimhistEqual_level(im, transparencyColor)
//This sub-function returns the new levels of an image after histogram equalisation and the indice of each pixel. It is used by the function jimhistEqual()
//newLevel : an array with the new levels
//ind : The indice of each pixel
//im : a 2D matrix with the level of each pixel of an image from 0 to 255
//transparencyColor : a scalar which habe to be ignored in the algorithm

    x = [0:1:256]
    data = double(im)
    [cf, ind] = histc(x, data, normalization = %t)
    tmp = 0
    if (isdef('transparencyColor',"l") & type(transparencyColor) ~= 0) then
        transparencyColor = double(transparencyColor)
        for i = 1:length(cf)
            if i ~= transparencyColor
                tmp = tmp + cf(i)
                newLevel(i) = tmp*255
            end
        end
    else
        for i = 1:length(cf)
            tmp = tmp + cf(i)
            newLevel(i) = tmp*255
        end
    end
        
endfunction


