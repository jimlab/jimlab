
//uint8 rgba
uint8rgba = uint8(grand(10,10,4,"uin",0,255));
subplot(2,1,1)
Matplot(uint8rgba);
[test, T] = jimstandard(uint8rgba,,%f);
[test2, T2] = jimstandard(uint8rgba);
assert_checkequal(uint8rgba,test)
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, "uint8")
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//uint8 argb
uint8argb = uint8rgba;
subplot(2,1,1)
Matplot(uint8argb);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(uint8argb,,%t);
assert_checkequal(T, ["uint8"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//uint8 rgb 
uint8rgb = uint8rgba(:,:,1:3);
Matplot(uint8rgb);
[test, T] = jimstandard(uint8rgb);
assert_checkequal(uint8rgb,test)
assert_checkequal(T, ["uint8"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//uint8 gray 
uint8gray = uint8rgba(:,:,1);
subplot(2,1,1)
Matplot(uint8gray);
[test, T] = jimstandard(uint8gray);
assert_checkequal(uint8gray,test)
assert_checkequal(T, ["uint8"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//int8 rgba
int8rgba = int8(grand(10, 10, 4,"uin", -128, 127));
subplot(2,1,1)
Matplot(int8rgba);
[test, T] = jimstandard(int8rgba,,%f);
[test2, T2] = jimstandard(int8rgba);
assert_checkequal(uint8(int8rgba),test)
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, "int8")
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//int8 argb
int8rgba = int8argb;
subplot(2,1,1)
Matplot(int8rgba);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(int8argb,,%t);
assert_checkequal(T, ["int8"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//int8 rgb 
int8rgb = int8rgba(:,:,1:3);
subplot(2,1,1)
Matplot(int8rgb);
[test, T] = jimstandard(int8rgb);
assert_checkequal(uint8(int8rgb),test)
assert_checkequal(T, ["int8"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//int8 gray 
int8gray = int8rgba(:,:,1);
subplot(2,1,1)
Matplot(int8gray);
f = gce();
f.image_type = "gray";
[test, T] = jimstandard(int8gray);
assert_checkequal(uint8(int8gray),test)
assert_checkequal(T, ["int8"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// uint16 "4444"
uint164444 = uint16(grand(10, 10, "uin", 0, 65535));
subplot(2,1,1)
Matplot(uint164444);
c = gce();
c.image_type="rgba444";
[test, T] = jimstandard(uint164444);
[test2, T2] = jimstandard(uint164444, , ,"4444");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, ["uint16", "4444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// uint16 "555"
uint16555 = uint164444;
subplot(2,1,1)
Matplot(uint16555);
c = gce();
c.image_type="rgb555";
[test, T] = jimstandard(uint16555,,,"555");
assert_checkequal(T, ["uint16", "555"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// uint16 "5551"
uint165551 = uint164444;
subplot(2,1,1)
Matplot(uint165551);
c = gce();
c.image_type="rgba5551"
[test, T] = jimstandard(uint165551,,,"5551");
assert_checkequal(T, ["uint16", "5551"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// uint16 "444"
uint16444 = uint164444;
subplot(2,1,1)
Matplot(uint16444);
c = gce();
c.image_type="rgb444";
[test, T] = jimstandard(uint16444,,,"444");
assert_checkequal(T, ["uint16", "444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// int16 "4444"
int164444 = uint16(grand(10, 10, "uin", -32768, 32767));
subplot(2,1,1)
Matplot(int164444);
c = gce();
c.image_type="rgba444";
[test, T] = jimstandard(int164444);
[test2, T2] = jimstandard(int164444, , ,"4444");
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, ["int16", "4444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// int16 "555"
int16555 = int164444;
subplot(2,1,1)
Matplot(int16555);
c = gce();
c.image_type="rgb555";
[test, T] = jimstandard(int16555,,,"555");
assert_checkequal(T, ["int16", "555"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// int16 "5551"
int165551 = int164444;
subplot(2,1,1)
Matplot(int165551);
c = gce();
c.image_type="rgba5551"
[test, T] = jimstandard(int165551,,,"5551");
assert_checkequal(T, ["int16", "5551"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

// int16 "444"
int16444 = int164444;
subplot(2,1,1)
Matplot(int16444);
c = gce();
c.image_type="rgb444";
[test, T] = jimstandard(int16444,,,"444");
assert_checkequal(T, ["int16", "444"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);



//doubles normalisés rgba
doublenMat = rand(10,10,4)
subplot(2,1,1)
Matplot(doublenMat);
[test, T] = jimstandard(doublenMat,,%f);
[test2, T2] = jimstandard(doublenMat);
assert_checkequal(test2,test)
assert_checkequal(T2,T)
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//doubles normalisés argb
Matplot(doublenMat);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(doublenMat,,%t);
assert_checkequal(T, ["double"; "0"; "1"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//doubles normalisés rgb
doublenMatrgb = doublenMat(:,:,1:3);
subplot(2,1,1)
Matplot(doublenMatrgb);
[test, T] = jimstandard(doublenMatrgb);
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
subplot(2,1,2)
Matplot(test);

//doubles normalisés gray
doubleNgray = doublenMat(:,:,1);
[test, T] = jimstandard(doubleNgray);
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
assert_checkequal(test, uint8(doubleNgray * 255))
Matplot(test);


//doubles non normalisés


//booleens
boolMat = round(rand(10,10)) == 0

//image indexée
tmp = matrix(uint8Mat(:,:,[1:3]), -1, 3);
colormap = double(unique(tmp, 'r'))/255;
indMat = uint8(round(rand(10,10)*3)+1)

//image indexée aléatoire
f = gcf();
nc = size(f.color_map,1);
M = grand(100,130,"uin",1,nc);

//int8 aléatoire
int8Mat = int8(grand(10, 10, "uin", -128, 127))

//uint8 aléatoire
uint8Mat = uint8(grand(10, 10, "uin", 0, 255))

//uint16 aléatoire "444"
uint16Mat = uint16(grand(10, 10, "uin", 0, 65535))
Matplot(uint16Mat)
c = gce();
c.image_type="rgb444"
figure()
test = jimstandard(uint16Mat)
Matplot(test)



//uint16 aléatoire "555"
uint16Mat = uint16(grand(10, 10, "uin", 0, 65535))
Matplot(uint16Mat)
c = gce();
c.image_type="rgb555"
figure()
test = jimstandard(uint16Mat,,,"555")
Matplot(test)

//uint16 aléatoire "5551"
uint16Mat = uint16(grand(10, 10, "uin", 0, 65535))
Matplot(uint16Mat)
c = gce();
c.image_type="rgba5551"
figure()
test = jimstandard(uint16Mat,,,"5551")
Matplot(test)
         
//uint32 aléatoire
uint32Mat = uint32(grand(10, 10, "unf", 0, 4294967296))
Matplot(uint32Mat)
figure()
test = jimstandard(uint32Mat)
Matplot(uint8(test))



[test, T] = jimstandard(int8Mat, , , );
T
typeof(test)
