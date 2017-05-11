//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- NO CHECK REF -->

// From an jimage file, noError

s = filesep();
OriginPath = pwd(); 
imPath = jimlabPath() + s +"tests"+ s+"images"+s+"noError";// Images's directory
dirPath = jimlabPath() + s + "tests"+s+"jimwriteTest"; // Writting directory
mkdir(dirPath);// Creation of dirPath
cd(dirPath);
FileList = dir(imPath)// 
NameList = FileList.name;
FileNumber = size(NameList);
w = 1;

MIME = ["jpg","png","gif","bmp"];
Encoding = ["RGB","RGBA","GRAY"];

// Simple call

im = jimread(imPath + s + NameList(1));
jimwrite(im);

// With path containing name and MIME

for (i = 1:FileNumber(1))
    im = jimread(imPath + s + NameList(i));
    jimwrite(im,dirPath + s + NameList(i));
    
// Wrtting with a new type MIME en Encoding
    select i
    case 1 then
        m = 1;
        e = 3;
    case 2 then
        m = 4;
        e = 3;
    case 3 then
        m = 2;
        e = 2;
    else
        w = 0;
end
if(w)
    jimwrite(im,dirPath,Encoding(e),MIME(m));
end
end

// Writting from an RGB hyper-matrix

load(jimlabPath() + s +"tests"+s+"images"+s+"mat.data");
jimwrite(mat,dirPath + s + "matImage","rgb","jpg");

cd(OriginPath);
rmdir(dirPath,'s');


