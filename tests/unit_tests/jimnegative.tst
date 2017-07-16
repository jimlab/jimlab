// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
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
[h,w] = size(Jimage);

inverted = jimnegative(Jimage);
convMatgray = 255 * ones(h,w);

assert_checkequal(inverted.image,convMatgray-Jimage.image)

// The output has the same type as the output : a jimage object
assert_checkequal(type(inverted),type(Jimage))


// % RGB %

imagePath = jimlabPath() +"\tests\images\noError\rgb.jpg";
Jimage = jimread(imagePath);
[h,w] = size(Jimage);

inverted = jimnegative(Jimage);

tmp = 255 * ones(h,w);
convMatrgb(:,:,1) = tmp - Jimage.image(:,:,1) ;
convMatrgb(:,:,2) = tmp - Jimage.image(:,:,2) ;
convMatrgb(:,:,3) = tmp - Jimage.image(:,:,3) ;
expected = convMatrgb ;

assert_checkequal(inverted.image,expected)

// The output has the same type as the output : a jimage object
assert_checkequal(type(inverted),type(Jimage))

// % RGBA %

imagePath = jimlabPath() +"\tests\images\noError\rgba.png";
Jimage = jimread(imagePath);
[h,w] = size(Jimage);

inverted = jimnegative(Jimage);

tmp = 255 * ones(h,w);
convMatrgba(:,:,1) = tmp - Jimage.image(:,:,1) ;
convMatrgba(:,:,2) = tmp - Jimage.image(:,:,2) ;
convMatrgba(:,:,3) = tmp - Jimage.image(:,:,3) ;
convMatrgba(:,:,4) = Jimage.image(:,:,4) ;
expected = convMatrgba ;

assert_checkequal(inverted.image,expected)

// The output has the same type as the output : a jimage object
assert_checkequal(type(inverted),type(Jimage))


// % gray % (not a jimage object)

uint8gray = uint8(grand(350,200,1,"uin",0,255));
[h,w] = size(uint8gray);

inverted = jimnegative(uint8gray);

convMatgray2 = 255 * ones(h,w);

assert_checkequal(inverted,convMatgray2-uint8gray)

// The output has the same type as the output
assert_checkequal(type(inverted),type(uint8gray))
