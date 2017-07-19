// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimColorsLayers_dem()
    drawlater()
    image = jimread(jimlabPath()+"/tests/images/lena_color.gif")
    // Examples:
    path = jimlabPath("/") + "tests/images/";
    Jimage = jimread(path + "lena_color.gif");

    // Keeping the whole but setting unselected to 0:
    // Application: display of RBV layers separately:
    subplot(3,3,1)
        jimdisp(Jimage(:,:,[1 0 0]))
        title("Red layer: Lena(:,:,[1 0 0])","fontsize",3)
    subplot(3,3,2)
        jimdisp(Jimage(:,:,[0 2 0]))
        title("Green layer: Lena(:,:,[0 2 0])","fontsize",3)
    subplot(3,3,3)
        jimdisp(Jimage(:,:,[0 0 3]))
        title("Blue layer: Lena(:,:,[0 0 3])","fontsize",3)
    subplot(3,3,4)
        jimdisp(Jimage(:,:,[0 2 3]))
        title("Red canceled: Lena(:,:,[0 2 3])","fontsize",3)
    subplot(3,3,5)
        jimdisp(Jimage(:,:,[1 0 3]))
        title("Green canceled: Lena(:,:,[1 0 3])","fontsize",3)
    subplot(3,3,6)
        jimdisp(Jimage(:,:,[1 2 0]))
        title("Blue canceled: Lena(:,:,[1 2 0])","fontsize",3)
    subplot(3,3,7)
        jimdisp(Jimage)
        title("True Lena","fontsize",3)
    subplot(3,3,8)
        jimdisp(Jimage(:,:,[1 3 2]))
        title("Inverting G<->B: Lena(:,:,[1 3 2])","fontsize",3)
    subplot(3,3,9)
        jimdisp(Jimage(:,:,[2 2 2]))
        title("Graying from Green: Lena(:,:,[2 2 2])","fontsize",3)
    f = gcf();
    f.axes_size = [750 820];
    drawnow()
    msg = ["Managing color layers of a Jimage through its 3rd index"
           "----------------------------------------------------------------"
           ""
           "Jimlab allows to easily manage color layers of any RGB or RGBA jimage."
           "To do so, just use a vector of 3 layers indices in [0 3] and use it"
           "to extract the layers in the given order."
           "Using #i at position #j means that the former ith layer replaces the jth one."
           "Specifying ""0"" sets the corresponding layer to 0 (no intensity)."
           "For a RGBA image, the Alpha channel is always ignored."
           ""
           "In the demo figure,"
           "* On the top row: only one layer is kept and stays at its position."
           "* On the middle row: only one layer is canceled. Others stay unchanged."
           "* On the bottom: layers reordering or repetition is illustrated."
           ]
    messagebox(msg, "Jimlab demos: Managing color layers");
endfunction

jimColorsLayers_dem();
f = gcf();
f.figure_name = "Colored Jimage: Managing color layers";
clear f jimColorsLayers_dem
