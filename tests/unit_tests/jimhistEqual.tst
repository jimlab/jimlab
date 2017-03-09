 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
// <-- NO CHECK REF -->

s = filesep();
root = jimlabPath + s + 'tests' + s + 'images' + s + 'noError';
fileList = dir(root)
nameList = fileList.name
fileNumber = size(nameList)
fileNumber = fileNumber(1)

for i = 1:fileNumber
    path = root + s + nameList(i);
    jim = jimread(path);
    equalizedJimage = jimhistEqual(jim)
    equalizedImage = jimhistEqual(jim.image)
end
