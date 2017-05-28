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
// <-- INTERACTIVE TEST -->  // PROVISOIRE. TESTS AUTOMATIQUES À VENIR

// ============================================
// Tests of the overloaded PRODUCT "*" operator
// ============================================

path = jimlabPath("/") + "tests/images/";
//imG = jimread(path+"noError/gray.jpg");
imrgb = jimread(path + "lena_color.gif");
//imrgba = jimread(path+"noError/rgba.png");

// Jimage * decimal
// ================
clf
f = gcf();
f.axes_size = [780 650];
subplot(3,4,1), jimdisp(imrgb)
// * scalar : overal brightness
subplot(3,4,2), jimdisp(imrgb*0.7)
subplot(3,4,3), jimdisp(imrgb*1.4)
// * rgb vector : balancing RGB channels
im = imrgb * ([0.8 1.2 1.3]*1.1);
subplot(3,4,5), jimdisp(im)
// * rgba vector : + tunning the overal alpha
subplot(3,4,6), jimdisp(im * [1 1 1 0.5])
// * Alpha matrix: circular shading
s = size(im);
[X,Y] = ndgrid((1:s(1))-s(1)/2, (1:s(2))-s(2)/2);
mask = sqrt(X.^2 + Y.^2);
mask = cosd(mask/max(mask)*90).^2;
subplot(347), jimdisp(uint8(mask*255))
subplot(348), jimdisp(im * -mask)
// * RGB hypermatrix:
LR = cosd((Y + 255)/511*90).^2;
CG = cosd(Y/256*90).^2;
RB  =cosd((256-Y)/511*90).^2;
RGB = LR;
RGB(:,:,2) = CG;
RGB(:,:,3) = RB;
im2 = im * (RGB * 1.2);
subplot(3,4, 9), jimdisp(im2(:,:,[1 0 0]))
subplot(3,4,10), jimdisp(im2(:,:,[0 2 0]))
subplot(3,4,11), jimdisp(im2(:,:,[0 0 3]))
subplot(3,4,12), jimdisp(im2)
