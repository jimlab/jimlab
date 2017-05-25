// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [equalizedJimage] = jimhistEqual(Jimage, transparencyColor)

     // test of the first argument
     if (typeof(Jimage) == "jimage") then
         //extraction of metadata from jimage object
         mime = Jimage.mime;
         name = Jimage.title;
         ext = '.' + mime;
         // Priority for a transparencyColor explicitely given
         if (~isdef("transparencyColor", "l") | type(transparencyColor) == 0.)
            transparencyColor = Jimage.transparencyColor;
         end
         Jimage = Jimage.image;
         jim = %t;
     else
         //conversion in uint8 if necessary, jimstandard() default values are used
         [Jimage, originalType] = jimstandard(Jimage);
         name = 'your ';
         ext = 'image';
         jim = %f;
         if (type(Jimage) == 4) then
             if (Jimage == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimhistEqual", 1));
            end
         end
     end

     //test of transparencyColor argument
     //must be a scalar or a vector/hypermatrix with 3 components
     //must in the intervalle [0:255]
     //must be converted into gray if a RGB transparencyColor is given
     if (isdef('transparencyColor',"l") & type(transparencyColor) ~= 0) then
         if (length(transparencyColor) ~= 3. & length(transparencyColor) ~= 1.)
             msg1 = _("%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n");
             error(msprintf(msg1,"jimhistEqual", 2));
         elseif length(transparencyColor) == 3.
             transparencyColor = 0.299 .* transparencyColor(1) + ..
                0.587 .* transparencyColor(2) + 0.114 .* transparencyColor(3);
         end
         if (transparencyColor > 255 | transparencyColor < -1)
             msg2 = _("%s: Argument #%d: Components of transparencyColor must be in the intervalle [0:255].\n");
             error(msprintf(msg2,"jimhistEqual", 2));
         end
     else
         transparencyColor = -1;
     end

     dim = size(Jimage);
     gray = length(dim) == 2;
     transparencyColor = int16(transparencyColor);

     //'rgb' and 'rgba' encoded images must be converted into 'gray' encoded images
     if ~gray
        if (transparencyColor ~= -1)
            Jimage = jimconvert(Jimage, "gray", transparencyColor);
        else
            Jimage = jimconvert(Jimage, "gray");
        end
     end

     [newLevel, ind] = jimhistEqual_level(Jimage, transparencyColor);

    //each pixel is assiciated with its new level
    equalizedJimage = newLevel(ind);
    //convertion into 8-bits unsigned intergers
    equalizedJimage = uint8(equalizedJimage);
    //formatting the data
    equalizedJimage = matrix(equalizedJimage, dim(1), dim(2));

    if jim
        equalizedJimage = mlist(['jimage','image','encoding',..
                    'title','mime','transparencyColor'], equalizedJimage,'gray' , ..
                                                name, mime, transparencyColor);
    end

 endfunction

function [newLevel, ind] = jimhistEqual_level(im, transparencyColor)
// This sub-function returns the new levels of an image after histogram  equalisation
// and the indice of each pixel. It is used by the function jimhistEqual()
// newLevel : an array with the new levels
// ind : The indice of each pixel
// im : a 2D matrix with the level of each pixel of an image from 0 to 255
// transparencyColor : a scalar which have to be ignored in the algorithm

    x = [0:1:255]
    data = double(im)
    [cf, ind] = histc(x, data, normalization = %f)
    tmp = 0
    if (transparencyColor ~= -1) then
        transparencyColor = double(transparencyColor)
        // Ignoring the transparent pixels
        nPixels = length(find(ind ~= transparencyColor));
        for i = 1:length(cf)
            if i ~= transparencyColor
                tmp = tmp + cf(i)
                newLevel(i) = tmp*255 / nPixels;
            else
                newLevel(i) = transparencyColor;
            end
        end
    else
        for i = 1:length(cf)
            tmp = tmp + cf(i)
            newLevel(i) = tmp*255 / (size(ind,1)*size(ind,2));
        end
    end

endfunction
