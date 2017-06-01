// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->  

// PROVISOIRE : À venir :
//  - Tests automatiques
//  - Additions hétérogènes : jimaje + décimal, jimage + entier

// =============================================
// Tests of the overloaded ADDITION "+" operator
// =============================================

path = jimlabPath("/") + "tests/images/";
//imG = jimread(path+"noError/gray.jpg");
//imrgba = jimread(path+"noError/rgba.png");
imrgba = jimread(path + "lena_color.gif");
imgray = jimhistEqual(imrgba);

// Jimage1 + Jimage2
clf
f = gcf();
f.axes_size = [780 300];
subplot(1,3,1), jimdisp(imrgba * 0.5 + imrgba($:-1:1,$:-1:1)*0.5)
subplot(1,3,2), jimdisp(imrgba * 0.5 + imgray($:-1:1,$:-1:1)*0.5)
subplot(1,3,3), jimdisp(imgray * 0.5 + imgray($:-1:1,$:-1:1)*0.5)
