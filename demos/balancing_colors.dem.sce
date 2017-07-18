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
            "It returns the average intensities for each RGB layer."
            "The alpha transparency layer is ignored."
            ""
            "For a color Jimage, mean() computes the average intensity of each"
            "color layer, and then allows to set it to the middling value 128."
            "Here we just do:"
            ""
            "image = jimread(lena_file);"
            "m = mean(image);"
            "subplot(1,2,1), jimdisp(image)"
            "subplot(1,2,2), jimdisp(image + (128-m(:)))"
            ""
            "And that''s it!"
            "Please note that the overloading of ""+"" is also used."
           ];

    drawlater()
    f = gcf();
    f.axes_size = [840 460];
    image = jimread(jimlabPath()+"/tests/images/lena_color.gif")
    m = mean(image);
    mprintf("\nm = mean(Jimage);\nsize(m): %s\nm: [R=%5.1f, G=%5.1f, B=%5.1f]", sci2exp(size(m)), m(:)');
    subplot(1, 2, 1), jimdisp(image), title("Lena (RGBA jimage)", "fontsize", 3)
    Title = [".         Balancing colors channelwise:"
             "m = mean(Lena); jimdisp(Lena + (128-m(:)))"]
    subplot(1, 2, 2), jimdisp(image + (128-m(:))), title(Title, "fontsize", 3); 
    // That's it!
    drawnow()
    messagebox(msg, "Jimlab demos: using mean(Jimage)");
endfunction

jim_balancing_colors_dem();
f = gcf();
f.figure_name = "Balancing colors using mean()";
clear f jim_balancing_colors_dem
