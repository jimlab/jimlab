// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function image = jimnegative(image)
    //This function returns the negative of an image 
    //image : an object reprensenting an image (jimage, matrix or hypermatrix)
    //Mod_image : the negative of image
    
    if typeof(image) == "jimage"
        s = [size(image.image) 1];
        nC = s(3);
        if nC==4, nC = 3; end   // number of Channels out of the alpha one
        image.image(:,:,1:nC) = 255 - image.image(:,:,1:nC)
        if image.transparencyColor~=-1
            image.transparencyColor = 255 - image.transparencyColor;
        end
    else
        [image, originalType] = jimstandard(image);
        image = 255 - image;
    end
endfunction
