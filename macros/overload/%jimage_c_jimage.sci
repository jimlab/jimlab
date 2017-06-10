// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimageR = %jimage_c_jimage(jimage1, jimage2)
    // Horizontal concatenation of 2 jimages.
    // (PROFILING DONE)

    s1 = [size(jimage1.image) 1];
    s2 = [size(jimage2.image) 1];
    if s1(1)~=s2(1) then
        msg = _("Jimlab: [,] concatenation: Both jimage operands must have the same number of rows.");
        error(msg);
    end

    // If both images have not the same number of layers: we pad the thinner one
    // -------------------------------------------------------------------------
    if s1(3)~=s2(3) then
        // We put the thickest in #1
        swapped = %f;
        if s1(3) < s2(3) then
            tmp = jimage1;
            jimage1 = jimage2;
            jimage2 = tmp;
            swapped = %t
            tmp = s1;
            s1 = s2;
            s2 = tmp;
        end
        //
        image1 = jimage1.image;
        image2 = jimage2.image;
        tC1 = jimage1.transparencyColor;
        tC2 = jimage2.transparencyColor;
        // s1(3) is either 3 or 4, not 1. So:
        // Allocating memory
        image2_0 = image2;
        image2(1,1,s1(3)) = uint8(0);

        // Gray layer => we replicate it => RGB
        if s2(3)==1
            image2(:,:,2) = image2_0;
            image2(:,:,3) = image2_0;
            if tC2~=-1
                tC2 = tC2 * ones(1,1,3);
            end
            s2(3) = 3;
        end

        if s1(3)==4 then     // s2(3) is (now) 3 = RGB => We add an alpha layer
            alpha2 = uint8(ones(s2(1), s2(2)))*255;
            if tC2~=-1
                n = s2(1)*s2(2);
                tmp = [ image2(1:n) image2((n+1):(2*n)) image2((2*n+1):(3*n))];
                k_tP = vectorfind(tmp, tC2(:)', "r");
                alpha2(k_tP) = 0;
                tC2 = -1;
            end
            image2(:,:,4) = alpha2;
            clear alpha2 tmp k_tP
            jimage2.image = image2;
        end
        // back swap
        if swapped then
            tmp = jimage1;
            jimage1 = jimage2;
            jimage2 = tmp;
        end
    end

    // Both images have (now) the same number of layers
    // ------------------------------------------------
    image1 = jimage1.image;
    image2 = jimage2.image;
    jimageR = jimage1;
    jimageR.image = [image1 image2];

    // Setting the overall transparencyColor:
    tC1 = jimage1.transparencyColor;
    tC2 = jimage2.transparencyColor;
    if s1(3)<4
        if tC1~=tC2
            jimageR.transparencyColor = -1;
            // Instead, when one is disabled and the other isn't, we could test
            // whether the enabled tC is present in the other image. 
            // In this case, tC would be disabled, in the other case, it would
            // be set to the overall tC.
        end
    else
        jimageR.transparencyColor = -1;     // as usual in RGBA
    end
    // Setting the overal title
    t1 = jimage1.title;
    t2 = jimage2.title;
    if grep(t1, " ")~=[] then
        t1 = "(" + t1 + ")";
    end
    if grep(t2, " ")~=[] then
        t2 = "(" + t2 + ")";
    end
    if isdef("vertConcat") & vertConcat then     // defined in [;]
        t = "[" + t1 + " ; " + t2 + "]";
    else
        t = "[" + t1 + " " + t2 + "]";
    end
    jimageR.title = t;
endfunction

