// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// (PROFILING DONE)

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
    // jimageR encoding is set to the dominant encoding of jimage1 and jimage2,
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
        tmp = image1;
        image1(:,:,3) = tmp; 
        image1(:,:,2) = tmp; 
    elseif ndims(image1)==3 & ndims(image2)==2 
        tmp = image2;
        image2(:,:,3) = tmp; 
        image2(:,:,2) = tmp; 
    end
    // If at least one image is in colors, we replicate both alpha layer
    if ndims(image1)>2 | ndims(image2)>2 then
        alpha1_0 = double(alpha1);
        alpha1 = zeros(s1(1),s1(2),3);  // memory allocation
        alpha1(:,:,1) = alpha1_0;
        alpha1(:,:,2) = alpha1_0;
        alpha1(:,:,3) = alpha1_0;
        alpha2_0 = double(alpha2);
        alpha2 = zeros(alpha1);         // memory allocation
        alpha2(:,:,1) = alpha2_0;
        alpha2(:,:,2) = alpha2_0;
        alpha2(:,:,3) = alpha2_0;
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
        imageR(1,1,4) = uint8(0);   // Extends memory allocation
        imageR(:,:,4) = uint8(min(1, alpha1_0 + alpha2_0)*255);
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

    // transparencyColor
    jimageR.transparencyColor = -1;
    encoding = jimtype(jimageR);
    if encoding=="gray"
        if tC1==tC2 then
            jimageR.transparencyColor = tC1
        end
    elseif or(encoding==["rgb" "rgba"])
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
