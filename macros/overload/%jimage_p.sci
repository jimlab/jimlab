// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function [] = %jimage_p(Jimage)
    // This function overloads disp() for jimage objects.
    // Displayed infos: Title, encoding, mime type, 2D size, transparency color.

    image = Jimage.image;
    dim = size(image);
    tColor = Jimage.transparencyColor;
    if size(tColor, 3) == 3 then
        tColor = msprintf("[%d %d %d]\n", tColor(1), tColor(2), tColor(3));
    else
        tColor = msprintf("%d\n", tColor);
    end
    t = [ 'Title      : ' + Jimage.title
          'Encoding   : ' + jimtype(Jimage)
          'MIME type  : ' + Jimage.mime
          msprintf('Size       : %d x %d\n', dim(1), dim(2))
          msprintf("Transparent: %s\n", tColor)
          ];
    mprintf("%s\n",t)
endfunction
