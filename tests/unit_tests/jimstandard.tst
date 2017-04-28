path = jimlabPath() + '\tests\images\noError\rgba.png';
jim = jimread(path);
uint8Mat = jim.image;
uint8argb = uint8Mat;
uint8argb(:,:,1) = uint8Mat(:,:,4);
uint8argb(:,:,4) = uint8Mat(:,:,1);
doublenMat = double(jim.image)/255;
doubleMat = doublenMat + 35;
doubleMat = 50 * rand(10,10)
boolMat = round(rand(10,10)) == 0

tmp = matrix(uint8Mat(:,:,[1:3]), -1, 3);
colormap = double(unique(tmp, 'r'))/255;
indMat = uint8(round(rand(10,10)*3)+1)

int8Mat = int8(uint8Mat-127)


jimdisp(doubleMat)



[test, T] = jimstandard(int8Mat, , , );
T
typeof(test)
