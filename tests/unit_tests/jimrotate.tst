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
// <-- INTERACTIVE TEST -->  // PROVISOIRE. TESTS AUTOMATIQUES À VENIR

// ====================
// Tests of jimrotate()
// ====================

jim = jimread(jimlabPath("/") + "tests/images/puffin.png");
clf
f = gcf();
f.axes_size = [850 470];
subplot(2,4,1), jimdisp(jim)
for i = 2:8
    subplot(2,4,i)
    jimdisp(jimrotate(jim,(i-1)*25))
end
