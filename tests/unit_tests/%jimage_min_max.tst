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

// Tests of min(jimage) and max(jimage) overloads
// ----------------------------------------------
path = jimlabPath("/") + "tests/images/";

// Gray image
// ==========
jimage = jimread(path+"noError/gray.jpg");
itype = inttype(jimage.image);
// min
[r, k] = min(jimage);
assert_checkequal(min(jimage), iconvert(117, itype));
assert_checkequal(k, [10 34]);
// max
[r, k] = max(jimage);
assert_checkequal(max(jimage), iconvert(255, itype));
assert_checkequal(k,[1 1]);


// RGB image
// =========
jimage = jimread(path + "lena_color.gif");
itype = inttype(jimage.image);
// min
[r, k] = min(jimage);
assert_checkequal(min(jimage), iconvert(cat(3,64,4,48), itype));
assert_checkequal(k, cat(3, [417 1], [411 1], [479 1]));
// max
[r, k] = max(jimage);
assert_checkequal(max(jimage), iconvert(cat(3,242,214,186), itype));
assert_checkequal(k, cat(3, [399 65],[401 65],[408 65]));


// RGBA image
// ==========
jimage = jimread(path+"noError/rgba.png");
itype = inttype(jimage.image);
// min
[r, k] = min(jimage);
assert_checkequal(min(jimage), iconvert(cat(3,54,0,0), itype));
assert_checkequal(k, cat(3, [20 27], [12 14], [23 5]));
// max
[r, k] = max(jimage);
assert_checkequal(max(jimage), iconvert(cat(3,255,255,255), itype));
assert_checkequal(k, ones(1,2,3));
