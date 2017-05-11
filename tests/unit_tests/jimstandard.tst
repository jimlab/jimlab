path = jimlabPath() + '\tests\images\noError\rgba.png';
jim = jimread(path);
uint8Mat = jim.image;

//uint8 rgba
uint8argb = uint8Mat;

//uint8 argb
uint8argb(:,:,1) = uint8Mat(:,:,4);
uint8argb(:,:,4) = uint8Mat(:,:,1);

//doubles normalisés
doublenMat = double(jim.image)/255;

//doubles non normalisés
doubleMat = doublenMat + 35;

//doubles normalisés aléatoires
doubleMat = 50 * rand(10,10)

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

//int16 aléatoire
uint16Mat = uint16(grand(10, 10, "uin", 0, 65535))


jimdisp(doubleMat)



[test, T] = jimstandard(int8Mat, , , );
T
typeof(test)
