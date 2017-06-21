// This file is part of Jimlab, 
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function  Image = jimpixelize(Image, varargin)
    // Image: jimage or matrix of grey levels, or RGB or RGBA hypermatrix.
    // varargin(1): block size = [blockHeigh blockWidth] vector

    fname = "jimpixelize";
    bw = 2;     // block width
    bh = bw;    // block height

    // CHECKING ARGUMENTS
    // ==================
    // Image :
    if typeof(Image)=="jimage" then
        image = Image.image;
        Image.image = [];       // frees the memory space
    else
        image = jimstandard(Image);
    end
    dataType = inttype(image(1));
    image = double(image);
    si = [size(image) 1];
    nL = min(3,si(3));      // number of Layers

    // Checking the blockSize :
    if isdef("varargin", "l") & type(varargin)~=0 
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
        if or(blockSize<=0)
            msg = _("%s: Argument #%d: Both box sizes must be positive.\n");
            error(msprintf(msg, fname, 2));
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
    end

    // IMAGE PADDING
    // =============
    wub = modulo(si(2), bw);     // width of uncomplete block
    if wub~=0 then
        pw = bw - wub           // Padding width
        image(1,$+pw,1,1) = 0;
        image(:,$-pw+1:$,1:nL) = %nan;
    end
    hub = modulo(si(1), bh);     // height of uncomplete block
    if hub~=0 then
        ph = bh - hub           // Padding height
        image($+ph,1,1) = 0;
        image($-ph+1:$,:,1:nL) = %nan;
    end

    
    // COLUMNING BLOCKS
    // ================
    H = size(image,1);
    W = size(image,2);
    // Blocks heads: linearized index of their top left element
    [R,C] = ndgrid(1:bh:H, (0:bw:W-1)*H);
    heads = R + C;
    heads = heads(:)';      // matrix(heads, round(H/bh), -1)
    // First block components
    [R,C] = ndgrid(1:bh, (0:bw-1)*H);
    block = R + C;
    block = block(:) - 1;
    [R, C] = ndgrid(block, heads);
    M = R + C;
    clear R C heads block
    
    // COMPUTING and ASSIGNING BLOCKS VALUES
    // =====================================
    if si(3)==4 then
        alpha = image(:,:,4)/255;
    else
        alpha = 1;
    end
    for k = 1:si(3)     // Loop on layers
        L = image(:,:,k) .* alpha + (1-alpha)*255; // white background used
        C = matrix(L(M), size(M));
        C = nanmean(C, "r");
        C = ones(bh*bw,1) * C;
        L(M(:)) = C(:);         // "(:)" required in Scilab 5
        image(:,:,k) = matrix(L, H, W);
    end
    image = iconvert(image, dataType);
    clear C L M

    // IMAGE : REMOVING PADDED MARGINS
    // -------------------------------
    image = image(1:si(1), 1:si(2), :);
    
    // FORMATTING THE RESULT
    // ---------------------
    if typeof(Image)=="jimage" then
        Image.image = image;
        // .title
        // .transparencyColor
        // RGBA: .image(:,:,4)
    else
        Image = image;
    end
endfunction
