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
// <-- INTERACTIVE TESTS --> // PROVISOIRE

// Examples:
path = jimlabPath("/") + "tests/images/";
Jimage = jimread(path + "lena_color.gif");
Jimage(1:10)   // Linearized indices over each layer. column x layers returned.
clf
ij = grand(1,77,"uin",1,500);
subplot(2,2,1), jimdisp(Jimage(ij,ij))
subplot(2,2,2), jimdisp(Jimage(100:400,100:300))
subplot(2,2,3), jimdisp(Jimage(:,100:300))
subplot(2,2,4), jimdisp(Jimage(200:$,200:$))

// Keeping the whole but setting unselected to 0:
// Application: display of RBV layers separately:
scf();
subplot(2,3,1), jimdisp(Jimage(:,:,[1 0 0])), title("R layer")
subplot(2,3,2), jimdisp(Jimage(:,:,[0 2 0])), title("G layer")
subplot(2,3,3), jimdisp(Jimage(:,:,[0 0 3])), title("B layer")
//subplot(2,3,4), jimdisp(Jimage)
subplot(2,3,4), jimdisp(Jimage(:,:,[1 2 0])), title("R+G layers")
subplot(2,3,5), jimdisp(Jimage(:,:,[0 2 3])), title("G+B layers")
subplot(2,3,6), jimdisp(Jimage(:,:,[1 0 3])), title("R+B layers")

// RGBA intensities in gray
scf();
subplot(2,2,1), jimdisp(Jimage(:,:,1)), title("R layer")
subplot(2,2,2), jimdisp(Jimage(:,:,2)), title("G layer")
subplot(2,2,3), jimdisp(Jimage(:,:,3)), title("B layer")
subplot(2,2,4), jimdisp(Jimage(:,:,4), "box"), title("A layer")

// ADD some examples with alpha and transparency set...

// Lena histequalized in color: (A DEPLACER en exemple de jimhistEqual() )
image = Jimage.image;
image(:,:,1) = jimhistEqual(image(:,:,1));
image(:,:,2) = jimhistEqual(image(:,:,2));
image(:,:,3) = jimhistEqual(image(:,:,3));
f = scf();
f.axes_size = [800 880];
subplot(3,3,1), jimdisp(Jimage(:,:,1)), title("R layer")
subplot(3,3,4), jimdisp(image(:,:,1))
subplot(3,3,2), jimdisp(Jimage(:,:,2)), title("G layer")
subplot(3,3,5), jimdisp(image(:,:,2))
subplot(3,3,3), jimdisp(Jimage(:,:,3)), title("B layer")
subplot(3,3,6), jimdisp(image(:,:,3))
subplot(3,3,7), jimdisp(Jimage)
subplot(3,3,8), jimdisp(image)
subplot(3,3,9), jimdisp(jimconvert(image,"gray"))
