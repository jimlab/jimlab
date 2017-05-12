// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
function m = %jimage_mean(image, side)
    // m: decimal numbers (even when image.image are encoded integers)
    // side: 1, 2, "r", "c", "m" as for mean()
    image = image.image;
    if size(image,3)>3 then
        // Removing the alpha channel
        image = image(:,:,1:3);
    end
    image = double(image);
    if ~isdef("side", "l") | type(side)==0 then
        if ndims(image)>2
            m = mean(mean(image,1),2);
        else
            m = mean(image);
        end
    else
        // Scilab 5: "r" "c" "m" are badly managed by %hm_mean()
        if side=="r"
            side = 1
        elseif side=="c"
            side = 2;
        elseif side=="m"
            side = min(find(size(image)>1))
            if side==[], side = 1; end
        end
        m = mean(image, side);
    end
endfunction
