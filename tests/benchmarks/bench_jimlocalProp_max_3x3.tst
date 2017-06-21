// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

//==============================================================================
// Benchmark for the jimlocalProp(..,"max") function
//==============================================================================

//  <-- BENCH NB RUN : 10 -->

path = jimlabPath() + '/tests/images/lena_color.gif';
image = jimread(path);
jimlocalProp(image(1:10,1:10), "max", 3); // loading the function

// <-- BENCH START -->

jimlocalProp(image,"max",3);

// <-- BENCH END -->
