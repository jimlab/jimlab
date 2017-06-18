// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- NO CHECK REF -->

// Tests of ones(Jimage) overload
// ------------------------------
path = jimlabPath("/") + "tests/images/lena_color.gif";

// RGBA
Jimage = jimread(path);
z = ones(Jimage);
assert_checktrue(and(z==1));
assert_checkequal(size(z), size(Jimage.image));

// RGB
Jimage = jimconvert(Jimage, "rgb");
z = ones(Jimage);
assert_checktrue(and(z==1));
assert_checkequal(size(z), size(Jimage.image));

// Gray
Jimage = jimconvert(Jimage, "gray");
z = ones(Jimage);
assert_checktrue(and(z==1));
assert_checkequal(size(z), size(Jimage.image));
