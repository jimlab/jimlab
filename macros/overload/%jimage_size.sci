// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENEE
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function varargout = %jimage_size(Jimage, side)
    image = Jimage.image;
    L = list();
    if ~isdef("side", "l") | type(side)==0 then
        dims = size(image)
        if argn(1)==1
            L = list(dims);
        else
            dims =[dims ones(1,10)];
            for i = 1:argn(1)
                L(i) = dims(i);
            end
        end
    else
        if side=="*"
            image = image(:,:,1);   // total number of _pixels_
        end
        L = list(size(image, side));
    end
    varargout = L;
endfunction
