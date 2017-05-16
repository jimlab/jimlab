
//uint8 rgba
uint8rgba = uint8(grand(10,10,4,"uin",0,255));
Matplot(uint8rgba);
[test, T] = jimstandard(uint8rgba,,%f);
[test2, T2] = jimstandard(uint8rgba);
assert_checkequal(uint8rgba,test)
assert_checkequal(test,test2) 
assert_checkequal(T,T2) 
assert_checkequal(T, "uint8")
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//uint8 argb
uint8argb = uint8rgba;
Matplot(uint8argb);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(uint8argb,,%t);
assert_checkequal(T, ["uint8"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//uint8 rgb 
uint8rgb = uint8rgba(:,:,1:3);
Matplot(uint8rgb);
[test, T] = jimstandard(uint8rgb);
assert_checkequal(uint8rgb,test)
assert_checkequal(T, ["uint8"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//uint8 gray 
uint8gray = uint8rgba(:,:,1);
Matplot(uint8gray);
[test, T] = jimstandard(uint8gray);
assert_checkequal(uint8gray,test)
assert_checkequal(T, ["uint8"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//doubles normalisés rgba
doublenMat = rand(10,10,4)
Matplot(doublenMat);
[test, T] = jimstandard(doublenMat,,%f);
[test2, T2] = jimstandard(doublenMat);
assert_checkequal(test2,test)
assert_checkequal(T2,T)
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//doubles normalisés rgba
Matplot(doublenMat);
f = gce();
f.image_type = "argb";
[test, T] = jimstandard(doublenMat,,%t);
assert_checkequal(T, ["double"; "0"; "1"; "argb"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//doubles normalisés rgb
doublenMatrgb = doublenMat(:,:,1:3);
Matplot(doublenMatrgb);
[test, T] = jimstandard(doublenMatrgb);
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);

//doubles normalisés gray
doubleNgray = doublenMat(:,:,1);
Matplot(doubleNgray);
f = gce();
f.image_type = "gray";
[test, T] = jimstandard(doubleNgray);
assert_checkequal(T, ["double"; "0"; "1"])
assert_checkequal(type(test(1,1,1)), 8.)
figure();
Matplot(test);


//doubles non normalisés
doubleMat = doublenMat + 35;


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

//uint16 aléatoire "4444"
uint16Mat = uint16(grand(10, 10, "uin", 0, 65535))
Matplot(uint16Mat)
c = gce();
c.image_type="rgba444"
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
