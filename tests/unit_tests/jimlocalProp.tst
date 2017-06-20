// This file is part of Jimlab,
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
// <-- INTERACTIVE TEST -->  // PROVISOIRE. TESTS AUTOMATIQUES À VENIR

// Tests of jimlocalProp(Jimage)
// -----------------------------
Jimage = jimread(jimlabPath("/") + "tests/images/lena_color.gif");

clf
subplot(2,3,1); jimdisp(Jimage, "info")
subplot(2,3,2); jimdisp(jimlocalProp(Jimage,"min",3)), xtitle("min 3x3")
subplot(2,3,3); jimdisp(jimlocalProp(Jimage,"max",3)), xtitle("max 3x3")

Jimage = jimread(jimlabPath("/") + "tests/images/noError/rgba.png");
subplot(2,3,4); jimdisp(Jimage, "info")
subplot(2,3,5); jimdisp(jimlocalProp(Jimage,"median",5)), xtitle("median 5x5")
subplot(2,3,6); jimdisp(jimlocalProp(Jimage,"variance",3)), xtitle("variance 3x3")
