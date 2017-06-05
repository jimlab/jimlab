 // This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- NO CHECK REF -->

fs = filesep();

// Without input argument
path = jimlabPath();
assert_checkfalse(part(path,$)==fs);
assert_checktrue(isfile(path+fs+"etc"+fs+"jimlab.start"));

// With input argument
path = jimlabPath("/");
assert_checkequal(part(path,$), fs);
assert_checktrue(isfile(path+"etc"+fs+"jimlab.start"));
path = jimlabPath("\");
assert_checkequal(part(path,$), fs);
assert_checktrue(isfile(path+"etc"+fs+"jimlab.start"));

//With a wrong input argument 
path = jimlabPath("a")
assert_checkfalse(part(path,$)==fs);
assert_checktrue(isfile(path+fs+"etc"+fs+"jimlab.start"));
