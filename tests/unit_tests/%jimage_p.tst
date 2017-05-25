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

// Tests of the %jimage_p() overload
// ----------------------------------
path = jimlabPath("/") + "tests/images/";

// RGB image
image = jimread(path + "lena_color.gif")

// RGBA image
image = jimread(path+"noError/rgba.png")

// Gray image
image = jimread(path+"noError/gray.jpg")
