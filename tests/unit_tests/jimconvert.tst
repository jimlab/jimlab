 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
// <-- NO CHECK REF -->

//List of images to test
root = jimlabPath("/") + 'tests/images/noError';
fileList = dir(root);
nameList = fileList.name;
fileNumber = size(nameList);
fileNumber = fileNumber(1);
s = filesep();

for i = 1:fileNumber
    path = root + s + nameList(i);
    jim = jimread(path);
    
    if (jim.encoding == 'rgba') then
        jgray = jimconvert(jim, 'gray');
        gray = jimconvert(jim.image, 'gray');
        jrgb = jimconvert(jim , 'rgb');
        rgb = jimconvert(jim.image, 'rgb');
        
    elseif (jim.encoding == 'rgb') then
        jgray = jimconvert(jim, 'gray');
        gray = jimconvert(jim.image, 'gray');
        
        //already rgb encoding
        msg = "%s: %s cannot be converted into rgb encoding.\n";
        name = jim.title + '.' + jim.mime;
        assert_checkerror("gray = jimconvert(jim , ""rgb"")", msg, [], "jimconvert",  name)
        
    elseif (jim.encoding == 'gray') then
        //jimconvert() cannot convert a gray encoding into a rgb or a gray encoding
        msg = "%s: %s cannot be converted into rgb encoding.\n";
        name = jim.title + '.' + jim.mime;
        assert_checkerror("rgb = jimconvert(jim , ""rgb"")", msg, [], "jimconvert",  name)
        msg = "%s: %s cannot be converted into gray encoding.\n";
        name = jim.title + '.' + jim.mime;
        assert_checkerror("gray = jimconvert(jim , ""gray"")", msg, [], "jimconvert", name)
    end
end

//Wrong second argument
msg = "%s: Argument #%d: rgb or gray expected.\n";
assert_checkerror("rgba = jimconvert(jim.image , ""rgba"")", msg, [], "jimconvert", 2)

//Wrong first argument
msg = "%s: Argument #%d: Wrong type of input argument.\n";
assert_checkerror("gray = jimconvert(""wrong"" , ""gray"")", msg, [], "jimconvert", 1)
