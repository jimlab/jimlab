// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1999 - INRIA - Carlos Klimann
// Copyright (C) 1999 - INRIA - Farid BELAHCENE
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
// Copyright (C) 2016 - Samuel GOUGEON
// Copyright (C) 2017 - Samuel GOUGEON : "ignored" argin added
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt
//

// TODO:
//  * Document "ignored"
//  * vectorize the algo (again)
//  * debug pour sparse orient en ignorant 0: Pour sparse, il faut neutraliser
//    avec 0 au lieu de %nan
// * median([13 %nan]) => %nan  instead of 13
// * Report bugs, push a commit.
// * Keep this version only in Jimlab versions for Scilab < merged
// 
// DONE:
// * "ignored" argin added and implemented.
// * nanmedian() replaced. Was way too slow.
// * Bug FIXED (déjà présent avant): median([0 0 %nan 0.17],"c") => %nan, au lieu de (0+0.17)/2

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
                    y(ky) = ytemp(1);        // (%nan are leading)
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
