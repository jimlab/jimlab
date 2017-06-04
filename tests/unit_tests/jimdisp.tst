//Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE
//
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHIC -->

version = getversion()
os = getos()

// From an image file pre-loaded with jimread
//[m, mp] = libraryinfo("jimlablib");
//imagePath = getlongpathname(mp +"tests\images\noError\rgb.jpg");
//disp(imagePath);
imagePath = jimlabPath() +"\tests\images\noError\rgb.jpg";
jimage1 = jimread(imagePath);

jimdisp(jimage1);
jimdisp(jimage1,"box");
jimdisp(jimage1,,"info");
jimdisp(jimage1,"box","info");

// From a path
jimdisp(imagePath);
jimdisp(imagePath,"box");
jimdisp(imagePath,,"info");
jimdisp(imagePath,"box","info");

if ~(version == "scilab-5.5.2" & os == "Darwin")  then
    // From a URL
    imageURL = "https://webensim.univ-lemans.fr/ressources/icones/interface/Logoensim_2010_tr3.gif";
    
    jimdisp(imageURL);
    jimdisp(imageURL,"box");
    jimdisp(imageURL,,"info");
    jimdisp(imageURL,"box","info");
end

