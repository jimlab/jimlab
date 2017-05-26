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

root = jimlabPath("/") + "tests/images/noError/";
// Objet jimage RGBA
path = root + 'rgba.png';
jim = jimread(path);
equalizedJimage = jimhistEqual(jim);

// Matrice RGBA
im = jim.image;
equalizedImage = jimhistEqual(im);
assert_checkequal(equalizedJimage.image, equalizedImage);

// Objet jimage RGBA avec couleur de transparence à ignorer
path = jimlabPath("/") + 'tests/images/logoEnsim.png';
jim = jimread(path);
jim.transparencyColor = cat(3,0,0,255);
equalizedJimage = jimhistEqual(jim);

// Matrice RGBA avec couleur de transparence à ignorer
im = jim.image;
equalizedImage = jimhistEqual(im, cat(3,0,0,255));
assert_checkequal(equalizedJimage.image, equalizedImage);

//
fileList = dir(root);
nameList = fileList.name;
fileNumber = size(nameList);
fileNumber = fileNumber(1);

for i = 1:fileNumber
    path = root + nameList(i);
    jim = jimread(path);
    equalizedJimage = jimhistEqual(jim);
    equalizedImage = jimhistEqual(jim.image);
end
