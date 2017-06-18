// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Mnoubue ALIX MELAINE 
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON 
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Image = jimsmooth(Image, varargin)
    // blurred = jimsmooth(Image)
    // blurred = jimsmooth(Image, fogWidth)
    // blurred = jimsmooth(Image, fogType)
    // blurred = jimsmooth(Image, fogType, fogWidth)
    // blurred = jimsmooth(Image, fogMatrix)
    // fogType : "mean", "triangular", "hyperbolic", "gaussian" (default)
    // fogWidth: a unique or vector of two positive odd decimal integers
    
    // CHECKING ARGUMENTS
    // ==================
    rhs = argn(2);
    if rhs<1 | rhs>3 then
        msg = _("%s: Wrong number of input arguments: %d to %d expected.\n");
        error(msprintf(msg, "jimsmooth", 1, 3));
    end
    // Checking Image
    // --------------
    if typeof(Image)~="jimage"
        image = jimstandard(Image);
    else
        image = Image.image;
    end

    if rhs==1 then
        fogType = "gaussian";
        fogWidth = [3 3];
    else // rhs > 1
        tmp = varargin(1)
        if type(tmp)==10    // fogType
            if size(tmp,"*")>1
                msg = _("%s: Argument #%d: Scalar (1 element) expected.\n");
                error(msprintf(msg, "jimsmooth", 2));
            end
            maskTypes = ["uniform" "triangular" "hyperbolic" "gaussian"];
            if ~or(convstr(tmp)==maskTypes)
                msg = _("%s: Argument #%d: Must be in the set {%s}.\n");
                maskTypes = """" + strcat(mtypes, """,""") + """";
                error(msprintf(msg, "jimsmooth", 2, maskTypes));
            end
            fogType = convstr(tmp);
            if rhs>2
                tmp = varargin(2);
            else
                tmp = [];
            end
        end
        if type(tmp)==1     // fogMatrix | fogWidth
            if ~isreal(tmp, 0)
                msg = _("%s: Argument #%d: Real number(s) expected.\n");
                error(msprintf(msg, "jimsmooth", 2));
            end
            if ndims(tmp)>2
                msg = _("%s: Argument #%d: Vector or matrix expected.\n");
                error(msprintf(msg, "jimsmooth", 2));
            end
            if tmp==[]
                fogWidth = [3 3]
            elseif or(length(tmp)==[1 2])   // fogWidth
                tmp = fix(tmp);
                if ~and(modulo(tmp, 2)) | or(tmp<=0)
                    msg = _("%s: Argument #%d: Both sizes must be positive and odd.\n");
                    error(msprintf(msg, "jimsmooth", 2));
                end
                if length(tmp)==1
                    tmp = [tmp tmp];
                end
                fogWidth = tmp;
            else    // fogMatrix
                if ~and(modulo(size(tmp), 2))
                    msg = _("%s: Argument #%d: Both matrix sizes must be odd.\n");
                    error(msprintf(msg, "jimsmooth", 2));
                end
                mat_filter = tmp;
                fogWidth = size(tmp);
            end
        else
            msg = _("%s: Wrong type for argument #%d.\n");
            error(msprintf(msg, "jimsmooth", rhs));
        end
    end
    if ~isdef("mat_filter","l") then
        mat_filter = jimsmooth_mask(fogType, fogWidth) ;
    end

    // PADDING
    // =======
    nLayers = min(3, size(image,3));
    // We do not smooth the alpha channel:
    image = image(:,:,1:nLayers);
    // Padding with the border line:
    dh = (fogWidth(1)-1)/2;
    dw = (fogWidth(2)-1)/2;
    image = [repmat(image(1,:,:),dh,1) ; image ; repmat(image($,:,:),dh,1)];
    image = [repmat(image(:,1,:),1,dw),  image, repmat(image(:,$,:),1, dw)];

    // SMOOTHING
    // =========
    inputType = inttype(image(1));
    image = double(image);
    for i = 1:nLayers
        image(:,:,i) = conv2(image(:,:,i), mat_filter, 'same');
    end
    image = iconvert(image, inputType);

    // UNPADDING
    // =========
    image = image(dh+1:$-dh, dw+1:$-dw, :);
    
    if typeof(Image)=="jimage" then
        Image.image(:,:,1:nLayers) = image;
    else
        Image(:,:,1:nLayers) = image;
    end
endfunction

// ----------------------------------------------------------------------------

function matMask = jimsmooth_mask(fogType, fogwidth)
  // Function building the mask matrix according to the mask type and parameters

    ic = int(fogwidth/2) +1; // index of the center
    if or(fogType==["triangular" "hyperbolic" "gaussian"]) then
        // Matrix of distances to the mask's center:
        [X, Y] = meshgrid(1:fogwidth(2), 1:fogwidth(1));
        D = sqrt((X-ic(2)).^2 + (Y-ic(1)).^2);
    end

    select fogType
    case "uniform" then
        matMask = ones(fogwidth(1), fogwidth(2));

//    case "triangular" then
//        mat = ones(fogwidth(1),fogwidth(2));
//        mat = mat/sum(mat);
//        matMask = conv2(mat,mat,"same") ;

    case "triangular" then      // conical
        rMax = sqrt(sum(fogwidth.^2));
        p = 4*(rMax-1);
        // r = (max(fw)-1)/2 =>  w = 1/p
        // r = 0             =>  w = 1
        matMask = 1 - (1-1/p)/(rMax-1)*2 * D;

    case "hyperbolic"   // Hyperbolic mask profile
        // r = distance to the center
        // n = number of surrounding neighboors at r: n = 8*r (or 2*%pi*r)
        // a = 2*r+1   n=4*(a-1)=8*r
        D(ic(1),ic(2)) = 1;     // Cancels the central 0
        matMask = 1 ./D/7;
        matMask(ic(1),ic(2)) = 1;

    case "gaussian" then
        order = 2.5;
        sigma = (fogwidth/2) /order;
        // Creation of the 2D gaussian profile/weights
        matMask = exp(-(((X-ic(2))/sigma(2)).^2 + ((Y-ic(1))/sigma(1)).^2)/2);

    else    // should not occur
        error('jimsmooth_mask: This filter does not exist') ;
    end

    // Normalization:
    matMask = matMask / sum(matMask);
endfunction
