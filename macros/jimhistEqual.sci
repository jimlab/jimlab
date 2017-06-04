// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [equalizedJimage] = jimhistEqual(Jimage, ignoredTC)
	 //This function improves an image using histogram equalization. 
	 //Jimage : an object representing an image (jimage, matrix or hypermatrix)
	 //ignoredTC : a color that must be ignored in the algorithm, a scalar or a vector/hypermatrix in [0;255]
	 //equalizedJimage : improved image in gray levels encoded in uint8

     // test of the first argument
     if (typeof(Jimage) == "jimage") then
         //extraction of metadata from jimage object
         mime = Jimage.mime;
         name = Jimage.title;
         ext = "." + mime;
         Jimage = Jimage.image;
         jim = %t;
     else
         //conversion in uint8 if necessary, jimstandard() default values are used
         [Jimage, originalType] = jimstandard(Jimage);
         name = "your ";
         ext = "image";
         jim = %f;
         if (type(Jimage) == 4) then
             if (Jimage == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimhistEqual", 1));
            end
         end
     end

     //test of ignoredTC argument
     //must be a scalar or a vector/hypermatrix with 3 components
     //must in the intervalle [0:255]
     //must be converted into gray if a RGB ignoredTC is given
     if (isdef("ignoredTC","l") & type(ignoredTC) ~= 0) then
         if (length(ignoredTC) ~= 3. & length(ignoredTC) ~= 1.)
             msg = _("%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n");
             error(msprintf(msg,"jimhistEqual", 2));
         elseif length(ignoredTC) == 3.
             for i = 1:3
                 if (ignoredTC(i) > 255 | ignoredTC(i) < -1)
                    msg = _("%s: Argument #%d: Components of ignoredTC must be in the intervalle [0:255].\n");
                    error(msprintf(msg,"jimhistEqual", 2));
                 end
             end
             ignoredTC = 0.299 .* ignoredTC(1) + ..
                0.587 .* ignoredTC(2) + 0.114 .* ignoredTC(3);
         end
         if (ignoredTC > 255 | ignoredTC < -1)
             msg = _("%s: Argument #%d: Components of ignoredTC must be in the intervalle [0:255].\n");
             error(msprintf(msg,"jimhistEqual", 2));
         end
     else
         ignoredTC = -1;
     end

     dim = size(Jimage);
     gray = length(dim) == 2;
     ignoredTC = int16(ignoredTC);

     //"rgb" and "rgba" encoded images must be converted into "gray" encoded images
     if ~gray
        if (ignoredTC ~= -1)
            Jimage = jimconvert(Jimage, "gray", ignoredTC);
        else
            Jimage = jimconvert(Jimage, "gray");
        end
     end

     [newLevel, ind] = jimhistEqual_level(Jimage, ignoredTC);

    //each pixel is assiciated with its new level
    equalizedJimage = newLevel(ind);
    //convertion into 8-bits unsigned intergers
    equalizedJimage = uint8(equalizedJimage);
    //formatting the data
    equalizedJimage = matrix(equalizedJimage, dim(1), dim(2));

    if jim
        equalizedJimage = mlist(["jimage","image","encoding",..
                    "title","mime","transparencyColor"], equalizedJimage,"gray" , ..
                                                name, mime, ignoredTC);
    end

 endfunction

function [newLevel, ind] = jimhistEqual_level(im, ignoredTC)
// This sub-function returns the new levels of an image after histogram  equalisation
// and the indice of each pixel. It is used by the function jimhistEqual()
// newLevel : an array with the new levels
// ind : The indice of each pixel
// im : a 2D matrix with the level of each pixel of an image from 0 to 255
// ignoredTC : a scalar which have to be ignored in the algorithm
	
	//histogram calculation
    x = [0:1:255]
    data = double(im)
    [cf, ind] = histc(x, data, normalization = %f)
    tmp = 0
    if (ignoredTC ~= -1) then
        ignoredTC = double(ignoredTC)
        // Ignoring the transparent pixels
        nPixels = length(find(ind ~= ignoredTC));
        for i = 1:length(cf)
            if i ~= ignoredTC
                tmp = tmp + cf(i)
                newLevel(i) = tmp*255 / nPixels;
            else
                newLevel(i) = ignoredTC;
            end
        end
    else
        for i = 1:length(cf)
            tmp = tmp + cf(i)
            newLevel(i) = tmp*255 / (size(ind,1)*size(ind,2));
        end
    end

endfunction
