// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->
//
// INCOMPLETS ET PROVISOIRES :
//   - TESTS AUTOMATIQUES À VENIR
//   - INCLURE RGB

// =================================================
// Tests of the overloaded COCATENATIONS [,] and [;]
// =================================================

path = jimlabPath("/") + "tests/images/";
imrgba = jimread(path + "lena_color.gif");
imgray = jimconvert(imrgba, "gray");

clf
f = gcf();
f.axes_size = [780 430];
// Horizontal concatenations
subplot(2,2,1), jimdisp([imrgba imrgba])
subplot(2,2,2), jimdisp([imgray imgray])
subplot(2,2,3), jimdisp([imrgba imgray])
subplot(2,2,4), jimdisp([imgray imrgba])
im = [imgray imgray imgray];
im = [imrgba imrgba imrgba];
im = [imgray imrgba imgray];
im = [imrgba imgray imrgba];
im = [imrgba imgray ; imgray imrgba];


f = scf();
f.axes_size = [780 430];
// Vertical concatenations
subplot(1,4,1), jimdisp([imrgba ; imrgba])
subplot(1,4,2), jimdisp([imrgba ; imgray])
subplot(1,4,3), jimdisp([imgray ; imrgba])
subplot(1,4,4), jimdisp([imgray ; imgray])
