// This file is part of Jimlab,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHIC -->

//uint8 rgba
uint8rgba = uint8(grand(10,10,4,"uin",0,255));
tmp = double(uint8rgba);
[test, T] = jimstandard(uint8rgba,%f);
[test2, T2] = jimstandard(uint8rgba);
[test3, T3] = jimstandard(tmp);
[test4, T4] = jimstandard(tmp, %f);
assert_checkequal(uint8rgba,test);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(test,test3) ;
assert_checkequal(T,T3) ;
assert_checkequal(test,test4) ;
assert_checkequal(T,T4) ;
assert_checkequal(T, "uint8");
assert_checkequal(type(test(1,1,1)), 8.);

//uint8 argb
uint8argb = uint8rgba;
tmp = double(uint8argb);
[test, T] = jimstandard(uint8argb,%t);
[test2, T2] = jimstandard(tmp,%t);
assert_checkequal(test, test2);
assert_checkequal(T,T2);
assert_checkequal(T, ["uint8"; "argb"]);
assert_checkequal(type(test(1,1,1)), 8.);
expected = uint8argb(:,:,2:4);
expected(:,:,4) = uint8argb(:,:,1);
assert_checkequal(expected, test);
clear expected;

//uint8 rgb 
uint8rgb = uint8rgba(:,:,1:3);
tmp = double(uint8rgb);
[test, T] = jimstandard(uint8rgb);
[test2, T2] = jimstandard(uint8rgb);
assert_checkequal(test, test2);
assert_checkequal(T,T2);
assert_checkequal(uint8rgb,test);
assert_checkequal(T, ["uint8"]);
assert_checkequal(type(test(1,1,1)), 8.);

//uint8 rgb332
uint8rgb332 = uint8rgba(:,:,1);
tmp = double(uint8rgb332);
[test, T] = jimstandard(uint8rgb332, "332");
[test2, T2] = jimstandard(tmp, "332");
r = modulo(uint8rgb332,uint16(2^8));
expected(:,:,1) = floor(r./uint16(2^5));
g = modulo(uint8rgb332,uint16(2^5));
expected(:,:,2) = floor(g./uint16(2^2));
expected(:,:,3) = modulo(uint8rgb332,uint16(2^2));
expected(:,:,1:2) = double(expected(:,:,1:2)) * 255/7;
expected(:,:,3) = double(expected(:,:,3)) * 255/3;
expected = uint8(expected);
assert_checkequal(expected, test);
assert_checkequal(test, test2);
assert_checkequal(T,T2);
assert_checkequal(T, ["uint8", "332"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//uint8 gray 
uint8gray = uint8rgba(:,:,1);
tmp = double(uint8gray);
[test, T] = jimstandard(uint8gray);
[test2, T2] = jimstandard(tmp);
assert_checkequal(test, test2);
assert_checkequal(T,T2);
assert_checkequal(uint8gray,test);
assert_checkequal(T, ["uint8"]);
assert_checkequal(type(test(1,1,1)), 8.);

//int8 rgba
int8rgba = int8(grand(10, 10, 4,"uin", -128, 127));
tmp = double(int8rgba);
[test, T] = jimstandard(int8rgba,%f);
[test2, T2] = jimstandard(int8rgba);
[test3, T3] = jimstandard(tmp,%f);
[test4, T4] = jimstandard(tmp);
assert_checkequal(uint8(int8rgba),test);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(test,test3) ;
assert_checkequal(T,T3) ;
assert_checkequal(test,test4) ;
assert_checkequal(T,T4) ;
assert_checkequal(T, "int8");
assert_checkequal(type(test(1,1,1)), 8.);

//int8 argb
int8argb = int8rgba;
tmp = double(int8argb);
[test, T] = jimstandard(int8argb,%t);
[test2, T2] = jimstandard(tmp,%t);
expected = int8argb(:,:,2:4);
expected(:,:,4) = int8argb(:,:,1);
expected = uint8(expected);
assert_checkequal(expected, test);
assert_checkequal(test,test2);
assert_checkequal(T,T2);
assert_checkequal(T, ["int8"; "argb"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//int8 rgb 
int8rgb = int8rgba(:,:,1:3);
tmp = double(int8rgb);
[test, T] = jimstandard(int8rgb);
[test2, T2] = jimstandard(tmp);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(uint8(int8rgb),test);
assert_checkequal(T, ["int8"]);
assert_checkequal(type(test(1,1,1)), 8.);

//int8 rgb332
int8rgb332 = int8rgba(:,:,1);
tmp = double(int8rgb332);
[test, T] = jimstandard(int8rgb332, "332");
[test2, T2] = jimstandard(tmp, "332");
r = modulo(uint8(int8rgb332),uint16(2^8));
expected(:,:,1) = floor(r./uint16(2^5));
g = modulo(uint8(int8rgb332),uint16(2^5));
expected(:,:,2) = floor(g./uint16(2^2));
expected(:,:,3) = modulo(uint8(int8rgb332),uint16(2^2));
expected(:,:,1:2) = double(expected(:,:,1:2)) * 255/7;
expected(:,:,3) = double(expected(:,:,3)) * 255/3;
expected = uint8(expected);
assert_checkequal(expected, test);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(T, ["int8", "332"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//int8 gray 
int8gray = int8rgba(:,:,1);
tmp = double(int8gray);
[test, T] = jimstandard(int8gray);
[test2, T2] = jimstandard(tmp);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(uint8(int8gray),test);
assert_checkequal(T, ["int8"]);
assert_checkequal(type(test(1,1,1)), 8.);

// uint16 "4444"
uint164444 = uint16(grand(10, 10, "uin", 0, 65535));
tmp = double(uint164444);
[test, T] = jimstandard(uint164444);
[test2, T2] = jimstandard(uint164444,"4444");
[test3, T3] = jimstandard(tmp);
[test4, T4] = jimstandard(tmp,"4444");
expected(:,:,1) = floor(uint164444./uint16(16^3));
g = modulo(uint164444,uint16(16^3));
expected(:,:,2) = floor(g./uint16(16^2));
b = modulo(uint164444,uint16(16^2));
expected(:,:,3) = floor(b./uint16(16));
expected(:,:,4) = modulo(uint164444,uint16(16));
expected = double(expected) * 255/15;
expected = uint8(expected);
assert_checkequal(expected, test)
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(test,test3) 
assert_checkequal(T,T3) 
assert_checkequal(test,test4) 
assert_checkequal(T,T4) 
assert_checkequal(T, ["uint16", "4444"])
assert_checkequal(type(test(1,1,1)), 8.)
clear expected;

// uint16 "555"
uint16555 = uint164444;
tmp = double(uint16555);
[test, T] = jimstandard(uint16555,"555");
[test2, T2] = jimstandard(tmp,"555");
r = modulo(uint16555,uint16(2^15));
expected(:,:,1) = floor(r./uint16(2^10));
g = modulo(uint16555,uint16(2^10));
expected(:,:,2) = floor(g./uint16(2^5));
expected(:,:,3) = modulo(uint16555,uint16(2^5));
expected = double(expected) * 255/31;
expected = uint8(expected);
assert_checkequal(expected, test);
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(T, ["uint16", "555"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;


// uint16 "5551"
uint165551 = uint164444;
tmp = double(uint165551);
[test, T] = jimstandard(uint165551,"5551");
[test2, T2] = jimstandard(tmp,"5551");
expected(:,:,1) = floor(uint165551./uint32(2^11));
g = modulo(uint165551,uint32(2^11));
expected(:,:,2) = floor(g./uint16(2^6));
b = modulo(uint165551,uint16(2^6));
expected(:,:,3) = floor(b./uint16(2));
expected(:,:,4) = modulo(uint165551,uint16(2)) * 255;
expected(:,:,1:3) = double(expected(:,:,1:3)) * 255/31;
expected = uint8(expected);
assert_checkequal(test,expected) ;
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(T, ["uint16", "5551"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;


// uint16 "444"
uint16444 = uint164444;
tmp = double(uint16444);
[test, T] = jimstandard(uint16444,"444");
[test2, T2] = jimstandard(tmp,"444");
r = modulo(uint16444,uint16(16^3));
expected(:,:,1) = floor(r./uint16(16^2));
g = modulo(uint16444,uint16(16^2));
expected(:,:,2) = floor(g./uint16(16));
expected(:,:,3) = modulo(uint16444,uint16(16));
expected = double(expected) * 255/15;
expected = uint8(expected);
assert_checkequal(test,expected) ;
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(T, ["uint16", "444"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

// int16 "4444"
int164444 = int16(grand(10, 10, "uin", -32768, 32767));
tmp = double(int164444);
[test, T] = jimstandard(int164444);
[test2, T2] = jimstandard(int164444,"4444");
[test3, T3] = jimstandard(tmp);
[test4, T4] = jimstandard(tmp,"4444");
expected(:,:,1) = floor(uint16(int164444)./uint16(16^3));
g = modulo(uint16(int164444),uint16(16^3));
expected(:,:,2) = floor(g./uint16(16^2));
b = modulo(uint16(int164444),uint16(16^2));
expected(:,:,3) = floor(b./uint16(16));
expected(:,:,4) = modulo(uint16(int164444),uint16(16));
expected = double(expected) * 255/15;
expected = uint8(expected);
assert_checkequal(test,expected) ;
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(test,test3) ;
assert_checkequal(T,T3);
assert_checkequal(test,test4) ;
assert_checkequal(T,T4);
assert_checkequal(T, ["int16", "4444"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

// int16 "555"
int16555 = int164444;
tmp = double(int16555);
[test, T] = jimstandard(int16555,"555");
[test2, T2] = jimstandard(tmp,"555");
r = modulo(uint16(int16555),uint16(2^15));
expected(:,:,1) = floor(r./uint16(2^10));
g = modulo(uint16(int16555),uint16(2^10));
expected(:,:,2) = floor(g./uint16(2^5));
expected(:,:,3) = modulo(uint16(int16555),uint16(2^5));
expected = double(expected) * 255/31;
expected = uint8(expected);
assert_checkequal(expected, test) ;
assert_checkequal(test,test2) ;
assert_checkequal(T,T2) ;
assert_checkequal(T, ["int16", "555"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

// int16 "5551"
int165551 = int164444;
tmp = double(int165551);
[test, T] = jimstandard(int165551,"5551");
[test2, T2] = jimstandard(tmp,"5551");
tmp = uint16(int165551);
expected(:,:,1) = floor(tmp./uint32(2^11))   //Problème sur la première couche uniquement
g = modulo(tmp,uint32(2^11));
expected(:,:,2) = floor(g./uint16(2^6));
b = modulo(tmp,uint16(2^6));
expected(:,:,3) = floor(b./uint16(2));
expected(:,:,4) = modulo(tmp,uint16(2)) * 255;
expected(:,:,1:3) = double(expected(:,:,1:3)) * 255/31;
expected= uint8(expected);
assert_checkequal(expected, test)   //ne fonctionne pas alors que mêmes opérations que dans jimstandard() 
assert_checkequal(test,test2) 
assert_checkequal(T,T2)
assert_checkequal(T, ["int16", "5551"])
assert_checkequal(type(test(1,1,1)), 8.)
clear expected;


// int16 "444"
int16444 = int164444;
tmp = double(int16444);
[test, T] = jimstandard(int16444,"444");
[test2, T2] = jimstandard(tmp,"444");
r = modulo(uint16(int16444),uint16(16^3));
expected(:,:,1) = floor(r./uint16(16^2));
g = modulo(uint16(int16444),uint16(16^2));
expected(:,:,2) = floor(g./uint16(16));
expected(:,:,3) = modulo(uint16(int16444),uint16(16));
expected = double(expected) * 255/15;
expected = uint8(expected);
assert_checkequal(expected, test);
assert_checkequal(test,test2);
assert_checkequal(T,T2);
assert_checkequal(T, ["int16", "444"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//doubles normalisés rgba
doublenMat = rand(10,10,4);
[test, T] = jimstandard(doublenMat,%f);
[test2, T2] = jimstandard(doublenMat);
expected = uint8(255*doublenMat);
assert_checkequal(expected, test);
assert_checkequal(test2,test);
assert_checkequal(T2,T);
assert_checkequal(T, ["double"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//doubles normalisés argb
[test, T] = jimstandard(doublenMat,%t);
expected = uint8(255*doublenMat);
tmp = expected(:,:,1);
expected(:,:,1:3) = expected(:,:,2:4);
expected(:,:,4) = tmp;
assert_checkequal(expected, test);
assert_checkequal(T, ["double"; "argb"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//doubles normalisés rgb
doublenMatrgb = doublenMat(:,:,1:3);
[test, T] = jimstandard(doublenMatrgb);
expected = uint8(255*doublenMatrgb);
assert_checkequal(expected, test);
assert_checkequal(T, ["double"]);
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//doubles normalisés gray
doubleNgray = doublenMat(:,:,1);
[test, T] = jimstandard(doubleNgray);
expected = uint8(255*doubleNgray);
assert_checkequal(expected, test);
assert_checkequal(T, ["double"]);
assert_checkequal(type(test(1,1,1)), 8.);
assert_checkequal(test, uint8(doubleNgray * 255));
clear expected;

//image indexée
f = gcf();
nc = size(f.color_map,1);
colormap = f.color_map;
indMat = grand(10,10,"uin",1,nc);
indMat2 = int8(indMat);
indMat3 = uint8(indMat);
[test, T] = jimstandard(indMat, f);
[test2, T2] = jimstandard(indMat2, f);
[test3, T3] = jimstandard(indMat3, f);
[test4, T4] = jimstandard(indMat, colormap);
[test5, T5] = jimstandard(indMat2, colormap);
[test6, T6] = jimstandard(indMat3, colormap);
dim = size(indMat);
imageDouble = colormap(indMat,:)
expected = matrix(imageDouble, dim(1), dim(2), -1)
expected = uint8(255*expected);
originalType = "ind"; 
assert_checkequal(expected,test);
assert_checkequal(test2,test);
assert_checkequal(T2,T);
assert_checkequal(test3,test);
assert_checkequal(T3,T);
assert_checkequal(test4,test);
assert_checkequal(T4,T);
assert_checkequal(test5,test);
assert_checkequal(T5,T);
assert_checkequal(test6,test);
assert_checkequal(T6,T);
assert_checkequal(T, "ind");
assert_checkequal(type(test(1,1,1)), 8.);
clear expected;

//booleens
boolMat = round(rand(10,10)) == 0;
[test, T] = jimstandard(boolMat);
assert_checkequal(test, uint8(boolMat)*255);
assert_checkequal(T, "bool");
assert_checkequal(type(test(1,1,1)), 8.);


//Wrong colormap argument
msg = "%s: Argument #%d: coefficients of the colormap must be in the intervalle[0,1].\n";
msg = msprintf(msg, "jimstandard", 2);
colormap = grand(nc,3,"uin",0,2);
assert_checkerror("test = jimstandard(indMat , colormap)", msg);

//Wrong type for the second argument
msg = "%s: Argument #%d: Wrong type of input argument.\n";
msg = msprintf(msg, "jimstandard", 2);
assert_checkerror("test = jimstandard(indMat , 9)", msg);

//%f if the input image is not supported
unsupportedMat = rand(10,10,5);
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);
unsupportedMat = ["1", "0"; "0.5", "0.5"];
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);

unsupportedMat = int16(grand(10, 10, 2, "uin", -32768, 32767));
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);
unsupportedMat = ["1", "0"; "0.5", "0.5"];
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);

unsupportedMat = uint8(grand(10, 10, 3, "uin", 0, 255));
[test, T] = jimstandard(unsupportedMat, "332");
assert_checkequal(test, %f);
assert_checkequal(T, 0);
unsupportedMat = ["1", "0"; "0.5", "0.5"];
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);

unsupportedMat = round(rand(10,10, 3)) == 0;
[test, T] = jimstandard(unsupportedMat, "332");
assert_checkequal(test, %f);
assert_checkequal(T, 0);
unsupportedMat = ["1", "0"; "0.5", "0.5"];
[test, T] = jimstandard(unsupportedMat);
assert_checkequal(test, %f);
assert_checkequal(T, 0);
