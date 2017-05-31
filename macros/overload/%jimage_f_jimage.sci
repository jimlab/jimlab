// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimageR = %jimage_f_jimage(jimage1, jimage2)
    // Vertical concatenation of 2 jimages.
    // We simply use the horizontal one (when it will be implemented),
    // and the transposition:
    jimageR = [jimage1' jimage2']';
endfunction

