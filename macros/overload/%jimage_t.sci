// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Jimage = %jimage_t(Jimage)
    // Transposition of a jimage
    // (PROFILING DONE)
    s = [size(Jimage.image) 1];
    timage(s(2),s(1),s(3)) = uint8(0);
    for i = 1:s(3)
        timage(:,:,i) = Jimage.image(:,:,i).';
    end
    Jimage.image = timage;
endfunction
