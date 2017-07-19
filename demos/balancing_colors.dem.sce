// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jim_balancing_colors_dem()
    msg = ["Balancing colors by using mean(Jimage)"
            ""
            "mean() is overloaded and can be used on Jimage objects."
            "It computes and returns the 3 average intensities for RGB layers."
            "The alpha transparency layer is ignored."
            "Here, besides titles, we just do:"
            ""
            "image = jimread(lena_file);"
            "m = mean(image);"
            "subplot(1,2,1), jimdisp(image)"
            "subplot(1,2,2), jimdisp(image + (128-m))"
            ""
            "And that''s it!"
            "Please note that the overloading of ""+"" is also used."
           ];

    drawlater()
    f = gcf();
    f.axes_size = [840 460];
    image = jimread(jimlabPath()+"/tests/images/lena_color.gif")
    m = mean(image);
    mprintf("\nm = mean(Jimage);\nsize(m): %s", sci2exp(size(m)));
    Title = [".         Lena (original RGBA jimage)"
             msprintf("m = mean(Lena);  // rgb=[%5.1f, %5.1f, %5.1f]", m(:)')
             ];
    subplot(1, 2, 1), jimdisp(image), title(Title, "fontsize", 3)
    Title = ["Balancing colors channelwise:"
             ".   jimdisp(Lena + (128-m))"]
    subplot(1, 2, 2), jimdisp(image + (128-m)), title(Title, "fontsize", 3); 
    // That's it!
    drawnow()
    messagebox(msg, "Jimlab demos: using mean(Jimage)");
endfunction

jim_balancing_colors_dem();
f = gcf();
f.figure_name = "Balancing colors using mean()";
clear f jim_balancing_colors_dem
