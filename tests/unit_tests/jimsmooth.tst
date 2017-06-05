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
mat_image=Jimage.image;
 mat_image= jimsmooth_padGRAY(mat_image,3);
blured = jimsmooth(Jimage);
mat_filter = 1/16*[1 2 1 ;2 4 2 ;1 2 1];
imsmooth= uint8(conv2( double( mat_image),mat_filter,'same')) ;
assert_checkequal(blured,imsmooth)

// % RGB %

imagePath = jimlabPath() +"\tests\images\noError\rgb.jpg";
Jimage = jimread(imagePath);
[h,w] = size(Jimage);
mat_im=Jimage.image;
blured = jimsmooth(Jimage,"gaussian",5);
mat_filter = jimsmooth_mask("gaussian",5) ;
  mat_im= jimsmooth_padRGB(mat_im,5);
mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');

result=uint8( mat_im);

assert_checkequal(blured,result)

// % RGBA %

imagePath = jimlabPath() +"\tests\images\noError\rgba.png";
Jimage = jimread(imagePath);
[h,w] = size(Jimage);
blured = jimsmooth(Jimage,"uniform",5);
mat_filter = jimsmooth_mask("uniform",5) ;
mat_im= jimsmooth_padRGBa(mat_im,5);
mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');
mat_im(:,:,4)=conv2(double(mat_im(:,:,4)),mat_filter,'same');
result=uint8( mat_im);

assert_checkequal(blured,result)


