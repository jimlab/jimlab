//Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
 
// From an image file pre-loaded with jimread
global jimlabPath
imagePath = jimlabPath +'\help\images';

[img,imageProperties] = jimread(imagePath);

jimdisp(img);
jimdisp(img,'withbox');
jimdisp(img,imageProperties);
jimdisp(img,'withbox',imageProperties);

// From a path
jimdisp(imagePath);
jimdisp(imagePath,'withbox');
jimdisp(imagePath,properties);
jimdisp(imagePath,'withbox',properties);

// From a URL
imageURL = 'https://webensim.univ-lemans.fr/ressources/icones/interface/Logoensim_2010_tr3.gif'

jimdisp(imageURL);
jimdisp(imageURL,'withbox');
jimdisp(imageURL,properties);
jimdisp(imageURL,'withbox',properties);