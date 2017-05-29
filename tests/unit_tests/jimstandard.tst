// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- TEST WITH GRAPHIC -->  // required by JIMS
// <-- NO CHECK REF -->

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
expected(:,:,1:3) = uint8argb(:,:,2:4);
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
expected(:,:,1:3) = int8argb(:,:,2:4);
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


// uint16 "5551"
uint165551 = uint164444;
subplot(2,1,1)
Matplot(uint165551);
c = gce();
c.image_type="rgba5551"
tmp = double(uint165551);
[test, T] = jimstandard(uint165551,"5551");
[test2, T2] = jimstandard(tmp,"5551");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, ["uint16", "5551"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

// uint16 "444"
uint16444 = uint164444;
subplot(2,1,1)
Matplot(uint16444);
c = gce();
c.image_type="rgb444";
tmp = double(uint16444);
[test, T] = jimstandard(uint16444,"444");
[test2, T2] = jimstandard(tmp,"444");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, ["uint16", "444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

// int16 "4444"
int164444 = int16(grand(10, 10, "uin", -32768, 32767));
subplot(2,1,1)
Matplot(int164444);
c = gce();
c.image_type="rgba4444";
tmp = double(int164444);
[test, T] = jimstandard(int164444);
[test2, T2] = jimstandard(int164444,"4444");
[test3, T3] = jimstandard(tmp);
[test4, T4] = jimstandard(tmp,"4444");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(test,test3) 
assert_checkequal(T,T3)
assert_checkequal(test,test4) 
assert_checkequal(T,T4)
assert_checkequal(T, ["int16", "4444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

// int16 "555"
int16555 = int164444;
subplot(2,1,1)
Matplot(int16555);
c = gce();
c.image_type="rgb555";
tmp = double(int16555);
[test, T] = jimstandard(int16555,"555");
[test2, T2] = jimstandard(tmp,"555");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, ["int16", "555"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

// int16 "5551"
int165551 = int164444;
subplot(2,1,1)
Matplot(int165551);
c = gce();
c.image_type="rgba5551";
tmp = double(int165551);
[test, T] = jimstandard(int165551,"5551");
[test2, T2] = jimstandard(tmp,"5551");
assert_checkequal(test,test2) 
assert_checkequal(T,T2)
assert_checkequal(T, ["int16", "5551"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

// int16 "444"
int16444 = int164444;
subplot(2,1,1)
Matplot(int16444);
c = gce();
c.image_type="rgb444";
tmp = double(int16444);
[test, T] = jimstandard(int16444,"444");
[test2, T2] = jimstandard(tmp,"444");
assert_checkequal(test,test2) 
assert_checkequal(T,T2)
assert_checkequal(T, ["int16", "444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

//doubles normalisés rgba
doublenMat = rand(10,10,4)
subplot(2,1,1)
Matplot(doublenMat);
[test, T] = jimstandard(doublenMat,%f);
[test2, T2] = jimstandard(doublenMat);
assert_checkequal(test2,test)
assert_checkequal(T2,T)
assert_checkequal(T, ["double"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

//doubles normalisés argb
subplot(2,1,1)
Matplot(doublenMat);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(doublenMat,%t);
assert_checkequal(T, ["double"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

//doubles normalisés rgb
doublenMatrgb = doublenMat(:,:,1:3);
subplot(2,1,1)
Matplot(doublenMatrgb);
[test, T] = jimstandard(doublenMatrgb);
assert_checkequal(T, ["double"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

//doubles normalisés gray
doubleNgray = doublenMat(:,:,1);
[test, T] = jimstandard(doubleNgray);
assert_checkequal(T, ["double"])
assert_checkequal(type(test(1,1,1)), 8.)
assert_checkequal(test, uint8(doubleNgray * 255))
Matplot(test);
pause

//image indexée
f = gcf();
nc = size(f.color_map,1);
colormap = f.color_map;
indMat = grand(10,10,"uin",1,nc);
indMat2 = int8(indMat);
indMat3 = uint8(indMat);
subplot(2,1,1)
Matplot(indMat);
c = gce();
c.image_type="index";
[test, T] = jimstandard(indMat, f);
[test2, T2] = jimstandard(indMat2, f);
[test3, T3] = jimstandard(indMat3, f);
[test4, T4] = jimstandard(indMat, colormap);
[test5, T5] = jimstandard(indMat2, colormap);
[test6, T6] = jimstandard(indMat3, colormap);
assert_checkequal(test2,test)
assert_checkequal(T2,T)
assert_checkequal(test3,test)
assert_checkequal(T3,T)
assert_checkequal(test4,test)
assert_checkequal(T4,T)
assert_checkequal(test5,test)
assert_checkequal(T5,T)
assert_checkequal(test6,test)
assert_checkequal(T6,T)
assert_checkequal(T, "ind")
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);
pause

//booleens
boolMat = round(rand(10,10)) == 0
[test, T] = jimstandard(boolMat);
assert_checkequal(test, uint8(boolMat)*255)
assert_checkequal(T, "bool")
assert_checkequal(type(test(1,1,1)), 8.)
