// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Jimage = %jimage_a_s(Jimage, s)
    // Adds a scalar or [r g b] vector or gray matrix or RGB hypermatrix of
    //  decimal numbers to a gray or colored image.
    // Jimage : jimage object in gray, RGB or RGBA.
    // s: Scalar, matrix or hypermatrix with 3 or 4 layers of decimal numbers.

    // (PROFILING DONE)

    image = double(Jimage.image);
    si = [size(image) 1];
    ss = [size(s) 1];
    nLi = min(si(3), 3);
    nLs = min(ss(3), 3);
    if si(3)>3 then
        image = image(:,:,1:3);
    end
    tC = Jimage.transparencyColor;
    if size(s,"*")==1 then
        if s==%inf           // We shift up just to hit 255, lossless
            m = max(image);
            if m < 255
                s = 255 - m;
            else
                s = 0;
            end
        elseif s==-%inf      // We shift down just to hit 0, lossless
            s = -min(image);
        end
        // Shifting the transparency color as well
        if tC ~= -1
            tC = max(min(tC+s, ones(tC)*255), 0);
        end
        image = image + s;

    elseif size(s,"*")==3 then
        if nLi<3
            msg = _("%s: Right operand: Scalar or matrix expected.\n");
            error(msprintf(msg, "%jimage_a_s"));
        end
        for i = 1:3
            u = s(i);
            if u==%inf            // We shift up just to hit 255, lossless
                m = max(image(:,:,i));
                if m < 255
                    u = 255 - m;
                else
                    u = 0;
                end
            elseif u==-%inf       // We shift down just to hit 0, lossless
                u = -min(image);
            end
            image(:,:,i) = image(:,:,i) + u;
            // Shifting the transparency color as well
            if length(tC)==3
                tC(i) = max(min(tC(i)+u, 255), 0);
            end
        end
    else
        if ~and(ss(1:2)==si(1:2))
            msg = _("%s: Right operand: Scalar or same size expected.\n");
            error(msprintf(msg, "%jimage_a_s"));
        end
        if nLs==2 | nLs>nLi
            msg = _("%s: Right operand: Wrong number of layers.\n");
            error(msprintf(msg, "%jimage_a_s"));
        end
        if nLs==1 & nLi==3
            for i = 1:3
                image(:,:,i) = image(:,:,i) + s;
            end
        end
    end
    image = max(min(image, 255), 0);
    //
    Jimage.image(:,:,1:nLi) = uint8(image);
endfunction
