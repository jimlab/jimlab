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

// Tests of the size(jimage) overload
// ----------------------------------
path = jimlabPath("/") + "tests/images/";

// RGBA Jimage
// ===========
Jimage = jimread(path + "lena_color.gif");
assert_checkequal(size(Jimage),[500 512 4]);
assert_checkequal(size(Jimage, 1), 500);
assert_checkequal(size(Jimage, 2), 512);
assert_checkequal(size(Jimage, 3), 4);
assert_checkequal(size(Jimage, 4), 1);
assert_checkequal(size(Jimage, "r"), 500);
assert_checkequal(size(Jimage, "c"), 512);
assert_checkequal(size(Jimage, "*"), 500*512);


// RGB Jimage
// ==========
Jimage.image = Jimage.image(:,:,1:3);
assert_checkequal(size(Jimage),[500 512 3]);
assert_checkequal(size(Jimage, 1), 500);
assert_checkequal(size(Jimage, 2), 512);
assert_checkequal(size(Jimage, 3), 3);
assert_checkequal(size(Jimage, 4), 1);
assert_checkequal(size(Jimage, "r"), 500);
assert_checkequal(size(Jimage, "c"), 512);
assert_checkequal(size(Jimage, "*"), 500*512);

// Gray Jimage
// ==========
Jimage = jimread(path+"noError/gray.jpg");
assert_checkequal(size(Jimage),[50 50]);
assert_checkequal(size(Jimage, 1), 50);
assert_checkequal(size(Jimage, 2), 50);
assert_checkequal(size(Jimage, 3), 1);
assert_checkequal(size(Jimage, 4), 1);
assert_checkequal(size(Jimage, "r"), 50);
assert_checkequal(size(Jimage, "c"), 50);
assert_checkequal(size(Jimage, "*"), 2500);
