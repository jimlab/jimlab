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

// Tests of the overloaded transposition operator '
// ------------------------------------------------
path = jimlabPath("/") + "tests/images/";

// Gray image
// ==========
Jimage = jimread(path+"noError/gray.jpg");
jimageT = Jimage';
assert_checkequal(jimageT.image, Jimage.image');
assert_checkequal(jimageT.transparencyColor, Jimage.transparencyColor);
assert_checkequal(jimageT.title, Jimage.title);
assert_checkequal(jimageT.encoding, Jimage.encoding);


// RGB image
// =========
Jimage = jimread(path + "lena_color.gif");
jimageT = Jimage';
assert_checkequal(jimageT.image(:,:,1), Jimage.image(:,:,1)');
assert_checkequal(jimageT.image(:,:,2), Jimage.image(:,:,2)');
assert_checkequal(jimageT.image(:,:,3), Jimage.image(:,:,3)');
assert_checkequal(jimageT.transparencyColor, Jimage.transparencyColor);
assert_checkequal(jimageT.title, Jimage.title);
assert_checkequal(jimageT.encoding, Jimage.encoding);


// RGBA image
// ==========
Jimage = jimread(path+"noError/rgba.png");
jimageT = Jimage';
assert_checkequal(jimageT.image(:,:,1), Jimage.image(:,:,1)');
assert_checkequal(jimageT.image(:,:,2), Jimage.image(:,:,2)');
assert_checkequal(jimageT.image(:,:,3), Jimage.image(:,:,3)');
assert_checkequal(jimageT.image(:,:,4), Jimage.image(:,:,4)');
assert_checkequal(jimageT.transparencyColor, Jimage.transparencyColor);
assert_checkequal(jimageT.title, Jimage.title);
assert_checkequal(jimageT.encoding, Jimage.encoding);
