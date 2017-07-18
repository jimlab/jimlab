// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimnegative_dem()
    msg = ["Negative of a color or gray image:"
           "  * jimnegative() can be used on jimage objects and matrices or hypermatrices."
           "  * ~Jimage: The NOT operator is more handy (only with Jimage objects)."
           ""
           "When not disabled to -1, Jimage.transparencyColor is reverted as well."
           }
    messagebox(msg, "Jimlab demos: jimnegative() and ~");
    
    // From a jimage object
    //  Color:
    drawlater()
    image = jimread(jimlabPath()+"/tests/images/lena_color.gif")
    subplot(2,3,1), jimdisp(image); xtitle("lena")
    subplot(2,3,2), jimdisp(jimnegative(image)); xtitle("jimnegative(lena)")
    subplot(2,3,3), jimdisp(~image); xtitle("~lena")
    // Gray:
    image = jimconvert(image,"gray");
    subplot(2,3,4), jimdisp(image); xtitle("lena_gray")
    subplot(2,3,5), jimdisp(jimnegative(image)); xtitle("jimnegative(lena_gray)")
    subplot(2,3,6), jimdisp(~image); xtitle("~lena_gray")
    drawnow()
endfunction

jimnegative_dem();
f = gcf();
f.figure_name = "jimnegative() and ~";
clear f jimnegative_dem
