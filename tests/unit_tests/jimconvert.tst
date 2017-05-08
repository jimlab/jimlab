 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
// <-- NO CHECK REF -->

    //Conversion of a RGBA encoded image
    
path = jimlabPath("/") + 'tests/images/noError/rgba.png';
jimage = jimread(path);
image = jimage.image;
//in rgb without transparencyColor 
jrgb = jimconvert(jimage, 'rgb');
rgb = jimconvert(image, 'rgb');
jimage.transparencyColor = cat(3, 200, 200, 200);
jrgb = jimconvert(jimage, 'rgb')
//in rgb with a transparencyColor
tColor = cat(3, 200, 200, 200);
jrgb = jimconvert(jimage, 'rgb', tColor);
rgb = jimconvert(image, 'rgb', tColor);
//in gray without transparencyColor
jgray = jimconvert(jimage, 'gray');
gray = jimconvert(image, 'gray');
jimage.transparencyColor = cat(3, 200, 200, 200);
jgray = jimconvert(jimage, 'gray')
//in gray with a transparencyColor
tColor = cat(3, 200, 200, 200);
jgray = jimconvert(jimage, 'gray', tColor);
gray = jimconvert(image, 'gray', tColor);


    //Conversion of a RGB encoded image
    
path = jimlabPath("/") + 'tests/images/noError/rgb.png';
jimage = jimread(path);
image = jimage.image;
//in gray without transparencyColor
jgray = jimconvert(jimage, 'gray');
gray = jimconvert(image, 'gray');
jimage.transparencyColor = cat(3, 200, 200, 200);
jgray = jimconvert(jimage, 'gray');
//in gray with a transparencyColor
tColor = cat(3, 200, 200, 200);
jgray = jimconvert(jimage, 'gray', tColor);
gray = jimconvert(image, 'gray', tColor);

    //Conversion of a boolean image

image = (rand(20, 20) > 0.5)
gray = jimconvert(image, 'gray')

    //Errors

//Wrong first argument
msg = "%s: Argument #%d: Wrong type of input argument.\n";
msg = msprintf(msg, "jimconvert", 1);
assert_checkerror("gray = jimconvert(""wrong"" , ""gray"")", msg)

//Wrong second argument
msg = "%s: Argument #%d: rgb or gray expected.\n";
msg = msprintf(msg, "jimconvert", 2);
assert_checkerror("rgba = jimconvert(jimage.image , ""rgba"")", msg)

//Wrong third argument
path = jimlabPath("/") + 'tests/images/noError/rgba.png';
jimage = jimread(path)
msg = "%s: Argument #%d: hypermatrix with 3 components expected.\n";
msg = msprintf(msg, "jimconvert", 3);
assert_checkerror("rgba = jimconvert(jimage.image , ""rgb"", 38)", msg)

msg = "%s: Argument #%d: Components of transparencyColor must be in the intervalle [0:255].\n";
msg = msprintf(msg, "jimconvert", 3);
tColor = cat(3, 400, 3, 3);
assert_checkerror("rgba = jimconvert(jimage.image , ""gray"", tColor)", msg)

//Converting a gray image into gray encoding
path = jimlabPath("/") + 'tests/images/noError/gray.jpg'
jimage = jimread(path);
msg = "%s: %s cannot be converted into gray encoding.\n";
name = jimage.title + '.' + jimage.mime;
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage , ""gray"")", msg);
msg = "%s: %s cannot be converted into gray encoding.\n";
name = 'your image';
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage.image , ""gray"")", msg);

//Converting a gray or a rgb image into rgb encoding
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = jimage.title + '.' + jimage.mime;
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage , ""rgb"")", msg);
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = 'your image';
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage.image , ""rgb"")", msg);

path = jimlabPath("/") + 'tests/images/noError/rgb.jpg'
jimage = jimread(path);
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = jimage.title + '.' + jimage.mime;
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage , ""rgb"")", msg);
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = 'your image';
msg = msprintf(msg, "jimconvert", name)
assert_checkerror("gray = jimconvert(jimage.image , ""rgb"")", msg);



