// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimageR = %jimage_5(jimage)
    // Negative of a jimage
    jimageR = jimage;
    tmp =  255 - jimage.image;
    if ndims(tmp)>2 & size(tmp,3)>3 then
        tmp(:,:,4) = 255 - tmp(:,:,4); // the alpha layer is unchanged
    end
    jimageR.image = tmp;
    tC = jimage.transparencyColor;
    if length(tC)>1 | tC~=-1 then
        jimageR.transparencyColor = 255 - tC;
    end
    t = jimage.title;
    if grep(t, " ")~=[] then
        jimageR.title = "~(" + t + ")"
    else
        jimageR.title = "~ " + t
    end
endfunction

//// Example:
//path = jimlabPath("/") + "tests/images/"
//jimage = jimread(path + "lena_color.gif");
//clf, f = gcf(); f.axes_size = [500 550];
//subplot(2,2,1), jimdisp(jimage), subplot(2,2,2), jimdisp(~jimage)
//jimage = jimconvert(jimage, "gray");
//subplot(2,2,3), jimdisp(jimage), subplot(2,2,4), jimdisp(~jimage)
//
