// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Mnoubue ALIX MELAINE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHICS --> //required by JIMS

// % gray %

imagePath = jimlabPath() +"\tests\images\noError\gray.jpg";
Jimage = jimread(imagePath);
jimpixelize(Jimage)
jimpixelize(Jimage,20)
jimpixelize(Jimage,7,2)
jimpixelize(Jimage)

// % RGB %

imagePath = jimlabPath() +"\tests\images\noError\rgb.png";
Jimage = jimread(imagePath);
jimpixelize(Jimage)
jimpixelize(Jimage,20)
jimpixelize(Jimage,7,2)
jimpixelize(Jimage)
