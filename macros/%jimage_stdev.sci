// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
function r = %jimage_stdev(image, side, varargin)
    // r: decimal numbers (even when image.image are encoded integers)
    // side: 1, 2, "r", "c", "m" as for mean()
    // varargin: 
    //    (1): given Mean wrt which the standard deviation is computed

    image = image.image;
    if size(image,3)>3 then
        // Removing the alpha channel
        image = image(:,:,1:3);
    end
    image = double(image);
    if ~isdef("side", "l") | type(side)==0 then
        side = "*";
    end
    noOpt = %f;
    if ~isdef("varargin", "l") | type(varargin)==0 | size(varargin)==0
        noOpt = %t
    end
    if noOpt then
        opt = list()
    else
        opt = varargin
    end
    if ~noOpt
        Mean = opt(1)
    end
    if ndims(image)>2
        r = list();
        for i = 1:3
            if ~noOpt
                opt(1) = Mean(i)
            end
            r(i) = stdev(image(:,:,i), side, opt(:));
        end
        r = cat(3,r(1),r(2),r(3));
    else
        r = stdev(image, side, opt(:));
    end
endfunction
