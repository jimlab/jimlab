// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jim_flipping_dem()
    drawlater()
    f = gcf();
    f.axes_size = [580 650];
    image = jimread(jimlabPath()+"/tests/images/lena_color.gif")
    m = mean(image);
    image = image + (125-m);
    subplot(2,2,1), jimdisp(image), title("Lena", "fontsize", 4)
    subplot(2,2,2), jimdisp(image(:,$:-1:1)), title("Lena(:, $:-1:1)", "fontsize", 4)
    subplot(2,2,3), jimdisp(image($:-1:1,:)), title("Lena($:-1:1, :)", "fontsize", 4)
    subplot(2,2,4), jimdisp(image($:-1:1,$:-1:1)), title("Lena($:-1:1, $:-1:1)", "fontsize", 4)
    drawnow()

    msg = ["Flipping a jimage using indices:"
           "--------------------------------"
           "As titled in the figure,"
           ""
           " * reverting rows of a jimage flips it upside down"
           " * reverting columns of a jimage flips it left-right"
           ""
           "In both cases, specifying "":"" for RGB|RGBA layers is useless:"
           "All layers are automatically considered."
           "This is not the case when the image is a matrix or an hypermatrix."
           "Then, Lena($:-1:1, :, :) or flipdim(Lena,1) shall be used instead."
           ""
           ]
    messagebox(msg, "Jimlab demos: Flipping a jimage using indices");
endfunction

jim_flipping_dem();
f = gcf();
f.figure_name = "Flipping a jimage up-down or left-right";
clear f jim_flipping_dem
