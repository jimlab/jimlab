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
im = jimread(imagePath);

mat_im=im.image;
blured = jimsmooth(im);
mat_filter = jimsmooth_mask("gaussian",3) ;
 mat_im= jimsmooth_padGRAY(mat_im,3);
imsmooth= uint8(conv2( double( mat_im),mat_filter,'same')) ;
assert_checkequal(blured,imsmooth)

// % RGB %

imagePath = jimlabPath() +"\tests\images\noError\rgb.jpg";
im = jimread(imagePath);

mat_im=im.image;
blured = jimsmooth(im,"gaussian",5);
mat_filter = jimsmooth_mask("gaussian",5) ;
  mat_im= jimsmooth_padRGB(mat_im,5);
mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');

result=uint8( mat_im);

assert_checkequal(blured,result)


// % rgb % (not a jimage object)

uint8rgb = uint8(grand(350,200,3,"uin",0,255));
blured = jimsmooth(uint8rgb,"triangular",9);
mat_filter = jimsmooth_mask("triangular",9) ;
uint8rgb= jimsmooth_padRGB(uint8rgb,9);
uint8rgb(:,:,1)=conv2(double(uint8rgb(:,:,1)),mat_filter,'same');
uint8rgb(:,:,2)=conv2(double(uint8rgb(:,:,2)),mat_filter,'same');
uint8rgb(:,:,3)=conv2(double(uint8rgb(:,:,3)),mat_filter,'same');

imsmooth=uint8( uint8rgb);
assert_checkequal(blured,imsmooth)

