// This file is part of Jimlab,  
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jtype = jimtype(image)
    // image: jimage object or matrix or hypermatrix of numbers
    // jtype : "gray" | "rgb" | "rgba"

    // Cheking the input
    if typeof(image)~="jimage"  & ~or(type(image)==[1 4 8]) & ..
            ~(typeof(image)=="hypermat" & or(type(image(1))==[1 4 8]))
        msg = _("%s: Argument #%d: Jimage, booleans or numbers expected.\n");
        error(msprintf(msg, "jimtype", 1));
    end

    // Preprocessing
    if typeof(image)=="jimage"
        image = image.image;
    else
        image = jimstandard(image);
    end
    
    // Output
    tmp = ["gray" "" "rgb" "rgba"];
    jtype = tmp(size(image,3));
endfunction
