// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt


// Doesn't work on MacOS 5.5.2 yet

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHICS --> //required by JIMS

// % Single-layered square matrix %

uint8gray = uint8(grand(200,200,1,"uin",0,255));
A = jimstandard(uint8gray);
[h,w] = size(uint8gray);

disp(type(A));disp(typeof(A));

Summits = [47 47 ; 47 125 ; 130 125 ; 125 47];

// No cropping
[mask, polygon, ijTopLeft] = jimroi(uint8gray, Summits);

assert_checkequal(polygon,Summits)
assert_checkequal(size(mask),[h,w])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])

// Cropping
[mask, polygon, ijTopLeft] = jimroi(uint8gray, Summits,,1);

poly_top = max(Summits(:,2));
poly_bot = min(Summits(:,2));
poly_left = min(Summits(:,1));
poly_right = max(Summits(:,1));

assert_checkequal(polygon,Summits)
assert_checkequal(size(mask),[poly_top-poly_bot+1,poly_right-poly_left+1])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])


// % Single-layered rectangle matrix %

uint8gray = uint8(grand(350,200,1,"uin",0,255));
[h,w] = size(uint8gray);

Summits = [47 47 ; 47 125 ; 130 125 ; 125 47];


// No cropping
[mask, polygon, ijTopLeft] = jimroi(uint8gray, Summits);

assert_checkequal(polygon,Summits)
assert_checkequal(size(mask),[h,w])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])

// Cropping
[mask, polygon, ijTopLeft] = jimroi(uint8gray, Summits,,1);

poly_top = max(Summits(:,2));
poly_bot = min(Summits(:,2));
poly_left = min(Summits(:,1));
poly_right = max(Summits(:,1));

assert_checkequal(polygon,Summits)
assert_checkequal(size(mask),[poly_top-poly_bot+1,poly_right-poly_left+1])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])

// % From a jimage object

// RGB 315x838 pixels
path = pathconvert(jimlabPath()+"/tests/images/logoEnsim_rgb.png");
jim = jimread(path);
[h,w] = size(jim);

Summits = [120 80 ; 130 200 ; 500 250 ; 600 80];

// No cropping
[mask, poly, ijTopLeft] = jimroi(jim, Summits);

assert_checkequal(poly,Summits)
assert_checkequal(size(mask),[h,w])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])

// Cropping
[mask, poly, ijTopLeft] = jimroi(jim, Summits,,1);

poly_top = max(Summits(:,2));
poly_bot = min(Summits(:,2));
poly_left = min(Summits(:,1));
poly_right = max(Summits(:,1));

assert_checkequal(poly,Summits)
assert_checkequal(size(mask),[poly_top-poly_bot+1,poly_right-poly_left+1])
assert_checkequal(ijTopLeft,[h-max(Summits(:,2))+1,min(Summits(:,1))])
