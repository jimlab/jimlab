// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON 
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Image = jimlocalProp(Image, propName, varargin)
    // Non-linear filters
    // ImageF = jimlocalProp(Image, propName)
    // ImageF = jimlocalProp(Image, propName, boxSize)
    // ImageF = jimlocalProp(Image, propName, boxSize, Fparams)
    // ImageF = jimlocalProp(Image, propName, Fparams)
    // Image: Jimage object, or gray matrix, or RGB or RGBA hypermatrix
    // propName: "min", "max", "median", "variance", "custom"
    // boxSize: a unique or vector of two positive odd decimal integers
    // Fparams: filter parameters: simple list():
    //   * if propName=="custom":
    //     Fparams(1) must provide the name of the function processing each
    //     block of neighboring pixels. The function
    //     - must work column-wise, returning only one row (over 1 to 4 layers)
    //     - must ignore %nan values (used for padding)
    //     - must accept matrices or hypermatrices with 3 or 4 layers
    //    Fparams(2:$) are passed as input arguments #2 to #n to the function.

    fname = "jimlocalProp";

    // CHECKING ARGUMENTS
    // ==================
    rhs = argn(2);
    if rhs<2 | rhs>4 then
        msg = _("%s: Wrong number of input arguments: %d to %d expected.\n");
        error(msprintf(msg, fname, 2, 4));
    end
    // Checking Image
    // --------------
    if typeof(Image)~="jimage"
        image = jimstandard(Image);
    else
        image = Image.image;
    end
    H = size(image,1);  // image's Height
    W = size(image,2);  // image's Width
    nL = size(image,3); // number of Layers
    npL = min(3,nL);    // number of processed Layers (ignoring alpha)
    inputType = inttype(image(1));
    image = double(image);
    if nL==4 then
        alpha = image(:,:,4);
        image = image(:,:,1:3);
    end

    // Checking propName
    // -------------------
    if type(propName(1))~=10
        msg = _("%s: Argument #%d: Text(s) expected.\n");
        error(msprintf(msg, fname, 2));
    end
    if size(propName)>1
        msg = _("%s: Argument #%d: Scalar (1 element) expected.\n");
        error(msprintf(msg, fname, 2));
    end
    propName = convstr(propName);
    acceptedFilters = ["median" "min" "max" "variance" "custom"];
    if ~or(propName==acceptedFilters)
        msg = _("%s: Argument #%d: Must be in the set {%s}.\n");
        tmp = """" + strcat(acceptedFilters, """,""") + """";
        error(msprintf(msg, fname, 2, tmp));
    end

    // Analysing varargin
    // ------------------
    bh = 3;             // Default box height
    bw = bh;            // Default box width
    custom = [];        // Name of the custom function
    params = list();    // Parameters of the custom function

    if rhs>2 then
        for i = 1:length(varargin)
            v = varargin(i);
            // boxSize expected
            if type(v)==1   
                v = round(v);
                if ~isreal(v,0) | ~or(length(v)==[1 2]) | or(modulo(v,2)==0)
                    msg = _("%s: Argument #%d: Scalar or 2-component vector of odd integers expected.\n");
                    error(msprintf(msg, fname, 2+i));
                end
                if or(v<1) | (length(v)==1 & v>min(H,W)) | (length(v)==1 & or(v>[H,W]))
                    msg = _("%s: Argument #%d: Positive values smaller or equal to image sizes expected.\n");
                end
                bh = v(1);
                bw = bh;
                if length(v)==2
                    bw = v(2);
                end

            // list: Custom function name and parameters expected
            elseif type(v)==15  
                if propName~="custom"
                    msg = _("%s: Argument #%d: Unexpected list of parameters");
                    error(msprintf(msg, fname, 2+i));
                end
                if length(v)==0 | type(v(1))~=10 | size(v(1),"*")>1
                    msg = _("%s: Argument #%d: The first component of the list must be a single string.\n");
                    error(msprintf(msg, fname, 2+i));
                end
                if ~isdef(v(1),"a")
                    msg = _("%s: Argument #%d: The function ""%s"" is not defined.\n");
                    error(msprintf(msg, fname, 2+i, v(1)));
                end
                custom = v(1);  // Name of the custom function
                params = v;
                params(1) = null();
            else
            end
        end
    end

    // Process Slicing
    // ---------------
    maxBlockMem = 10e6;   // [bytes]: max memory size for each block of columns
    memPerColumn = bh*bw*H*npL*8;
    dj = max(1,min(W, int(maxBlockMem/memPerColumn))); // number of columns per block

    // Actual slicing
    j1 = 0;
    j$ = 0;
    imageP = zeros(image);
    //mprintf("\n/%d: ",W);
    while j$ < W
        j1 = j$+1;
        j$ = min(j$+dj,W);
        //mprintf("%d  ",j$);
        if dj==W
            selected = [];
        else
            selected = (1:H)' * ones(1,j$-j1+1) + ones(H,1) * ((j1:j$)-1)*H;
        end
        cols = jimneighbors2columns(image,[bh bw], selected);
        // Apply the function:
        select propName
        case "min"
            r = min(cols,"r");
        case "max"
            r = max(cols,"r");
        case "median"
            cols = matrix(cols, bh*bw,-1);
            r = median(cols,"r", %nan);     // overloaded version
        case "variance"
            r = nanstdev(cols,"r").^2;
        case "custom"
            execstr("r = "+custom+"(cols, params(:));");
        end
        clear cols
        if selected~=[]
            imageP(:,j1:j$,:) = matrix(r,H,-1,npL);
        end
    end
    if selected==[] then
        imageP = matrix(r, H, W, -1);
    end
    clear image
    if nL==4
        imageP(:,:,4) = alpha;
    end
    imageP = iconvert(imageP, inputType);
    if typeof(Image)=="jimage"
        Image.image = imageP;
    else
        Image = imageP;
    end
endfunction
// ---------------------------------------------------------------------------
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1999 - INRIA - Carlos Klimann
// Copyright (C) 1999 - INRIA - Farid BELAHCENE
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
// Copyright (C) 2016, 2017 - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt
//

// MUST BE _ALSO_ HERE FOR SCILAB 6.0
function y = median(x, varargin)
    //
    // NOTES
    //    - modified by farid.belahcene:the case when x is an hypermatrix
    //    - new syntaxes: median(x,'m') and median(x,dim)
    //    S. Gougeon 2016:
    //     - Fixes overflow issues with encoded integers when interpolating
    //       http://bugzilla.scilab.org/14640
    //   S. Gougeon 2017:
    //     - argin "ignored" added. nanmedian() removed (very slow)

    fname = "median";
    [lhs, rhs] = argn(0);
    ignored = [];
    orient = 0;

    // PARSING AND CHECKING ARGUMENTS
    // ==============================
    if rhs<1 | rhs>3 then
        msg = _("%s: Wrong number of input argument(s): %d to %d expected.\n")
        error(msprintf(msg, fname, 1, 3))
    end

    // Checking input data:
    if ~or(type(x(1))==[1 5 8]) then
        msg = _("%s: Argument #%1: Numbers expected.\n");
        error(msprintf(msg, fname, 1))
    end
    if or(type(x(1))==[1 5]) & ~isreal(x,0) then
        msg = _("%s: Argument #%1: real numbers expected.\n");
        error(msprintf(msg, fname, 1))
    else
        x = real(x);
    end

    // Checking options:
    for i = 1:length(varargin)
        v = varargin(i)
        if type(v(1))==10
            if size(v,"*")>1
                msg = _("%s: Argument #%d: Scalar (1 element) expected.\n")
                error(msprintf(msg, fname, i+1))
            end
            v = convstr(v)
            acceptedOrient = ["" "*" "r" "c" "m"]
            if ~or(v==acceptedOrient)
                msg = _("%s: Argument #%d: Must be in the set {%s}.\n")
                tmp = """" + strcat(acceptedOrient, """,""") + """"
                error(msprintf(msg, fname, i+1, tmp));
            end
            if v=="r" then
                orient = 1
            elseif v=="c" then
                orient = 2
            elseif v=="*" | v=="" then
                orient = 0
            elseif v=="m" then
                orient = find(size(x)>1,1)
            end

        elseif type(v(1))==1
            if i==1 // orient
                if size(v,"*")>1
                    msg = _("%s: Argument #%d: Scalar (1 element) expected.\n")
                    error(msprintf(msg, fname, 2))
                end
                if ~isreal(v,0) | ~or(v==(1:ndims(x)))
                    msg = _("%s: Argument #%d: Integer in [%d, %d] expected.\n")
                    error(msprintf(msg, fname, 2, 1, ndims(x)))
                end
                orient = real(v);
            else    // ignored
                ignored = unique(v(:))';
            end
        end
    end

    // PROCESSING
    // ==========
    // median on all components
    // ------------------------
    if orient==0 then
        if x==[] then
            y = %nan
            return
        end
        x = x(:);
        if ignored ~= []
            for i = ignored
                if isnan(i)
                    x(isnan(x)) = []
                else
                    x(x==i) = [];
                end
            end
        end
        n = size(x,"*");
        x = gsort(x,"g","i")
        if 2*int(n/2)==n then
            // avoid overflow: http://bugzilla.scilab.org/14640
            a = x(n/2)
            b = x(n/2+1)
            y = a/2 + b/2 + ((a-(a/2)*2) + (b-(b/2)*2))/2
        else
            y = x((n+1)/2);
        end

    // Projection along a given direction / dimension
    // ----------------------------------------------
    else
        if x==[] then
            y = []
            return
        end
        if orient>ndims(x) then
            y = x
            return
        end
        xsize = size(x);
        if xsize(orient)==1 then
            y = x
            return
        end
        // Preprocessing x against values to be ignored:
        if ignored ~= []
            initialNumberOfNans = sum(isnan(x),orient);
            for i = ignored
                if i==i  // not already being %nan
                    x(x==i) = %nan;
                end
            end
            ignoredN = sum(isnan(x),orient);
            if ~or(isnan(ignored))
                ignoredN = ignoredN - initialNumberOfNans;
            end
            clear initialNumberOfNans
            // value to be assigned in case of no remaining value
            noValue = %nan;
            if type(x(1))==8
                noValue = iconvert(0, inttype(x(1)));
            end
        end

        orient_above_size = xsize(orient+1:$);
        N = prod(orient_above_size)
        orient_below_size = xsize(1:orient-1);
        M = prod(orient_below_size)
        orient_size = xsize(1:orient);
        n = xsize(orient)
        P = prod(orient_size)
        Pi = P/n
        ignored? = (ignored ~= [])
        x = x(:);   // Bug FIXED
        y = zeros(N*M,1);
        ky = 0;
        kPi = -Pi;
        for k = 1:N
            kPi = kPi + Pi;
            for i = 1:M
                ky = ky + 1;
                ytemp = gsort(x(i+(0:n-1)*M+(k-1)*P),"r","i");
                if ignored?
                    p = n- ignoredN(i + kPi);   // number of valid values
                else
                    p = n
                end
                if p>1 then
                    if 2*int(p/2)==p then   // p is even => interpolation
                        q = p/2
                        // avoid overflow: http://bugzilla.scilab.org/14640
                        a = ytemp(q)
                        b = ytemp(q+1)
                        y(ky) = a/2 + b/2 + ((a-(a/2)*2) + (b-(b/2)*2))/2;
                    else
                        y(ky) = ytemp((p+1)/2);
                    end
                elseif p==1
                    y(ky) = ytemp(1);        // (%nan are sorted > %inf)
                    continue
                else // p==0
                    y(ky) = noValue;
                    continue
                end
            end
        end
        xsize(orient) = 1
        y = matrix(y, xsize)
    end
endfunction
