// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Jimage = %hm_a_jimage(Jimage, s)
    // Adds a jimage to a cat(3,r,g,b) hypervector or to an hypermatrix.
    // Needed for Scilab 5.5. Unused with Scilab 6
    //
    // Jimage : jimage object in gray, RGB or RGBA.
    // s: hypermatrix with 3 or 4 layers of numbers.

    Jimage = %jimage_a_s(Jimage, double(s));

endfunction
