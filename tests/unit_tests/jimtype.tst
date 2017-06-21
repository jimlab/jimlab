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

// ==================
// Tests of jimtype()
// ==================

path = jimlabPath("/") + "tests/images/";

// GRAY
im = jimread(path+"noError/gray.jpg");
assert_checkequal(jimtype(im), "gray");
im = rand(10,7);
assert_checkequal(jimtype(im), "gray");
assert_checkequal(jimtype(im<0.5), "gray");
im = grand(10,7,"uin",0,255);
assert_checkequal(jimtype(im), "gray");
assert_checkequal(jimtype(uint8(im)), "gray");
im = grand(10,7,"uin",-128,127);
assert_checkequal(jimtype(im), "gray");
assert_checkequal(jimtype(int8(im)), "gray");

// RGB
im = jimread(path+"noError/rgb.png");
assert_checkequal(jimtype(im), "rgb");
im = rand(10,7,3);
assert_checkequal(jimtype(im), "rgb");
im = grand(10,7,3,"uin",0,255);
assert_checkequal(jimtype(im), "rgb");
assert_checkequal(jimtype(uint8(im)), "rgb");
im = grand(10,7,3,"uin",-128,127);
assert_checkequal(jimtype(im), "rgb");
assert_checkequal(jimtype(int8(im)), "rgb");


// RGBA
im = jimread(path+"noError/rgba.png");
assert_checkequal(jimtype(im), "rgba");
im = rand(10,7,4);
assert_checkequal(jimtype(im), "rgba");
im = grand(10,7,4,"uin",0,255);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(uint8(im)), "rgba");
im = grand(10,7,4,"uin",-128,127);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(int8(im)), "rgba");
// Matrices with split bits
// rgba4444
w = warning("query");
warning off;
im = grand(10,7,"uin",-200,200);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(int16(im)), "rgba");
im = grand(10,7,"uin",0,300);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(uint16(im)), "rgba");
warning(w);
// rgba8888
im = grand(10,7,"uin",-40000,40000);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(int32(im)), "rgba");
im = grand(10,7,"uin",0,80000);
assert_checkequal(jimtype(im), "rgba");
assert_checkequal(jimtype(uint32(im)), "rgba");
