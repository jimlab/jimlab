// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Jimage = %jimage_m_s(Jimage, num)
    // MULTIPLICATION with
    //   - a positive decimal number : Jimage * num
    //   - a vector of 3 positive RGB multiplicators
    //   - a vector of 4 positive RGBA multiplicators
    //   - a matrix of decimal numbers:
    //      - only positive => on gray or RGB
    //      - with at least a negative => on Alpha
    //   - an hypermatrix of positive decimal numbers
    //
    // If num is a scalar or a vector and a transparencyColor is defined,
    // num is applied to it as well. Otherwise, transparencyColor is disabled.

    image = double(Jimage.image);

    // CHECKING num
    // ------------
    snum = [size(num) 1];
    sima = [size(image) 1];
    if ~isreal(num,0) then
        error(_("Jimage * num: complex numbers num are not supported."));
    else
        num = real(num);
    end
    if prod(snum)==1 then
        num = num * ones(1,min(3,sima(3)))
        snum = [size(num) 1];
    elseif min(snum([1 2]))==1  // vector
        num = num(:)'   // forced in row vector
        snum = [size(num) 1];
    end
    // Sizes
    if sima(3)==1
        if prod(snum)~=1 & or(snum~=sima) then
            msg = _("Jimage * num: Wrong num size: Must be a scalar or a %d x %d matrix.\n");
            error(msprintf(msg, sima(1), sima(2)));
        end
    elseif sima(3)==3
        if ~(prod(snum)==1 | and(snum([1 2])==[1 3]) | ..
             (and(snum([1 2])==sima([1 2])) & or(snum(3)==[1 3]) ) )
             msg = _("Jimage * num: Wrong num size: Must be a scalar, [r g b] vector, %dx%d matrix, or %dx%dx3 hypermatrix\n");
             error(msprintf(msg, sima([1 2 1 2])));
         end
     elseif sima(3)==4
        if ~(prod(snum)==1 | ..
              and(snum(1:3)==[1 3 1]) | and(snum(1:3)==[1 4 1]) |..
             (and(snum([1 2])==sima([1 2])) & or(snum(3)==[1 3 4]) ) )
             msg = _("Jimage * num: Wronf num size: Must be a scalar, a [r g b] or [r g b a] vector, a %dx%d matrix, or a %dx%dx3 or %dx%dx4 hypermatrix\n");
             error(msprintf(msg, sima([1 2 1 2 1 2])));
         end

    end
    // Sign
    if ~(and(num>=0) | (sima(3)==4 & snum(3)==1)) then
        msg = _("Jimage * num: Wrong num value: Positive numbers expected.\n");
        error(msg);
    end

    // PROCESSING
    // ----------
    tC = Jimage.transparencyColor;
    t = "(" + Jimage.title + ")";
    if isscalar(num) then
        nL = min(3, sima(3));
        image(:,:,1:nL) = image(:,:,1:nL) .* num;
        if tC~=-1 then
            tC = min(255, uint8(double(tC) * num));
        end
        t = t + msprintf(" * %6g", num);

    elseif isvector(num) then
        t = t + " * [";
        c = ["R" "G" "B" "A"];
        nL = min(length(num), sima(3));
        for i = 1:nL
            image(:,:,i) = image(:,:,i) * num(i);
            if num(i)~=1
                t = t + c(i)+":"+stripblanks(msprintf("%6g",num(i))) + " ";
            end
        end
        t = t + "]";
        if tC~=-1
            tC = uint8(double(tC(:)') .* num(1:nL));
        end

    elseif ismatrix(num)
        if sima(3)==4 & or(num<0)
            image(:,:,4) = image(:,:,4) .* abs(num);
            t = t + " * (A matrix)";
        else
            for i = 1:3
                image(:,:,i) = image(:,:,i) .* num;
            end
            t = t + " * (RGB matrix)";
            tC = -1;    // We disable the transparencyColor. Indeed, pixels
                        // that all had the transparency color will likely
                        // get various colors afterwards.
        end
    else
        if snum(3)==3
            image(:,:,1:3) = image(:,:,1:3) .* num;
            t = t + " * (RGB hypermatrix)";
        else
            image = image .* num
            t = t + " * (RGBA hypermatrix)";
        end
        tC = -1;
    end
    Jimage.title = t;
    image(image>255) = 255;
    Jimage.image = uint8(image);
endfunction
