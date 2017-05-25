// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimageR = %jimage_a_jimage(jimage1, jimage2)
    // ADDITION jimage1 + jimage2
    // * When a jimage has an alpha layer (RGBA) and .transparencyColor==-1:
    //    the A_layer/255 is priorly taken as pixelwise weights of color layers.
    // * When a jimage is in colors and .transparencyColor is a 3-component
    //    uint8 vector: pixels set to this color are priorly set to black.
    // * When a jimage is in gray and .transparencyColor is an uint8: pixels
    //    set to this intensity are priorly set to black.
    // Afterwards, in all cases, the whole image is weighted by its .radiance
    // before being added.
    //
    // jimageR encoding: is set to the dominant encoding of jimage1 and jimage2,
    //                   with RGBA > RGB > gray. 
    // For a RGBA result: The new alpha layer is the sum of input alpha layers
    //                   (set from transparencyColor when one of the operands is
    //                    in RGB or gray).
    // .transparencyColor:
    //   - for RGBA jimageR: set to -1 (disabled)
    //   - for RGB  jimageR: set to the matching transparencyColor color vector
    //      from both input jimages, when they match. Otherwise: set to -1.
    //      The RGB equivalent of the gray G value is [G G G].
    //   - for gray  jimageR: set to the matching transparencyColor color value
    //      from both input jimages, when they match. Otherwise: set to -1.
    //   
    // .title =  "(title #1) + (title #2)"
    //         Input titles are parenthesed only when they include blanks.
    //
    // .radiance = 1
    //

    image1 = jimage1.image;
    image2 = jimage2.image;
    s1 = size(image1);
    s2 = size(image2);

    // Sizes must match
    if ~and(s1(1:2)==s2(1:2)) then
        error(_("jimage1 + jimage2: Mismatching sizes of images.\n"));
    end

    // PREPROCESSING
    // -------------
    // jimage1
    alpha1 =  ones(image1(:,:,1));
    tC1 = jimage1.transparencyColor;
    if ndims(image1)==3   // colored
        if s1(3)>3 then     // RGBA
            alpha1 = double(image1(:,:,4))/255;  // on [0, 1]
            image1 = image1(:,:,1:3);
        end
        if typeof(tC1)=="uint8" & size(tC1,"*")==3
            tmp = matrix(permute(image1,[3 2 1]), 3, -1);
            k_tP = vectorfind(tmp, tC1(:), "c");
            alpha1(k_tP) = 0;
        end
    else                // gray
        if typeof(tC1)=="uint8" & size(tC1,"*")==1
            alpha1(image1==tC1) = 0;
        end
    end

    // jimage2
    alpha2 =  ones(image2(:,:,1));
    tC2 = jimage2.transparencyColor;
    if ndims(image2)==3   // colored
        if s2(3)>3 then     // RGBA
            alpha2 = double(image2(:,:,4))/255;  // on [0, 1]
            image2 = image2(:,:,1:3);
        end
        if typeof(tC2)=="uint8" & size(tC2,"*")==3
            tmp = matrix(permute(image2, [3 2 1]), 3, -1);
            k_tP = vectorfind(tmp, tC2(:), "c");
            alpha2(k_tP) = 0;
        end
    else                // gray
        if typeof(tC2)=="uint8" & size(tC2,"*")==1
            alpha(image2==tC2) = 0;
        end
    end

    // If one is in gray and the other colored, we replicate the gray into 3 layers
    if ndims(image1)==2 & ndims(image2)==3 then
        image1 = image1 .*. ones(1,1,3);
    elseif ndims(image1)==3 & ndims(image2)==2 
        image2 = image2 .*. ones(1,1,3);
    end
    // If at least one image is in colors, we replicate both alpha layer
    if ndims(image1)>2 | ndims(image2)>2 then
        alpha1 = alpha1 .*. ones(1,1,3);
        alpha2 = alpha2 .*. ones(1,1,3);
    end

    // ADDITION. MANAGEMENT OF SATURATION
    // ----------------------------------
    r1 = 1; r2 = 1;
    if isfield(jimage1,"radiance") then
        r1 = jimage1.radiance;
        r2 = jimage2.radiance;
    end
    // ************
    imageR = double(image1) .* alpha1 * r1 + double(image2) .* alpha2 * r2;
    imageR(imageR<0) = 0;
    imageR(imageR>255) = 255;
    imageR = uint8(imageR);
    if ndims(image1)>2 | ndims(image2)>2 then
        imageR(:,:,4) = uint8(min(1, alpha1 + alpha2)*255);
    end
    // ************

    // SETTING FIELDS OF THE RESULT
    // ----------------------------
    // image
    jimageR = jimage1;
    jimageR.image = imageR;

    // title
    t1 = jimage1.title;
    t2 = jimage2.title;
    if grep(t1," ")~="" then
        t1 = "("+t1+")";
    end
    if grep(t2," ")~="" then
        t2 = "("+t2+")";
    end
    jimageR.title = t1 + " + " + t2;

    // encoding
    if ndims(imageR)>2 then
        jimageR.encoding = "rgb";
        if size(imageR,3)>3
            jimageR.encoding = "rgba";
        end
    else
        jimageR.encoding = "gray";
    end

    // transparencyColor
    jimageR.transparencyColor = -1;
    if jimageR.encoding=="gray"
        if tC1==tC2 then
            jimageR.transparencyColor = tC1
        end
    elseif jimageR.encoding=="rgb"
        if length(tC1)==1
            tC1 = tC1 * [1 1 1]';
        end
        if length(tC2)==1
            tC2 = tC2 * [1 1 1]';
        end
        if and(tC1(:)==tC2(:))
            jimageR.transparencyColor = tC1(:)'
        end
    end
    
    // radiance
    if isfield(jimage1,"radiance") then
        jimageR.radiance = 1;
    end
endfunction
