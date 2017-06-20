// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// Presently: Private function used by jimlocalProp()
// For each pixel: builds a column of neighbors values, for all layers
// Concatenates columns for all image pixels

function  cols = jimneighbors2columns(image, varargin)
    // image: jimage or matrix of grey levels, or RGB or RGBA hypermatrix.
    //        jimstandard() is not called.
    // blockSize: blockSide scalar or [blockHeigh blockWidth] vector
    // selectedPixels: vector of linearized indices of pixels to be processed
    // cols: matrix with
    //    - blockHeigh * blockWidth rows
    //    - as many columns as there are selected pixels from the Image
    //    - as many layers as image ones.
    //    Each column is made of values of all pixels in a block around a
    //    selected pixel. For pixels close to the image border, some values may
    //    be %nan (coming from the padding).

    fname = "jimneighbors2columns";

    // CHECKING ARGUMENTS
    // ==================
    // Image :
    if typeof(image)=="jimage" then
        image = image.image;
    else
        image = image
    end
    si = [size(image) 1];
    H = si(1);
    W = si(2);

    bw = 3;         // Default block width
    bh = bw;        // Default block height
    pixels = [];    // Indices of selected pixels: By default, all == []
    if isdef("varargin", "l") & type(varargin)~=0 & ~isempty(varargin)
        // Checking the blockSize
        // ----------------------
        blockSize = varargin(1)
        if type(blockSize)~=1 | ~isreal(blockSize)
            msg = _("%s: Argument #%d: Decimal number(s) expected.\n");
            error(msprintf(msg, fname, 2))
        else
            blockSize = round(blockSize);
        end
        if length(blockSize)<1 | length(blockSize)>2
            msg = _("%s: Argument #%d: Scalar or %d-component vector expected.\n");
            error(msprintf(msg, fname, 2, 2))
        end
        if ~and(modulo(blockSize, 2)) | or(blockSize<=0)
            msg = _("%s: Argument #%d: Both sizes must be positive and odd.\n");
            error(msprintf(msg, "jimsmooth", 2));
        end
        h = blockSize(1);
        if length(blockSize)>1
            w = blockSize(2);
        else
            w = h;
        end
        if h<1 | h>si(1)
            msg = _("%s: Argument #%d (block size): blockSize(1) value must be in [%s, %s].\n");
            error(msprintf(msg, fname, 2, 1, si(1)))
        end
        if w<1 | w>si(2)
            msg = _("%s: Argument #%d (block size): blockSize(2) value must be in [%s, %s].\n");
            error(msprintf(msg, fname, 2, 1, si(2)))
        end
        bw = w;
        bh = h;
        
        // Checking for selected pixels
        // ----------------------------
        if length(varargin)>1
            pixels = varargin(2);
            if type(pixels)~=1 | ~isreal(pixels,0)
                msg = _("%s: Argument #%d: Decimal integer(s) expected.\n");
                error(msprintf(msg, fname, 3));
            end
            pixels = round(real(pixels));
            if pixels~=[] & or(pixels<1 | pixels>W*H)
                msg = _("%s: Argument #%d: Must be in the interval [%s, %s].\n");
                error(msprintf(msg, fname, 3, 1, W*H));
            end
        end
    end

    // New indices of actual pixels after padding
    // ------------------------------------------
    dh = (bh-1)/2;
    dw = (bw-1)/2;
    if pixels==[] then
        // (i=1+dh:h+dh, j=1+dw:w+dw), kp = (j-1)*(h+2*dh) + i
        [i,j] = ndgrid((1:H)+dh, (1:W)+dw);
    else
        [i,j] = ind2sub([H,W], pixels);
        i = i+dh;
        j = j+dw;
    end
    kpix = i + (j-1)*(H+2*dh);  // New indices of actual pixels
    kpix = kpix(:)';            // => in row

    // Relative indices of neighbors
    // -----------------------------
    [i,j] = ndgrid(1:bh, 1:bw);
    k = i + (j-1)*(H+2*dh);
    kr = k - (dh + 1 + (dw*(H+2*dh)));
    kr = kr(:);                 // => in column

    // Big matrix of indices
    // ---------------------
    ind = ones(kr) * kpix + kr * ones(kpix);

    // Building the result
    // -------------------
    TBpad = ones(dh,W)*%nan;
    LRpad = ones(H+2*dh,dw)*%nan;
    cols = zeros(bh*bw, length(kpix), si(3));
    for k = 1:si(3)                // Number of Layers, including the alpha one
        im = [TBpad ; image(:,:,k) ; TBpad];
        im = [LRpad , im , LRpad];
        cols(:,:,k) = matrix(im(ind), bh*bw, -1);
    end
endfunction
