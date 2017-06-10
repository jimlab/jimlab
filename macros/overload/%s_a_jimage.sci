// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Jimage = %s_a_jimage(s, Jimage)
    // Adds a scalar or [r g b] vector or gray matrix or RGB hypermatrix of
    //  decimal numbers to a gray or colored image.
    // Jimage : jimage object in gray, RGB or RGBA.
    // s: Scalar, matrix or hypermatrix with 3 or 4 layers of decimal numbers.

    Jimage = Jimage + s;
endfunction
