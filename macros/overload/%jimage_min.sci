// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
function [m, k] = %jimage_min(Jimage)
    i = Jimage.image;
    if ndims(i)<3 then
        [m, k] = min(i);
    else
        [m1, k1] = min(i(:,:,1))
        [m2, k2] = min(i(:,:,2))
        [m3, k3] = min(i(:,:,3))
        m = cat(3, m1, m2, m3);
        k = cat(3, k1, k2, k3);
    end
endfunction
