// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- TEST WITH GRAPHIC -->  // required by JIMS
// <-- NO CHECK REF -->

root = jimlabPath("/") + "tests/images/noError/";
// Object jimage encoded in RGBA
path = root + "rgba.png";
jim = jimread(path);
equalizedJimage = jimhistEqual(jim);
jim.transparencyColor = cat(3, 255, 255, 255);
equalizedJimage2 = jimhistEqual(jim);
assert_checkequal(equalizedJimage.image, equalizedJimage2.image);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

// RGBA matrix
im = jim.image;
equalizedImage = jimhistEqual(im);
assert_checkequal(equalizedJimage.image, equalizedImage);

// Object jimage encoded in RGBA with a transparency color
path = jimlabPath("/") + "tests/images/logoEnsim_rgba.png";
jim = jimread(path);
ignoredTC = cat(3,0,0,255);
equalizedJimage = jimhistEqual(jim, ignoredTC);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

// RGBA matrix with a transparency color
im = jim.image;
equalizedImage = jimhistEqual(im, cat(3,0,0,255));
assert_checkequal(equalizedJimage.image, equalizedImage);

//Object jimage encoded in RGB
path = root + "rgba.png";
jim = jimread(path);
equalizedJimage = jimhistEqual(jim);
jim.transparencyColor = cat(3, 255,255,255);
equalizedJimage2 = jimhistEqual(jim);
assert_checkequal(equalizedJimage.image, equalizedJimage2.image);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

//RGB matrix
im = jim.image;
equalizedImage = jimhistEqual(im);
assert_checkequal(equalizedJimage.image, equalizedImage);

// Object jimage encoded in RGB with a transparency color
ignoredTC = cat(3,255,255,255);
equalizedJimage = jimhistEqual(jim, ignoredTC);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

// RGB matrix with a transparency color
equalizedImage = jimhistEqual(im, [255,255,255]);
assert_checkequal(equalizedJimage.image, equalizedImage);

//Object jimage encoded in gray levels
path = root + "gray.jpg";
jim = jimread(path);
equalizedJimage = jimhistEqual(jim);
jim.transparencyColor= 255;
equalizedJimage2 = jimhistEqual(jim);
assert_checkequal(equalizedJimage.image, equalizedJimage2.image);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

//Matrix of gray levels
im = jim.image;
equalizedImage = jimhistEqual(im);
assert_checkequal(equalizedJimage.image, equalizedImage);

// Object jimage encoded in gray levels with a transparency color
ignoredTC = 255;
equalizedJimage = jimhistEqual(jim, ignoredTC);
assert_checkequal(jim.title, equalizedJimage.title);
assert_checkequal(jim.mime, equalizedJimage.mime);

// Matrix of gray levels with a transparency color 
equalizedImage = jimhistEqual(im, 255);
assert_checkequal(equalizedJimage.image, equalizedImage);

//Wrong first argument
msg = "%s: Argument #%d: Wrong type of input argument.\n";
msg = msprintf(msg, "jimhistEqual", 1);
assert_checkerror("eq = jimhistEqual(""wrong"")", msg);
assert_checkerror("eq = jimhistEqual(""wrong"", 222)", msg);

//Wrong second argument 
msg = "%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n";
msg = msprintf(msg, "jimhistEqual", 2);
assert_checkerror("eq = jimhistEqual(im, ""wrong"")", msg);
assert_checkerror("eq = jimhistEqual(im, [1:4])", msg);

msg = "%s: Argument #%d: Components of ignoredTC must be in the intervalle [0:255].\n";
msg = msprintf(msg, "jimhistEqual", 2);
assert_checkerror("eq = jimhistEqual(im, [255, 0, 300])", msg);
assert_checkerror("eq = jimhistEqual(im, 256)", msg);
