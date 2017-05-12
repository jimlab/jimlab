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

// Tests of the size(jimage) overload
// ----------------------------------
path = jimlabPath("/") + "tests/images/";

// RGB image
// =========
jimage = jimread(path + "lena_color.gif");
assert_checkequal(size(jimage),[500 512]);
assert_checkequal(size(jimage, 1), 500);
assert_checkequal(size(jimage, 2), 512);
assert_checkequal(size(jimage, "r"), 500);
assert_checkequal(size(jimage, "c"), 512);
assert_checkequal(size(jimage, "*"), 500*512);


// RGBA image
// ==========
jimage = jimread(path+"noError/rgba.png");
assert_checkequal(size(jimage),[50 50]);
assert_checkequal(size(jimage, 1), 50);
assert_checkequal(size(jimage, 2), 50);
assert_checkequal(size(jimage, "r"), 50);
assert_checkequal(size(jimage, "c"), 50);
assert_checkequal(size(jimage, "*"), 2500);


// Gray image
// ==========
jimage = jimread(path+"noError/gray.jpg");
assert_checkequal(size(jimage),[50 50]);
assert_checkequal(size(jimage, 1), 50);
assert_checkequal(size(jimage, 2), 50);
assert_checkequal(size(jimage, "r"), 50);
assert_checkequal(size(jimage, "c"), 50);
assert_checkequal(size(jimage, "*"), 2500);

