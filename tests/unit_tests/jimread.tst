 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
//From a URL
url = 'https://webensim.univ-lemans.fr/ressources/icones/interface/Logoensim_2010_tr3.gif';
im = jimread(url);

//From a file, no error
global jimlabPath
root = jimlabPath + '\tests\images\noError';
fileList = dir(root)
nameList = fileList.name
fileNumber = size(nameList)
fileNumber = fileNumber(1)

for i = 1:fileNumber
    path = root + '\' + nameList(i);
    im = jimread(path);
end

//From a file, error
root = jimlabPath + '\tests\images\error';
fileList = dir(root);
nameList = fileList.name;
fileNumber = size(nameList);
fileNumber = fileNumber(1);
msg = 'jimread: Unexpected image type.'

for j = 1:fileNumber
    path = root + '\' + nameList(i);
    assert_checkerror(im = jimread(path),msg);
end
