 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
//From an URL
url = 'https://webensim.univ-lemans.fr/ressources/icones/interface/Logoensim_2010_tr3.gif';
im = jimread(url);

//From a file
global jimlabPath
root = 
path = jimlabPath + '/tests/images/logoEnsim.png';
RGBA = jimread(path);

path = jimlabPath + '/tests/images/logoEnsim_rgb.png';
RGB = jimread(path);

path = jimlabPath + '/tests/images/logoEnsim_gray.png';
gray = jimread(path);
